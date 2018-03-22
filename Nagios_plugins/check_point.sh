#!/bin/bash
#OPS-7059
#Nagios plugin validate ip of a host and its cname

PROGNAME=`basename $0`
VERSION="Version 1.0"

#Define exit codes
ST_OK=0
ST_WR=1
ST_CR=2
ST_UK=3

interval=1

#Function to print version
print_version() {
    echo "  $PROGNAME $VERSION "
    
}
#Function :Usage statement
print_usage() {
    echo "Arguments are missing:  USAGE: $PROGNAME [-H|--host] <HOST> [-A|--cname] <ALIASNAME> "

}
#Function: Help
print_help() {

    echo ""
    echo "$PROGNAME is a Nagios plugin validate ip of a host and its cname."
    echo "usage parameters."
    echo ""
    echo "$PROGNAME -H|--host HOST -A|--cname ALIASNAME"
    echo ""
    echo "Options:"
    echo "--version|-v)"
    echo "Defines version"
    echo "--help|-h)"
    echo "Help..."
    echo "--host|-H)"
    echo "Defines hostname" 
    echo "--cname|-A)"
    echo "Defines host alias" 
    exit $ST_UK
}

sleep $interval

#Condition to check number input arguments
if [ -z "$1" ];then print_help;exit $ST_UK;fi

#Input validation
while test -n "$1"; do
    case "$1" in
        -h|--help)
            print_help
            exit $ST_UK
            ;;
        -V|--version)
            print_version $PROGNAME $VERSION
            exit $ST_UK
            ;;
    --host|-H)
          HOST="$2"
          if [ -z "$2" ];then print_usage;exit $ST_UK;fi
            shift
            ;;
        --cname|-A)
          ALIAS="$2"
          if [ -z "$2" ];then print_usage;exit $ST_UK;fi
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

# H - represents ip of host
# A - represnts ip of alias/cname

H=$(host $HOST| sed -nre 's/.* has address //p'|head -1)
A=$(host $ALIAS| sed -nre 's/.* has address //p'|head -1)

# If condition to validate host and alias are pointing
# to same ip address
if [ "$H" == "$A" ];then
    echo "OK:  $HOST and $ALIAS are pointing to same haproxy"
    exit $ST_OK
    else
    echo "CRITICAL: $HOST and $ALIAS are pointing to pointing to different ip's"
    exit $ST_CR
fi

#EOF

#If the host and its alias havign the same IP
