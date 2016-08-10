# BioPathDL

## Requirements
* Image Magick http://www.imagemagick.org
* wget https://www.gnu.org/software/wget/

## Usage
```bash
./dlmap.sh part zoom
```

## Details
There is two images :
---------------------
chose which one you want with the number of the part as first argument
1. Part 1: Metabolic Pathways
2. Part 2: Cellular and Molecular Processes

There is seven zoom levels :
--------------------------
from 0 to 6
* 0 the image will be very small
[...]
* 4 the image will have a correct size for a correct amount of processing time
* 6 the bigest one : expect hours of processing

## Performance
if you are limited by your specs or if you want to use your computer in the same time
you can add those following options just after "-monitor" lines 80 and 95

the amount of ram you want to allow to the process
```bash
-limit memory 4GiB
the amount mapped memmory you want to allow to the process
```bash
-limit map 10GiB 
```
if you want to change the defult tmp directory for the process
ex: an other disk
file in tmp can reach 100GiB and more (specially for zoom 6)
```bash
-define registry:temporary-path=/tmp/
```
