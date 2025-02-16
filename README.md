```
  \  | ____|    \      _ \   ___| 
 |\/ | __|     _ \    |   |\___ \ 
 |   | |      ___ \   |   |      |
_|  _|_____|_/    _\ \___/ _____/ 
```
- Based on the venerable Debian code base and repositories, because writing documentation is hard, and they did a great job of it already.
- Focused on terminal-driven tool-centered productivity, because you shouldn't **need** a machine.
- Built with the interplanetary filesystem and noSQL future in mind, because [SQL](https://www.cisa.gov/known-exploited-vulnerabilities-catalog?search_api_fulltext=SQL&field_date_added_wrapper=all&field_cve=&sort_by=field_date_added&items_per_page=20&url=) sucks.
- Integrated VM utility which creates and manages a USB-portable persistent [virtual](https://www.qemu.org/) machine [image](https://en.wikipedia.org/wiki/Qcow) (qcow2).
- Maximally portable using any x86_64 virtual machine emulator ([QEMU](https://www.qemu.org/download/), [VirtualBox](https://www.virtualbox.org/wiki/Downloads), [vmware](https://www.vmware.com/products/desktop-hypervisor/workstation-and-fusion)) to boot on any platform.

## MEA Desktop Enviroment
- [Awesome](https://wiki.debian.org/Awesome): A simple and intuitive tabbed window manager.
- Finally, A distro that ships with [VLC](https://manpages.debian.org/bookworm/vlc-bin/vlc.1.en.html) as it's flagship media player!
- Fireox, because it's smaller than chrome and better than [surf](https://surf.suckless.org/).
- PCmanFm, because graphical filemanagers exist, and it's alright.
- That's it.

## QUICKSTART
1. First, begin by generating a base image.
```
git clone https://github.com/mea-OS
cd mea-OS
./vm --build
# 1. set root password
# 2. create user and set password
# 3. set timezone
# 4. partition
# 5. install base system with ssh server
# 6. finish
# ... install debian base and Power Off Virtual Machine when finished. 
# After Boot and loginlogin, run the os utility to install the overlay.
os
# Or, optionally install the desktop.
os --gui
# Reboot when done.
```
3. After your reboot completes, you will be prompted to edit your session configuration.
4. Congradulations, you're done.

## VM utility (host)
- `./vm --qemu` boots your image and opens a port for ssh access.
- `./vm --connect` connects via ssh to the running image.
- `export PORT=4567; ./vm --proxy` proxies the application on guest port 80 to host port 4567.
- `./vm --mount` mounts the image on the host for manipulation.
- `./vm --umount` un-mounts the image from the host.
- `./vm --save snapshot` save a copy of the image called snapshot.
- `./vm --load snapshot` load the copy of the image called snapshot.  

