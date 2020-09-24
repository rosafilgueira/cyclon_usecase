#!/bin/bash -vx
#
# Generate plots of the results
#
FIRSTTRACKDIR=`echo $TRACKDIR | awk '{print $1}'`

RUNCONFIG=${FIRSTTRACKDIR}/config_cmip6.txt
. $RUNCONFIG

FINALDIR=$STAGED_DATA/output
mkdir -p $FINALDIR

export period=${period_start_date}-${period_end_date}

cnt=1
for element in $RESULTSDIR
do
  cp -r $element/* $FINALDIR/.
  if [ $cnt -eq 1 ]
  then
    cat $element/tracks_${period}.txt > $FINALDIR/combined_tracks_${period}.txt
    last=`tail -1 $element/tracks_${period}.txt | awk '{print $1}'`
  else
    awk "{\$1 = \$1 + $last; printf \"%d\",\$1; \$1 = \"\"; print \$0}" $element/tracks_${period}.txt >> $FINALDIR/combined_tracks_${period}.txt
    last=`tail -1 $FINALDIR/combined_tracks_${period}.txt | awk '{print $1}'`
  fi
  cnt=`expr $cnt + 1`
done

mv $FINALDIR/combined_tracks_${period}.txt $FINALDIR/tracks_${period}.txt

cd $FINALDIR

cp ${FIRSTTRACKDIR}/images.json .
cp ${FIRSTTRACKDIR}/BMNG_hiver.jpg .
cp ${FIRSTTRACKDIR}/plots.py .

export CREATEMAPS=${FINALDIR}/plots.py

echo "Plotting"

if [ `echo "$lonmin > $lonmax" | bc -l` -eq 1 ]
then
  lonmin=`echo "$lonmin - 360.0" | bc -l`
fi

python $CREATEMAPS tracks_${period}.txt $lonmin $lonmax $latmin $latmax

rm $CREATEMAPS
