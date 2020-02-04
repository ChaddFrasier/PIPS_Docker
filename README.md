# PIPS_Docker
This is a docker image implimentation of the PIPS USGS project. This Dockerfile is based on the 
seignovert/docker-usgs-isis3 repo that can be found [here](https://github.com/seignovert/docker-usgs-isis3). Source code for the server will be hosted on GitHub [here](https://github.com/ChaddFrasier/PIPS)

I used this repository to install ISIS3 in the manner that my application can access ISIS3 programs from the
docker container's command line. With the help from this docker container, I successfully installed ISIS3 and Node.js into the same docker container.

Simply pull the image down using the install command and then run it using the run command. 
When the server is running go to `http://localhost:8000/`

## Install
`docker pull chaddfrasier/pips-usgs` or `docker pull chaddfrasier/pips-usgs:<tag>`

## Running 
`docker run --rm --name pips -p 8000:8080 chaddfrasier/pips-usgs`

## Stopping
`docker kill pips`

## Uninstall
1. `docker image ls` or `docker images`

```
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
chaddfrasier/pips-usgs   latest              2633ea40ac3b        15 hours ago        18.2GB
```

2. `docker rmi <IMAGE ID>`
