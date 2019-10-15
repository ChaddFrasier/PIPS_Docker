# PIPS_Docker
This is a docker image implimentation of the PIPS USGS project. This Dockerfile is based on the 
seignovert/docker-usgs-isis3 repo that can be found [here](https://github.com/seignovert/docker-usgs-isis3).

I used this repository to install ISIS3 in the manner that my application can access ISIS3 programs from the
docker container's command line. With the help from this docker container, I successfully installed ISIS3 and Node.js into the same docker container.

Simply pull the image down using the install command and then run it using the run command. 
When the server is running go to `http://localhost:8080/`

## Install
`docker pull chaddfrasier/pips-usgs`

## Running 
`docker run --rm -p 8080:8080 pips-usgs`
