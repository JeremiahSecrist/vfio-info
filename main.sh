#!/bin/bash

# Set the default Libvirt URI
export LIBVIRT_DEFAULT_URI='qemu:///system'

if ! groups | grep -qe libvirt; then
    echo "You're not in the libvirt group, you may be asked for your sudo password."
    sudo=sudo
fi
    $sudo virsh list --all
    read -p "Please type in the VM name exactly: " VM
if $sudo virsh list --all --name | grep -q "${VM}"
    then
        clear
        echo "${VM} XML dump:"
        $sudo virsh dumpxml "${VM}" | curl -F 'clbin=<-' https://clbin.com
        sleep 0.5
        echo "libvirt status:"
        systemctl status libvirtd | curl -F 'clbin=<-' https://clbin.com
        sleep 0.5
        echo "Libvirt logs:"
        journalctl -b -u libvirtd | curl -F 'clbin=<-' https://clbin.com
        sleep 0.5
        echo "qemu.conf:"
        grep --invert-match -e "^# " -e "^ "- /etc/libvirt/qemu.conf | grep -e "[a-z]" | curl -F 'clbin=<-' https://clbin.com
        sleep 0.5
        echo "Libvirt ${VM} logs:"
        cat /var/log/libvirt/qemu/"${VM}".log | curl -F 'clbin=<-' https://clbin.com
        exit
else
    echo "ERROR Incorrect VM name!"
fi    
