#!/bin/bash

XXX="";

for v in $*
do
	if [[ "$v" == "--gui" ]]; then
		XXX+="awesome awesome-extra xinit xorg kitty vlc pcmanfm firefox-esr feh pulseaudio";	
	fi
done

echo "# downloading ipfs source."

# get ipfs
wget -q https://dist.ipfs.tech/kubo/v0.33.2/kubo_v0.33.2_linux-amd64.tar.gz
tar -xzf kubo_v0.33.2_linux-amd64.tar.gz
cd kubo

echo "# installing MEA OS core."

# install core
echo "##########################################"
echo "#                                        #"
echo "#  ROOT PASSWORD TO INSTALL MEA OS CORE  #"
echo "#                                        #"
echo "##########################################"

su -c "apt update && apt upgrade && apt install -y -q git curl screen valkey \
micro htop mc figlet lua5.4 lua-http lua-redis luarocks ii \
slashem bsdgames cmatrix sl cbonsai build-essential ruby-full $XXX && \
gem install sinatra redis pry amatch valkey-objects ipfs-api rufus-lua && \
echo  '' > /etc/issue && \
echo '' > /etc/issue.net && \
echo '' > /etc/motd && \
echo 'figlet -f shadow \"MEA OS\"' > /bin/logo && \
bash install.sh
"

echo "# cleanup ipfs source."

# cleanup
cd ..
rm -fR kubo
rm kubo_v0.33.2_linux-amd64.tar.gz

echo "# adding profile."

# configure
if [[ "$(cat ~/.profile | grep nomad)" == "" ]]; then
cat <<EOF >> ~/.profile
export TOP='top'
export EDITOR='nano'
export INDEX=index.txt

if [ ! -d ~/.nomad ]; then
  mkdir ~/.nomad ~/.nomad/screen
  echo "screen -t '>' 1 lua # run you process here." > ~/.nomad/screen/sh
  f=~/.nomad/env.sh
  echo "export TOP=\$TOP" > \$f
  echo "export EDITOR=\$EDITOR" >> \$f
  echo "export INDEX=\$INDEX" >> \$f
  touch ~/.nomad/lock
fi

if [[ -f ~/.nomad/lock ]]; then
        $EDITOR ~/.nomad/env.sh
        rm ~/.nomad/lock
fi

source ~/.nomad/env.sh

if [ -z "\$STY" ]; then (screen -Dr || screen); fi
EOF

echo "# adding session."

cat <<EOF > ~/.screenrc
shell -\${SHELL}
caption always "[%H] %w"
defscrollback 1024
startup_message off
hardstatus on
hardstatus alwayslastline
screen -t '#' 0 \$EDITOR \$INDEX
source ~/.nomad/screen/sh
source ~/.nomad/screen/2
source ~/.nomad/screen/3
source ~/.nomad/screen/4
source ~/.nomad/screen/5
source ~/.nomad/screen/6
source ~/.nomad/screen/7
#screen -t IPFS 7 ipfs daemon --enable-namesys-pubsub
source ~/.nomad/screen/8
#screen -t VK 8 valkey-cli monitor
screen -t TOP 9 \$TOP
select 0
EOF

echo "# adding aliases."

cat <<EOF > ~/.bash_aliases
alias sudo='su -c'
alias edit='\$EDITOR'
alias freshen='su -c "apt update -q && apt-get upgrade -y -q"'
alias installed='su -c "dpkg-query -l"'
EOF
fi

sync

echo "# MEA OS installation complete."
echo "###############################################"
echo "#                                             #"
echo "#  YOU MAY NOW POWER OFF THE VIRTUAL MACHINE  #"
echo "#                                             #"
echo "###############################################"
