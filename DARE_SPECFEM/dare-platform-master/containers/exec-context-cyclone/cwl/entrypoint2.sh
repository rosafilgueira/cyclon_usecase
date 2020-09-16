#!/bin/bash
#

if [ -z "$RUN_DIR" ]
then
  RUN_DIR=$$
fi
  
mkdir -p /home/mpiuser/sfs/d4p
cd /home/mpiuser/sfs/d4p

mkdir -p "${RUN_DIR}"
cd /home/mpiuser/sfs/d4p/${RUN_DIR}

mkdir /home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow_git
cp -r ${HOME}/cyclone_workflow_git/* /home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow_git/.

echo $pwd

cp /home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow_git/*.yml /home/mpiuser/sfs/d4p/${RUN_DIR}/.
cp /home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow_git/*.cwl /home/mpiuser/sfs/d4p/${RUN_DIR}/.
cp /home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow_git/*.sh /home/mpiuser/sfs/d4p/${RUN_DIR}/.

OUTDIR="/home/mpiuser/sfs/d4p/${RUN_DIR}/output"
mkdir -p "${OUTDIR}"

cwl-runner tracking_master.cwl tracking_master_2.yml

TEMP_OUTDIR="/home/mpiuser/sfs/d4p/${RUN_DIR}/cyclone_workflow/output/data/results"
cd "${TEMP_OUTDIR}" && mv * "${OUTDIR}"
#cd ${TEMP_OUTDIR} && for i in `ls -d */`;do [ "$(ls -A $i)" ] && \
#                      cp -p $i/* "${OUTDIR}" && rm -rf $i || rm -rf $i;done

adduser nginx --disabled-password --gecos ""
groupadd appusers
usermod -a -G appusers nginx
usermod -a -G appusers mpiuser
chgrp -R appusers /home/mpiuser/sfs/d4p/${RUN_DIR}
chmod -R 777 /home/mpiuser/sfs/d4p/${RUN_DIR}

ls -alF $OUTDIR
