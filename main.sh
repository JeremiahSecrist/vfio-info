#!/bin/bash

export LIBVIRT_DEFAULT_URI='qemu:///system'

virsh list --all
read -rp "Please type in the VM name exactly: " domain
if sudo virsh domstate "${domain}"
then
  clear
  echo -e "\`\`\`\n${domain} XML dump:"
  sudo virsh dumpxml "${domain}" | curl -F 'clbin=<-' https://clbin.com
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
  echo "Libvirt ${domain} logs:"
  curl -F 'clbin=<-' https://clbin.com < "/var/log/libvirt/qemu/${domain}".log
  echo "\`\`\`"
  exit
fi
