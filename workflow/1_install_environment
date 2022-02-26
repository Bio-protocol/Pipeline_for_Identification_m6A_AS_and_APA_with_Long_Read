#!/bin/bash

eval "$(conda shell.bash hook)"

### install tombo 
# pip install numpy==1.19
# pip install ont-tombo   #https://github.com/nanoporetech/tombo
# pip install ont-fast5-api   #https://pypi.org/project/ont-fast5-api/
# or user can install tombo by the following command

echo '---------------------------------'
echo "[`date`] tombo INSTALL BEGIN"
echo '---------------------------------'

conda env create -n tombo_env -f tombo.yaml

echo '---------------------------------'
echo "[`date`] tombo INSTALL COMPLETE"
echo '---------------------------------'



### install nanom6A
# Download the source package in https://drive.google.com/drive/folders/1Dodt6uJC7lBihSNgT3Mexzpl_uqBagu0?usp=sharing

echo '---------------------------------'
echo "[`date`] nanom6A INSTALL BEGIN"
echo '---------------------------------'

conda env create -n nanom6A_env -f nanom6a.yaml

echo '---------------------------------'
echo "[`date`] nanom6A INSTALL COMPLETE"
echo '---------------------------------'

### install prapi

echo '---------------------------------'
echo "[`date`] prapi INSTALL COMPLETE"
echo '---------------------------------'

wget http://forestry.fafu.edu.cn/tool/PRAPI/prapi_env.yaml
conda env create -f prapi_env.yaml 

echo '---------------------------------'
echo "[`date`] prapi INSTALL COMPLETE"
echo '---------------------------------'
