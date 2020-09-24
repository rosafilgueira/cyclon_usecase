#!/bin/sh -vx
#
# From list of files provided, check that all needed input data is provided, and select needed files according to time period
#


RUNCONFIG=$TRACKDIR/config_cmip6.txt
echo "RUNCONFIG" $RUNCONFIG
. $RUNCONFIG

export PROCESSFILES=${TRACKDIR}/processfiles.py

INPUTFILELIST=${TRACKDIR}/input_files.txt
export list_files="$INPUTFILELIST"
export list_sel_files="input_selected_files.txt"

cd $DATADIR

python $PROCESSFILES $list_files $list_sel_files $period_start_date $period_end_date $psl $zg1000 $ua500 $va500 $orog $lsm
