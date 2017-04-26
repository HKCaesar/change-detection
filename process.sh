#!/bin/bash

NAME=$(basename $1 .tar.bz) 

mkdir -p build/$NAME
cd build
echo "Downloading scene..."
gsutil cp -n $1 .
echo "Extracting scene..."
tar xjf $(basename $1) -C $NAME
rm $(basename $1)
cd $NAME
METADATAFILE=$(ls *MTL.txt)
SCENE=$(basename $METADATAFILE _MTL.txt)
echo $SCENE
echo "Creating true color composite..."
docker run --rm -v $(pwd):/data geodata/gdal gdalbuildvrt -separate $SCENE"_RGB.TIF" $SCENE"_B30.TIF" $SCENE"_B20.TIF" $SCENE"_B10.TIF"
cd ../..
