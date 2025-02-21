#!/bin/bash

if [[ "$1" != "--local" ]]; then
XXX="git gum curl screen valkey micro nginx amfora mosquitto mosquitto-clients mosquitto-dev htop mc figlet lua5.4 lua-http lua-redis luarocks ii slashem bsdgames cmatrix sl cbonsai build-essential ruby-full";

for v in $*
do
	if [[ "$v" == "--gui" ]]; then
		XXX+=" awesome awesome-extra smenu xinit xorg kitty vlc pcmanfm firefox-esr feh pulseaudio ";	
	fi
	if [[ "$v" == "--ssl" ]]; then
		XXX+=" python3-certbot-nginx ";
	fi
done

echo "# downloading source."

echo "## prompt"
if [[ ! -d ~/.bash-git-prompt ]]; then
	git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
fi

# get ipfs
wget https://dist.ipfs.tech/kubo/v0.33.2/kubo_v0.33.2_linux-amd64.tar.gz
tar -xzf kubo_v0.33.2_linux-amd64.tar.gz
cd kubo

echo "# installing MEA OS core."

# install core
echo "##########################################"
echo "#                                        #"
echo "#  ROOT PASSWORD TO INSTALL MEA OS CORE  #"
echo "#                                        #"
echo "##########################################"

su -c "apt update && apt upgrade -y -qq && apt install -y -qq $XXX && \
gem install sinatra redis pry amatch valkey-objects ipfs-api rufus-lua && \
echo '' > /etc/issue && \
echo '' > /etc/issue.net && \
echo '' > /etc/motd && \
echo 'figlet -f shadow \"MEA OS\"' > /bin/logo && \
echo 'for f in /home/*/.mea/boot.sh; do chmod +x \$f && source \$f; done' > /bin/autostart && \
chmod +x /bin/logo && \
chmod +x /bin/autostart && \ 
echo '@reboot root /bin/autostart' >> /etc/crontab && \
./install.sh
"

echo "# cleanup source."

# cleanup
cd ..
rm -fR kubo
rm kubo_v0.33.2_linux-amd64.tar.gz

fi # if $1 != --local

name=mea
d=~/.$name

echo "# creating mea profile"

rm -fR $d
mkdir -p $d $d/screen

echo "screen -t '>' 1 lua # run you process here." > $d/screen/sh

# stock enviroment
f=$d/env.sh

export TOP='htop'
export EDITOR='micro'
export INDEX=notes.txt
echo "export TOP='$TOP'" > $f
echo "export EDITOR='$EDITOR'" >> $f
echo "export INDEX='$INDEX'" >> $f
touch $d/lock

cat <<EOF > $d/boot.sh
echo "MEA BOOT: `date`"
EOF
#cat $d/boot.sh

echo "# adding profile."

# configure
if [[ "$(cat ~/.profile | grep nomad)" == "" ]]; then
cat <<EOF >> ~/.profile
# MEA OS BEGIN
# lock for user config
if [[ -f $d/lock ]]; then
        $EDITOR $d/env.sh
        rm $d/lock
fi
# define utilities
source $d/env.sh
# set prompt
if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source "$HOME/.bash-git-prompt/gitprompt.sh"
fi
# attach to running screen
if [ -z "\$STY" ]; then (screen -Dr || screen); fi
# MEA OS END
EOF
fi

echo "# adding session."

cat <<EOF > ~/.screenrc
shell -\${SHELL}
caption always "[%H] %w"
defscrollback 1024
startup_message off
hardstatus on
hardstatus alwayslastline
screen -t '#' 0 \$EDITOR \$INDEX
source $d/screen/sh
source $d/screen/2
source $d/screen/3
source $d/screen/4
source $d/screen/5
source $d/screen/6
source $d/screen/7
#screen -t IPFS 7 ipfs daemon --enable-namesys-pubsub
source $d/screen/8
#screen -t VK 8 valkey-cli monitor
screen -t TOP 9 \$TOP
select 0
EOF
#cat ~/.screenrc

echo "# adding aliases."

cat <<EOF > ~/.bash_aliases
#alias sudo='su -c'
alias edit='\$EDITOR'
alias freshen='su -c "apt update -q && apt-get upgrade -y -q"'
alias installed='su -c "dpkg-query -l"'
EOF
#cat ~/.bash_aliases

sync

echo "# MEA OS installation complete."
echo "################"
echo "#              #"
echo "#  REBOOT NOW  #"
echo "#              #"
echo "################"
