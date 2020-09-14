#!/bin/sh -vx
#
# Convert XML tracks output to ASCII
#

RUNCONFIG=${TRACKDIR}/config_cmip6.txt
. $RUNCONFIG

export XMLASCII=${TRACKDIR}/tracking_xml2ascii.py
export period=${period_start_date}-${period_end_date}

cd $RESULTSDIR
python $XMLASCII tracks.xml tracks_${period}.txt
