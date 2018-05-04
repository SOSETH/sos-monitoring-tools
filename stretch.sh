#!/bin/bash

docker build -t sosmon-stretch .
if [ ! -d out ] ; then
	mkdir out
fi
docker run -v $(pwd)/out:/data sosmon-stretch
