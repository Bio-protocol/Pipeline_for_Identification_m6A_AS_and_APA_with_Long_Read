# activate environment
conda activate prapi_env

# build gmap index
# make sure the directory input/prapi/db exist.
gmap_build -d bamboo -D input/prapi/db input/prapi/data/new.fa

# Analysis
Pacbio_v16.py -c input/prapi/conf.txt
