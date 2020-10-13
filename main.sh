#!/bin/bash

export LIBVIRT_DEFAULT_URI='qemu:///system'
readonly pasteurl="https://clbin.com"
readonly pasteheader="clbin=<-"
readonly loglocation="/var/log/libvirt/qemu/"
readonly qemuconflocation="/etc/libvirt/qemu.conf"

upload(){
  curl -F ${pasteheader} ${pasteurl}
}

scrape(){
  xmldump="$(upload < <(virsh dumpxml "${domain}") &)"
  libvirtstatus="$(upload < <(systemctl status libvirtd) &)"
  libvirtlogs="$(upload < <(journalctl -b -u libvirtd) &)"
  qemuconf=$(awk '!/^ *#/ && NF' ${qemuconflocation})
  if [[ -n ${qemuconf} ]]; then
    qemuconf="$(upload < "${qemuconf}" &)"
  fi
  domlogs="$(upload < <("${loglocation}/vm1.log") &)"
  wait
}

output(){
  clear
  printf "${domain} XML dump:\n%s${xmldump}\n"
  printf "libvirt status:\n%s${libvirtstatus}\n"
  printf "Libvirt logs:\n%s${libvirtlogs}\n"
  if [[ -n ${qemuconf} ]]; then
   printf "qemu.conf:\n%s${qemuconf}\n"
  fi
  printf "Libvirt ${domain} logs:\n%s${domlogs}\n"
}

main(){
  clear
  virsh list --all
  read -rp "Please type in the VM name exactly: " domain
  if virsh domstate "${domain}" > /dev/null
  then
    printf "\nUploading...\n"
    scrape 2>/dev/null
    output
    exit
  fi
}

if [[ $EUID -ne 0   ]]; then
  echo "$(basename "${0}") must be run as root."
  exit 1
else
  #Program entry point
  main
fi
