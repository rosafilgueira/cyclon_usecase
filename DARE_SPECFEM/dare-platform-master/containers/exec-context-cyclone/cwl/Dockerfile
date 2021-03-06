FROM python:3.7

RUN apt-get update && apt-get install -y openmpi-bin=3.1.3-11 libopenmpi-dev=3.1.3-11 \
gcc-7 git vim sudo uuid-runtime libgeos-dev make cmake gfortran-7 libnetcdf-dev \
 libnetcdff-dev libudunits2-dev libproj-dev proj-data proj-bin

ENV USER mpiuser
ENV HOME /home/mpiuser/docker
ENV MPLBACKEND=Agg

RUN adduser ${USER} --disabled-password --gecos ""

RUN pip install mpi4py==3.0.1 numpy pandas matplotlib

USER ${USER}
WORKDIR ${HOME}

USER root

RUN pip install cwl-runner
RUN pip install cwltool==1.0.20190621234233
RUN pip install xarray
RUN pip install netCDF4
RUN pip install pydap
RUN pip install dask[dataframe]
RUN pip install cython
RUN pip install scipy
RUN pip install pyshp
RUN pip install six
RUN pip install shapely --no-binary shapely
RUN pip install cartopy

WORKDIR ${HOME}

ENV FC gfortran-7
ENV CC gcc-7

RUN cd ${HOME} && git clone https://github.com/wavebitscientific/datetime-fortran.git && cd datetime-fortran && mkdir build && cd build && cmake .. && make && cd ${HOME}

RUN cd ${HOME} && git clone https://github.com/jacobwilliams/json-fortran.git && cd json-fortran && mkdir build && cd build && cmake .. && make && cd ${HOME}

RUN mkdir ${HOME}/cyclone_workflow_git
RUN cd ${HOME} && git clone -b cwl https://gitlab.com/project-dare/wp7_cyclone-tracking.git ${HOME}/cyclone_workflow_git

RUN cd && git clone https://github.com/cerfacs-globc/cyclone_tracking.git ./tracking && cd tracking && cp Makefile.nemo Makefile.dare && \
sed -i 's<INCDIR=.*<INCDIR=/usr/include<' Makefile.dare && sed -i 's<LIBDIR=.*<LIBDIR=/usr/lib<' Makefile.dare && \
sed -i 's<BINDIR=.*<BINDIR=$(HOME)/cyclone_workflow_git<' Makefile.dare && \
sed -i 's<DATETIMEINCDIR=.*<DATETIMEINCDIR=$(HOME)/datetime-fortran/build/include<' Makefile.dare && \
sed -i 's<DATETIMELIBDIR=.*<DATETIMELIBDIR=$(HOME)/datetime-fortran/build/lib<' Makefile.dare && \
sed -i 's<UDUNITSINCDIR=.*<UDUNITSINCDIR=/usr/include<' Makefile.dare && \
sed -i 's<UDUNITSLIBDIR=.*<UDUNITSLIBDIR=/usr/lib<' Makefile.dare && \
sed -i 's<JSONFORTRAN=.*<JSONFORTRAN=$(HOME)/json-fortran/build<' Makefile.dare && \
sed -i 's<^FC=.*<FC=gfortran-7<' Makefile.dare && \
sed -i 's<^CC=.*<CC=gcc-7<' Makefile.dare \
&& mkdir lib && make -f Makefile.dare

RUN cd ${HOME} && git clone https://github.com/cerfacs-globc/cyclone_tracking_products.git ${HOME}/cyclone_tracking_products && cd ${HOME}/cyclone_tracking_products && python setup.py install && cd ${HOME}

ENV LD_LIBRARY_PATH="${HOME}/json-fortran/build/lib/"
ENV CARTOPY_USER_BACKGROUNDS="${HOME}/cyclone_workflow_git"

RUN mkdir ${HOME}/results
COPY input_files.txt ${HOME}/cyclone_workflow_git/input_files.txt
COPY input_files2.txt ${HOME}/cyclone_workflow_git/input_files2.txt
COPY input_files3.txt ${HOME}/cyclone_workflow_git/input_files3.txt
COPY config_cmip6.txt ${HOME}/cyclone_workflow_git/config_cmip6.txt
COPY cyclone_config_CMIP6.json ${HOME}/cyclone_workflow_git/cyclone_config_CMIP6.json

RUN cp ${HOME}/cyclone_tracking_products/cyclonetrackprod/images.json ${HOME}/cyclone_workflow_git/images.json
RUN cp ${HOME}/cyclone_tracking_products/cyclonetrackprod/BMNG_hiver.jpg ${HOME}/cyclone_workflow_git/BMNG_hiver.jpg

RUN ls -l ${HOME} ${HOME}/tracking ${HOME}/cyclone_workflow_git

COPY entrypoint.sh .
ENTRYPOINT bash entrypoint.sh

# CMD tail -f /dev/null
