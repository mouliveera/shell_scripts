#!/bin/bash

# This Script is a to check service status on the cluster of servers

#Dev_Clusterhname = dev-repbiz-backend-i-02cbe7e0646df8a92.j.r4e-dev dev-repbiz-frontend-i-083e7fa0c6e2fdd3d.j.r4e-dev

rm -rf /tmp/service_status.txt.  #remove files existing before it gets executed
while [[ $# -eq 0 ]]; do
        echo "USAE: $0 <service_name>"
        exit 1
        done
#sname=repbiz

sname=$1

for hname in `cat /etc/nagios4/dev-repbiz.cfg`;do

if [ ${sname} == "repbiz" ]

then

nprocess=`ssh $hname "ps -ef | grep -v grep | grep repbiz | wc -l"`        

if (($nprocess > 0 ));

        then

        echo "$hname Service:$sname is UP" 

        else

echo "$hname Service:$sname is DOWN"

        fi

fi

done >  /tmp/service_status.txt      #Copying the result to service_status.txt file

######## 

#nhost=$(cat /Users/mouliveera/dev_repbiz_host|wc -l)
nhost=$(cat /etc/nagios4/dev-repbiz.cfg|wc -l)
upservices=$(cat /tmp/service_status.txt |awk '{print $1 "  " $4}' |grep -i up)

downservices=$(cat /tmp/service_status.txt |awk '{print $1 "  " $4}' |grep -i down)

########

nservices=$(cat /tmp/service_status.txt |awk '{print $1 "  " $4}'|wc -l)

nupservice=$(cat /tmp/service_status.txt |awk '{print $1 "  " $4}' |grep -i up |wc -l) # check number of UP processing servers

ndownservice=$(cat /tmp/service_status.txt |awk '{print $1 "  " $4}' |grep -i down |wc -l) # check number of DOWN processing servers
########

# Condition to verify the service status list on instances
if [[ $nhost < $nupservice ]];then
	echo "WARNING: Service is Down on $ndownservice instances"
	exit 1
	else
		if [[ $nhost -eq $ndownservice ]]; then
			echo "CRITICAL: Service is down ON all instances"
			exit 2;
		fi
			if [[ $nhost -eq $nupservice ]];then
			echo "OK: Service $sname UP on all instances"
			exit 0
			fi
fi
	
#End
