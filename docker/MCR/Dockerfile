from ubuntu:16.04

COPY ./keyboard /etc/default/keyboard

RUN apt-get update; \
    apt-get install -y wget unzip xorg curl git python-pip

RUN mkdir /mcr-install && cd /mcr-install &&  \
    wget http://www.mathworks.com/supportfiles/downloads/R2017b/deployment_files/R2017b/installers/glnxa64/MCR_R2017b_glnxa64_installer.zip && \
    unzip MCR_R2017b_glnxa64_installer.zip && \
    ./install -mode silent -agreeToLicense yes;\
    rm -Rf /mcr-install

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/MATLAB/MATLAB_Runtime/v93/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/java/jre/glnxa64/jre/lib/amd64/native_threads:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/java/jre/glnxa64/jre/lib/amd64/server:/usr/local/MATLAB/MATLAB_Runtime/v93/sys/java/jre/glnxa64/jre/lib/amd64
ENV XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/v93/X11/app-defaults
ENV MCR_CACHE_VERBOSE=true
ENV MCR_CACHE_ROOT=/tmp/mcr_cache_root
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6


RUN mkdir -p $MCR_CACHE_ROOT;\
    cd /home; \
    git clone https://github.com/mtl-brainhack-school-2018/agahkarakuzu.git;\
    chmod -R 777 /home; \
    chmod -R 777 /tmp
