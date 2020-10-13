#!/bin/bash

export LIBVIRT_DEFAULT_URI='qemu:///system'

virsh list --all
read -rp "Please type in the VM name exactly: " answer
if sudo virsh domstate "${answer}"
then
  clear
  echo -e "\`\`\`\n$answer XML dump:"
  sudo virsh dumpxml "$answer" | curl -F 'clbin=<-' https://clbin.com
  sleep 1
  echo "libvirt status:"
  systemctl status libvirtd | curl -F 'clbin=<-' https://clbin.com
  sleep 1
  echo "Libvirt logs:"
  journalctl -b -u libvirtd | curl -F 'clbin=<-' https://clbin.com
  sleep 1
  echo "qemu.conf:"
  grep --invert-match -e "^# " -e "^ "- /etc/libvirt/qemu.conf | grep -e "[a-z]" | curl -F 'clbin=<-' https://clbin.com
  sleep 1
  echo "Libvirt $answer logs:"
  curl -F 'clbin=<-' https://clbin.com < "/var/log/libvirt/qemu/${answer}".log
  echo "\`\`\`"
  exit
fi
