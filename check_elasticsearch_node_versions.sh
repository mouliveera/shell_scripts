#!/bin/bash
##################################################################
# This plugin check for elasticsearch cluster nodes and node     #
# versions                                                       #
# Author mouliveera        			                 #            
# JIRA: OPS-7701                                                 #
##################################################################
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
    echo "Arguments are missing:  USAGE: $PROGNAME -H|--host HOSTNAME "

}

print_help() {
    echo ""
    echo "$PROGNAME is a Nagios plugin to monitor elasticsearch versions."
    echo ""
    echo "USAGE:"
    echo "$PROGNAME [-H/--host] <hostname>"
    echo "-------------------"
    echo "Options:"
    echo "--version|-v)"
    echo "Defines version"
    echo "--help|-h)"
    echo "Help!!!"
    echo "--host|-H HOSTNAME)"
    echo "Defines hostname" 
    echo "-------------------"
    exit $ST_UK
}

sleep $interval
if [ -z "$1" ];then print_usage;exit $ST_UK;fi

sleep $interval

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

#Collect elasticsearch cluster information
ELASTICSEARCH_INFO=$(curl -s http://$HOST:9200/_nodes)

if [ -s "$ELASTICSEARCH_INFO" ]; then
	echo "WARNING: No info/data found on node:$HOST"
	exit $ST_WR;
fi

#Colect elasticsearch cluster nodes and their versions
ELASTICSEARCH_NODES_VERSION=$(echo `echo $ELASTICSEARCH_INFO |jq '.nodes[] | "\(.name):\(.version)"'`)

#Get elasticsearch cluster versions,
#Useful to print the plugin output
ELASTICSEARCH_VERSION_CHECK=$(echo $ELASTICSEARCH_INFO |jq '.nodes[].version')

#Plugin result
ELASTICSEARCH_NODE_VERSION_COUNT=$(echo $ELASTICSEARCH_VERSION_CHECK |sed 's/ /\n/g'|uniq|wc -l)

#Condition to validate count of node&version
        if [[ $ELASTICSEARCH_NODE_VERSION_COUNT == 0 || $ELASTICSEARCH_NODE_VERSION_COUNT > 1 ]];then
                echo "WARNING: Inconsistent elasticsearch versions among the cluster nodes: $ELASTICSEARCH_NODES_VERSION"
                exit $ST_WR;
        else
                echo "OK: Consistent elasticsearch versions among the cluster nodes: $ELASTICSEARCH_NODES_VERSION"
                exit $ST_OK;
        fi

#USAGE:
#check_elsearch_version.sh [-H/--host] <hostname>
#
#Options:
#--version|-v)
#Defines version
#--help|-h)
#Help!!!
#--host|-H HOSTNAME)
#Defines hostname

#EOF
