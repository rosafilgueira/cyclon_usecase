#!/bin/sh -vx
#

INPUTFILELIST=$1
FILENAME=$(basename $INPUTFILELIST)
NAME=$(echo "$FILENAME" | cut -f 1 -d '.')

mkdir -p $STAGED_DATA/cyclone_workflow_$NAME
mkdir -p $STAGED_DATA/cyclone_workflow_$NAME/output

echo $INPUT_DIR
echo $STAGED_DATA


cp -r $INPUT_DIR/cyclone_workflow_git/* $STAGED_DATA/cyclone_workflow_$NAME/.
cat $INPUTFILELIST > $STAGED_DATA/cyclone_workflow_$NAME/input_files.txt

TRACKDIR=$STAGED_DATA/cyclone_workflow_$NAME/
WORKDIR=$STAGED_DATA/cyclone_workflow_$NAME/output
CONFIGFILE=${STAGED_DATA}/cyclone_workflow_$NAME/cyclone_config_CMIP6.json
RUNCONFIG=${STAGED_DATA}/cyclone_workflow_$NAME/config_cmip6.txt


if [ ! -d $TRACKDIR ]
then
  echo "Directory $TRACKDIR does not exist."
  exit 1

fi

if [ ! -d $WORKDIR ]
then
  echo "Directory $WORKDIR does not exist."
  exit 1

fi

if [ ! -s $CONFIGFILE ]
then
  echo "Configuration file $CONFIGFILE does not exist."
  exit 1
fi

if [ ! -s $RUNCONFIG ]
then
  echo "Configuration file $RUNCONFIG does not exist."
  exit 1
fi

if [ ! -s $INPUTFILELIST ]
then
  echo "Input filelist file $INPUTFILELIST does not exist."
  exit 1
fi

export PATH=${PATH}:${TRACKDIR}

# Executables
export EXTRACTDATA=${TRACKDIR}/extractnc.py
export TRACKS=${TRACKDIR}/make_tracks.abs
export XMLASCII=${TRACKDIR}/tracking_xml2ascii.py
export PROCESSFILES=${TRACKDIR}/processfiles.py
export TRANSFERFILES=${TRACKDIR}/transferfiles.py

if [ ! -s $EXTRACTDATA ]
then
  echo "$EXTRACTDATA is missing."
  exit 1
fi
if [ ! -s $TRACKS ]
then
  echo "$TRACKS is missing."
  exit 1
fi
if [ ! -s $XMLASCII ]
then
  echo "$XMLASCII is missing."
  exit 1
fi

# Create data directory if it does not exist
export datadir=$WORKDIR/data
if [ -d $datadir ]
then
  echo "$datadir already exists. Using existing directory."
else
  mkdir $datadir
fi

# Create results directory if it does not exist
export resultsdir=$datadir/results
if [ -d $resultsdir ]
then
  echo "$resultsdir already exists. Using existing directory."
else
  mkdir $resultsdir
fi

# Remove warmstart.txt if it exists
export warmstart=$resultsdir/warmstart.txt
rm -f $warmstart


#### CONFIG for CMIP6 data
####
. $RUNCONFIG
export period=${period_start_date}-${period_end_date}

export curdir=`pwd`

export configfile="$CONFIGFILE"
export out_file="tracks.txt"
export list_files="$INPUTFILELIST"
export list_sel_files="input_selected_files.txt"
export list_tracks="input_tracks.txt"

rm -f $WORKDIR/data/results/$list_tracks

# Get model name
#
line=`grep ${psl}_ ${list_files} | head -n 1`
filename=`basename $line`
export model=`echo $filename | awk 'BEGIN {FS="_"} {print $3}'`

echo $model > $STAGED_DATA/cyclone_workflow_$NAME/model.txt
