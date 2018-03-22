#!/bin/bash
##This script is to  monitor appservices
#Reference JIRA: OPS-7060

PROGNAME=`basename $0`
VERSION="Version 1.0"

ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3

interval=1

print_version() {
    echo "  $PROGNAME $VERSION "
    
}

print_usage() {
    echo "Arguments are missing:  USAGE: $PROGNAME -u <Enter URL> "

}

print_help() {
   # print_version $PROGNAME $VERSION
    echo ""
    echo "$PROGNAME is a Nagios plugin to monitor URL health status."
   # echo "use of /proc/stat and calculates it through Jiffies rather than"
   # echo "using another frontend tool like iostat or top."
   #echo "When using optional warning/critical thresholds all values except"
   # echo "idle are aggregated and compared to the thresholds. There's"
   # echo "currently no support for warning/critical thresholds for specific"
    echo "usage parameters."
    echo ""
   # echo "$PROGNAME [-i/--interval] [-w/--warning] [-c/--critical]"
    echo "$PROGNAME [-u/--url]"
    echo ""
    echo "Options:"
    echo "  --version|-v)"
    echo "    Defines version"
    echo "  --help|-h)"
    echo "    Help..."
    echo "  --host|-H)"
    echo "    Defines hostname" 
    exit $ST_UK
}

sleep $interval
if [ -z "$1" ];then print_help;exit $ST_UK;fi

sleep $interval
#if [ $# -ne 2 ];then print_help;fi
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
          HOST=$2
	    if [ -z "$2" ];then print_usage;exit $ST_UK;fi
            URL="http://$HOST:81?serviceconfig"
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
    #if [ "$#" -gt 2 ]; then shift; fi
    shift
done

apppage_result=$(curl -sL -w "%{http_code}\\n" $URL -o /dev/null)
if [ $apppage_result -eq 200 ];
	then
	echo "$apppage_result OK: appservices up"
	exit $ST_OK
	else
	if [ $apppage_result -ne 200 ];
	then
	echo "$apppage_result CRITICAL: appservices down"
	exit $ST_CR
	fi
fi

#End

