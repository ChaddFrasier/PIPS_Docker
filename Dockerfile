FROM continuumio/miniconda3:latest

LABEL maintainer="ChaddFrasier"

# Install shared libs and rsync, Author: Seignovert
# also install nodejs npm
RUN apt-get -qq update && \
    apt-get install -y rsync \
    libglu1 \
    libgl1 && \
    apt-get -y install build-essential libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    librsvg2-dev && \
    apt-get install -y curl software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs

# Set ENV variables, Author: Seignovert
ENV HOME=/usgs
ENV ISISROOT=$HOME/isis3 ISIS3DATA=$HOME/data
ENV PATH=$PATH:$ISISROOT/bin

# create app dir
ENV APP=/PIPS

# Create user and home, Author: Seignovert
RUN useradd --create-home --home-dir $HOME --shell /bin/bash usgs

# install isis3, Author: Seignovert
WORKDIR $HOME

# Sync ISIS with conda
RUN conda config --add channels conda-forge && \
    conda config --add channels usgs-astrogeology && \
    conda create -y --prefix ${ISISROOT} && \
    conda install -y --prefix ${ISISROOT} isis3

# Sync partial `base` data
RUN rsync -azv --delete --partial --inplace \
    --exclude='testData' \
    isisdist.astrogeology.usgs.gov::isis3data/data/base $ISIS3DATA && \
    rm -rf $ISISROOT/doc $ISISROOT/docs

# Add Isis User Preferences
RUN mkdir -p $HOME/.Isis && echo "Group = UserInterface\n\
  ProgressBar      = Off\n\
  HistoryRecording = Off\n\
EndGroup\n\
\n\
Group = SessionLog\n\
  TerminalOutput = Off\n\
  FileOutput     = Off\n\
EndGroup" > $HOME/.Isis/IsisPreferences

# clone code into PIPS from root
WORKDIR $HOME/..

# Copy all code files to /PIPS
RUN git clone https://github.com/ChaddFrasier/PIPS.git ./PIPS

# move to working directory
WORKDIR $APP

# install all modules and update canvas and update binaries
RUN npm install && \
    npm install canvas && \
    npm rebuild bcrypt --update-binary

# expose containers port 8080
EXPOSE 8080

# set the run command
CMD ["node","server.js"]