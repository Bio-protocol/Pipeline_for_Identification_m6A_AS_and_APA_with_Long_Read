### install PRAPI

wget http://forestry.fafu.edu.cn/tool/PRAPI/prapi_env.yaml
conda env create -f prapi_env.yaml #install conda environment
conda activate prapi_env
pip install -i https://pypi.anaconda.org/gaoyubang/simple splicegrapher 

echo '---------------------------------'
echo "[`date`] PRAPI INSTALL COMPLETE"
