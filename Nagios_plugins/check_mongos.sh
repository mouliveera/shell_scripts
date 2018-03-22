#!/bin/bash
#Jira OPS-7295
# Plugin to validation ip and autoscaling groups
PROGNAME=`basename $0`
VERSION="Version 1.0"

ST_OK=0  # Status OK
ST_WR=1  # Status WARNING
ST_CR=2  # Status CRITICAL
ST_UK=3  # Status UNKNOWN

interval=1

print_version() {
    echo "  $PROGNAME $VERSION "
    
}

print_usage() {
    echo "Arguments are missing:  USAGE: $PROGNAME -H|--host <hostname>" 

}

print_help() {
    echo ""
    echo "$PROGNAME is a Nagios plugin to validation ip and autoscaling groups."
    echo "usage parameters."
    echo ""
    echo "$PROGNAME [-H|hostname"]
    echo ""
    echo "Options:"
    echo "--version|-v)"
    echo "Defines version"
    echo "--help|-h)"
    echo "Help..."
    echo "-H|--host)"
    echo "Defines hostname"
    exit $ST_UK
}

sleep $interval
#if [ -z "$1" ];then print_usage;exit $ST_UK;fi

while test -n "$1"; do
    case "$1" in
        --help|-h)
            print_help
            exit $ST_UK
            ;;
        --version|-v)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
        --host|-H)
          hostlist=$2
            shift
            ;;
        --default)
           DEFAULT=YES
            ;;
            *)
            echo "Unknown argument: $1"
            print_help
            exit $ST_UK
            ;;
    esac

    shift
done

sleep $interval

host_count=$(echo $hostlist|sed 's/,/\n/'|wc -l) #check host count from the list
if [[ $host_count -eq 1 ]]; then
    #statements
    nhost=$(echo $hostlist |sed 's/,/\n/'|head -1)

#Get InstanceIP
get_instance_ip() {
	host $nhost|grep "has address" |cut -d" " -f4
}

#Get instance id with ipaddress
get_instanceid() {
	aws ec2 describe-instances --region us-east-1 --filter "Name=private-ip-address,Values=$(get_instance_ip)" |grep InstanceId|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}

#Get AutoScalingGroupName
get_auto_group() {
	aws autoscaling describe-auto-scaling-instances --region us-east-1  --instance-ids $(get_instanceid) |grep AutoScalingGroupName|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}

echo "OK: $nhost is with ip:$(get_instance_ip):: $nhost with AutoScalingGroupName:$(get_auto_group)"
exit 0
#######Multihost condition
elif [ $host_count == 2 ];
    then
    nhost=$(echo $hostlist |sed 's/,/\n/'|head -1)
    nhost2=$(echo $hostlist |sed 's/,/\n/'|tail -1)

#Get InstanceIP
get_instance_ip() {
        host $nhost|grep "has address" |cut -d" " -f4
}

#Get instance id with ipaddress
get_instanceid() {
        aws ec2 describe-instances --region us-east-1 --filter "Name=private-ip-address,Values=$(get_instance_ip)" |grep InstanceId|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}

#Get AutoScalingGroupName
get_auto_group() {
        aws autoscaling describe-auto-scaling-instances --region us-east-1  --instance-ids $(get_instanceid) |grep AutoScalingGroupName|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}


#Get InstanceIP next host
get_sec_instance_ip() {
	host $nhost2|grep "has address" |cut -d" " -f4
}

#Get instance2 id with ipaddress
get_sec_instanceid() {
aws ec2 describe-instances --region us-east-1 --filter "Name=private-ip-address,Values=$(get_sec_instance_ip)" |grep InstanceId|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}

#Get instance2 AutoScalingGroupName
get_sec_auto_group() {
    aws autoscaling describe-auto-scaling-instances --region us-east-1  --instance-ids $(get_sec_instanceid) |grep AutoScalingGroupName|cut -d':' -f2| sed -e 's/"//g' -e 's/,//g'
}

if [ "$(get_instance_ip)" != "$(get_sec_instance_ip)" -a "$(get_auto_group)" == "$(get_sec_auto_group)" ];
	then 
	echo "OK: $nhost, $nhost2 are with different ip's:::they are belongs to AutoScalingGroupName:$(get_sec_auto_group)"
        exit $ST_OK
	elif [ "$(get_instance_ip)" == "$(get_sec_instance_ip)" -a "$(get_auto_group)" == "$(get_sec_auto_group)" ];then
	echo "CRITICAL: $nhost, $nhost2 are with same ip:::they are belongs to AutoScalingGroupName:$(get_sec_auto_group)"
	exit $ST_CR
fi
		
fi

#END

#Usage of the code
#Check description:

#Thresholds: Warning = 7300sec , Critical = 8000sec
#If the snapshot fails to take in 8000sec[2.22hrs] it will alert us with CRITICAL notification
#If the snapshot has taken with in the threshold 7300sec[approx 2hrs], status of the service will be OK, it displays when the snapshot has taken and shapshot age.

#Ex: 
#Status Information: | OK - Recent snapshot has taken @ Sun Mar 18 20:00:01 PDT 2018, snapshot age is 1h:0m:0s
