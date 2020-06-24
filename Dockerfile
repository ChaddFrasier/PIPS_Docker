FROM conda/miniconda3:latest

LABEL maintainer="ChaddFrasier"

# update and init the conda environment
RUN conda update -n base -c defaults conda && \
    conda init bash && \
    apt-get -qq update && apt-get install -y rsync libglu1 libgl1 build-essential \
    libcairo2-dev libpango1.0-dev libjpeg-dev librsvg2-dev && \
    apt-get install -y curl software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs && \
    exec bash

ENV CONDA_PREFIX /usr/local
# create the isis env and install isis
RUN conda create -n isis python=3.6 && \
    echo "conda activate isis" && \
    conda config --env --add channels conda-forge && \
    conda config --env --add channels usgs-astrogeology && \
    conda install -c usgs-astrogeology isis && \
    python /usr/local/scripts/isis3VarInit.py

# download required data
RUN rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isisdata/data/base $ISISDATA

# clone code into PIPS from root
WORKDIR $CONDA_PREFIX

# command to disable container caching
ARG BREAKCACHE=1

# Copy all code files to /PIPS
RUN git clone https://github.com/ChaddFrasier/PIPS.git ./PIPS

# move to working directory
WORKDIR /PIPS

# install all modules and update canvas and update binaries
RUN npm install && \
    npm install canvas && \
    npm rebuild bcrypt --update-binary

RUN echo "\n\nTESTING\n\n" && echo "lowpass -h"