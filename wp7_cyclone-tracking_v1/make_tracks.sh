#!/bin/sh -vx
#
# Calculate tracks
#

CONFIGFILE=${TRACKDIR}/cyclone_config_CMIP6.json
export configfile="$CONFIGFILE"

RUNCONFIG=${TRACKDIR}/config_cmip6.txt
. $RUNCONFIG

export period=${period_start_date}-${period_end_date}
export TRACKS=${TRACKDIR}/make_tracks.abs

# Get model name
#
input=${TRACKDIR}/model.txt
model=$(head -n 1 $input)


cd $RESULTSDIR

$TRACKS -i ${model}_${period}.nc -i2 ${orog}*.nc -i3 ${lsm}*.nc -o tracks -getvar zg -configfile $configfile 
