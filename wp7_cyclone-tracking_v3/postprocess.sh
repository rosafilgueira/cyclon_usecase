#!/bin/sh -vx
#
# Post-process tracks and warmstart
#


export warmstart=$RESULTSDIR/warmstart.txt

rm -f $warmstart

RUNCONFIG=${TRACKDIR}/config_cmip6.txt
. $RUNCONFIG
export period=${period_start_date}-${period_end_date}

cd $RESULTSDIR

#Create file warmstart.txt to start next tracking in "Mode Warmstart"
#
 
d=`awk 'END {print $7}' tracks_${period}.txt`
m=`awk 'END {print $8}' tracks_${period}.txt`
y=`awk 'END {print $9}' tracks_${period}.txt`

awk -v day=$d -v month=$m -v year=$y '$7==day && $8==month && $9==year {print $2,$3}' tracks_${period}.txt >> $warmstart 

#Create input_file with filenames of tracks_period.txt
#

export list_tracks="input_tracks.txt"
echo "tracks_${period}.txt" >> $list_tracks
