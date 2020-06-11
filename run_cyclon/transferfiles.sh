#!/bin/sh -vx
#
# Transfer files if not using OpenDAP
#



export TRANSFERFILES=${TRACKDIR}/transferfiles.py
export list_sel_files="input_selected_files.txt"

cd $DATADIR
python $TRANSFERFILES $list_sel_files
