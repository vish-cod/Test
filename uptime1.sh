#!/bin/bash


#echo "Keep it up"


user="root"
server="172.23.3.95"
path="/srv/www/htdocs/web/uptime-$(date +%d-%b-%Y).txt"


sorted1=$(date +%d-%b-%Y)
sorted=$(date +%d-%b-%Y-%T)

output=/srv/www/htdocs/web/uptime-$sorted1.txt

function IP {
ip -o -4 addr show dev eth0 | awk '{split($4, x , "/"); print x[1]}'
}

function uptime1 {
uptime | awk '{split($3, a, ","); print a[1], "=" " ""Days" }'
}

function alloted {
free -h --giga | grep 'Mem:' | awk '{print($2)}'
}

function occupied {
free -h --giga | grep 'Mem:'| awk '{print($3)}'
}

function total_space {
df -h | grep '/dev/md4' | awk '{print($2)}' 
}

function space_usage {
df -h | grep '/dev/md4' | awk '{print($3)}'
}

function space_perc {
df -h | grep '/dev/md4' | awk '{print($5)}'
}

function remaining_space {
df -h | grep '/dev/md4' | awk '{print($4)}'
}

function typem {
lscpu | grep 'Model name:' | awk '{print($4)}'
}

mtype=$(case $(typem) in
KVM) echo "Virtual Machine" ;;
*) echo "Independent" ;;
esac
)

function threshold {
uptime | awk '{split($3, a, "," ); print a[1]}'
}

if [[ $threshold -gt 35  ]];
then
result="!!ALERT!!ATTENTION REQUIRED"
else
result="Normal"
fi



#echo "Working Server IP IS : $(IP)"

name=$(case $(IP) in
172.20.4.97|172.20.4.31|172.20.4.103) echo "AVON" ;;
172.20.4.111|172.20.4.114|172.20.4.113) echo "BALMER LAWRIE" ;;
172.24.0.134|172.24.0.148) echo "CLOVIA" ;;
172.23.3.93|172.23.3.94) echo "EKACARE" ;;
172.20.4.92|172.20.4.93|172.20.4.102) echo "FIA" ;;
172.20.4.118|172.20.4.119) echo "RECON" ;;
172.20.4.105|172.20.4.108) echo "INDMONEY" ;;
172.20.4.81|172.20.4.82|172.20.4.86|172.20.4.87|172.20.4.88|172.20.4.89|172.20.4.90) echo "ZOMATO-GGN" ;;
172.23.3.81|172.23.3.82|172.23.3.86|172.23.3.87) echo "ZOMATO-BLR" ;;
172.20.4.115|172.20.4.116|172.20.4.120|172.20.4.113) echo "PHILIPS" ;;
172.20.4.13|172.20.4.21|172.20.4.20) echo "JK/WELBILT" ;;
172.24.0.161|172.24.0.162) echo "MMT-NOIDA" ;;
172.24.0.155|172.24.0.156) echo "SBI" ;;
172.24.0.151|172.24.0.164) echo "HUL-NOIDA" ;;
172.23.3.99|172.23.3.100) echo "HUL-BLR" ;;
172.19.4.188) echo "MICROMAX" ;;
172.20.4.125) echo "HR" ;;
172.20.4.106|172.20.4.110) echo "MPL" ;;
172.23.3.95) echo "BLR Local Test" ;;
*) echo "!! SomeThing Is Wrong Please check the $(IP) is Not Matching !!"

esac)



header=$(echo "Dialer IP | UPTIME | RAM ALLOTED | RAM OCCUPIED | HDD TOTAL | HDD USAGE | HDD % | HDD REMAINING | PROCESS NAME | MACHINE TYPE | DATE | UPTIME Threshold | DESCRIPTION | ACTION REQUIRED | ") #>> $output
data=$(echo "$(IP) | $(uptime1) | $(alloted) |   $(occupied) | $(total_space) | $(space_usage) | $(space_perc) | $(remaining_space) | ${name} | ${mtype} | ${sorted} | ${result} | | ") # >> $output

# Replace 'http://example.com/receive.php' with the actual URL of your PHP script
#bash_script_output=$(your_bash_script_command)
#curl -X POST http://172.23.3.95/web/php/receive1.php -d "Test Data"

#encoded_data1=$(printf "%s" "$header" | jq -s -R -r @uri)
#encoded_data2=$(printf "%s" "$data" | jq -s -R -r @uri)

encoded_data1=$(php -r "echo urlencode('$header');")
encoded_data2=$(php -r "echo urlencode('$data');")


#curl "http://172.23.3.95/web/php/receive1.php?data=$encoded_data1"
curl "http://172.23.3.95/web/php/receive1.php?data=$encoded_data2"

#ssh "$user"@"$server" "echo '$header' > $path ; echo '$data' >> $path"

#echo "This is YOur output ==::  "
