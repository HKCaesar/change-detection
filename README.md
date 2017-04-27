# Change detection

First of all we need gsutil:

```
pip install gsutil
```

We now can download a list of all the available images into our working directory:

```
gsutil cp -n gs://earthengine-public/landsat/scene_list.zip .
```

The files can be unzipped:

```
unzip scene_list.zip
```

Then we can query the file using grep tools. The naming conventions for Landsat images can be found [here](https://landsat.usgs.gov/landsat-collections). For example if we want to filter only scenes from path *026* and row *047* (aka south of Mexico City) and consider only Landsat 5 mission we would type as follows:

```
cat  scene_list | grep "026/047" | grep L5
```

We can download a scene fron the result of the last command. For example consider downloading *gs://earthengine-public/landsat/L5/026/047/LT50260471984253AAA03.tar.bz* (which is the first result of the command):

```
gsutil cp -n gs://earthengine-public/landsat/L5/026/047/LT50260471984253AAA03.tar.bz .
```

This will download a tar file that can be decompresed. First we create a folder to hold the files that will be decompressed:

```
mkdir LT50260472009033EDC00
```

Then we can decompress with:

```
tar -xvjf LT50260471984253AAA03.tar.bz -C LT50260472009033EDC00
```
If we list the contents of this directory we will see several files. The files with *TIF* suffix are the bands of our images. If we open one of them with *QGIS* we would see a grayscale image. If we want to see the full colour image, we need to merge these bands in an specific order into a RGB image, in the case of Landsat 5 mission, the appropiate order is to assign the band 3 to red, the band 2 to green, and the band 1 to blue. To do this we will use a tool called GDAL, which can be a pain to install. To avoid going through this process we can use a docker container already packed with the whole GDAL toolbox. We can simply type this command in the directory containing the images:

```
docker run --rm -v $(pwd):/data geodata/gdal gdalbuildvrt -separate L5026047_04720090202_RGB.TIF \ 
                                                                    L5026047_04720090202_B30.TIF \
                                                                    L5026047_04720090202_B20.TIF \
                                                                    L5026047_04720090202_B10.TIF
```

