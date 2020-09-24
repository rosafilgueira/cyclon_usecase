#!/bin/sh -vx
#
# Subsetting and pre-process input files
#


RUNCONFIG=${TRACKDIR}/config_cmip6.txt
echo "RUNCONFIG" $RUNCONFIG
. $RUNCONFIG

export list_sel_files="input_selected_files.txt"
export EXTRACTDATA=${TRACKDIR}/extractnc.py

cd $DATADIR

python $EXTRACTDATA $list_sel_files $latmin $latmax $lonmin $lonmax $period_start_date $period_end_date $psl $zg1000 $ua500 $va500 $orog $lsm
