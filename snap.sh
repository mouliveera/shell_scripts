#!/bin/bash
#JIRA: OPS-7378
#Shell script to get the recent snapshot info

#Recent old snapshot has taken by time
START=$(grep  vol- -B12 /home/repops/snapshot.log |tail -n 25|grep '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]' |sed -en |head -1|sed 's/:$//')

#Recent snapshot has taken by time time
END=$(grep  vol- -B12 /home/repops/snapshot.log |tail -n 25|grep '[0-2][0-9]:[0-5][0-9]:[0-5][0-9]' |sed -en |tail -1|sed 's/:$//')

#Calcultae time difference of recent old and recent snapshots
RECENT_OLD=$(date --date="$START" +%s)  #Recent old snapshot time in seconds
RECENT=$(date --date="$END" +%s)        #Recent snapshot time in seconds

#Diffrence of recent old snapshot time and a recent snapshot time
DIFFERENCE=$(expr $RECENT - $RECENT_OLD)

#Age of the snapshot
age=$(printf '%dh:%dm\n' $(($DIFFERENCE/3600)) $(($DIFFERENCE%3600/60)))
#ageinhours=$(printf '%dh:%dm:%ds\n' $(($DIFFERENCE/3600)))
echo "Age of the snapshot is $age; recent snapshot has taken at $END\n" >> /dev/null
if [ "$age" == "2h:0m" ]; then
	echo "OK: snapshot role is good"
	exit 0;
elif [ "$age" != "2h:0m:0s" ]; then
	echo "CRITICAL: snapshot is not running as expected"
	exit 2;
fi


#END
