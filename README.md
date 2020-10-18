# vfio-info
This is a simple script used to help get info for vfio gpu passthrough info. 
# Usage
Its Main usage is for the vfio discord that helps people with issues reguard gpu passthrough for virtual machines. 
It does this by gathering all the information reguarding your systems configuration and uploading it to clbin and returning you the link to upload in chat
Feel Free to look over the script before running it as I personaly recomend.
# How to:
Preferably you would want to just download and run it in the terminal, 
but as this is a help tool dealing with individuals of varying skill sets I have also linked below a simple way to run it.

Simply copy and paste the following into your terminal:

` [ -f "info-vfio.sh" ] || ( curl -sL https://raw.githubusercontent.com/creatorofthesky/vfio-info/main/main.sh > info-vfio.sh && chmod +x info-vfio.sh ; cksum info-vfio.sh ) `

This will not download or output if a file exists. 
To make sure it has not been modified make sure it outputs:
2280010098 1300 info-vfio.sh

Then run:
`sudo ./info-vfio.sh:`
