#!/bin/sh -vx
#
# Generate plots of the results
#

RUNCONFIG=${TRACKDIR}/config_cmip6.txt
. $RUNCONFIG

export CREATEMAPS=${TRACKDIR}/plots.py
export period=${period_start_date}-${period_end_date}

cd $RESULTSDIR
python $CREATEMAPS tracks_${period}.txt -90 29 30 89

