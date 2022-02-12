#######################
####  environment  ####
#######################

guppy_path=/path to your guppy/
tombo_path=/path to your tombo/
nanom6a_path=/path to nanom6A/

#######################
#### genome config ####
#######################

threads=/the number of cpu to process/
lib=/Lib name/
input=/path to your input fast5/
output=/path to output/

transcripts=/path to transcripts/
genome=/path to genome file/
bed=/path to bed6 file/

#######################
#######################

#Basecalling using guppy (version 3.6.1)
flowcell=FLO-PRO002
kit=SQK-RNA002


dir=$output/guppy/$lib
if [ ! -d "$dir/$lib" ]; then
       echo
       echo
       echo "[`date`] guppy"
       echo '-----------------------------------------------'
       export PATH=$guppy_path:$PATH
       mkdir -p $dir
       guppy_basecaller -i $input -s $dir/$lib --num_callers $threads --recursive --fast5_out --flowcell $flowcell --kit $kit
       echo "[`date`] Run complete for guppy"
       echo '-----------------------------------------------'
fi


#Miniconda coule be install to manage environment
#https://docs.conda.io/en/latest/miniconda.html#linux-installers
#wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
#sh Miniconda3-latest-Linux-x86_64.sh
#==> For changes to take effect, close and re-open your current shell

#Convert merged single big fast5 into small size fast5 file
#pip install ont-fast5-api
#https://pypi.org/project/ont-fast5-api/
#multi_to_single_fast5 -i $output/guppy/$i/workspace -s $dir/$lib -t 40 --recursive >$dir/$i/convert.log 2>&1
#https://github.com/nanoporetech/ont_fast5_api/issues/40

dir=$output/multi_to_single_fast5
if [ ! -d "$dir/$lib" ]; then
        echo
        echo
        echo "[`date`] multi_to_single_fast5"
        echo '-----------------------------------------------'
        mkdir -p $dir
        export PYTHONPATH=""
        export PATH=$tombo_path:$PATH
        multi_to_single_fast5 -i $output/guppy/$lib/workspace -s $dir/$lib -t $threads --recursive
        echo "[`date`] Run complete for single_to_multi_fast5"
        echo '-----------------------------------------------'
fi


dir=$output/tombo

#https://nanoporetech.github.io/tombo/
#pip install numpy
#pip install ont-tombo -i https://pypi.tuna.tsinghua.edu.cn/simple

basecall_group=Basecall_1D_000

if [ ! -f "$dir/${lib}.txt" ]; then
        echo
        echo
        echo "[`date`] tombo resquiggle $lib"
        echo '-----------------------------------------------'
        mkdir -p $dir
        export PYTHONPATH=""
        export PATH=$tombo_path:$PATH   
        tombo resquiggle --basecall-group $basecall_group --overwrite $output/multi_to_single_fast5/$lib $transcripts --processes $threads --fit-global-scale --include-
event-stde --ignore-read-locks --signal-matching-score 2
        find $output/multi_to_single_fast5/$lib*/ -name "*.fast5" >$dir/$lib.txt
        echo "[`date`] Run complete for tombo resquiggle $lib"
        echo '-----------------------------------------------'
fi


#Nanom6A step1 need python 2.7 to extract feature
#make sure all dependence were installed

dir=$output/extract_raw_and_feature
if [ ! -f "$dir/${lib}.feature.tsv" ]; then
        echo
        echo
        echo "[`date`] extract_raw_and_feature for $dir/$lib"
        echo '-----------------------------------------------'
        mkdir -p $dir
        export PYTHONPATH=""
        export PATH=$nanom6a_path:$PATH
        extract_raw_and_feature_fast --cpu=$threads --fl=$output/tombo/"$lib".txt -o $dir/$lib --clip=10
        echo "[`date`] Run complete for extract_raw_and_feature for $dir/$lib"
        echo '-----------------------------------------------'
fi


###
#https://github.com/broadinstitute/gatk/releases
#conda install -c bioconda picard
#java -jar picard.jar CreateSequenceDictionary -R genome.fa -O genome.dict
#samtools faidx genome.fa
#samtools faidx transcript.fa
#conda install -c hcc jvarkit-sam2tsv
#comda install -c bioconda minimap2

dir=$output/m6A/$lib
if [ ! -d "$dir/$lib" ]; then
        echo
        echo
        echo "[`date`] predicting m6A site for $dir/$lib"
        echo '-----------------------------------------------'
        mkdir -p $dir/plot
        export PYTHONPATH=""
        export PATH=$nanom6a_path:$PATH
        predict_sites --cpu $threads -i $output/extract_raw_and_feature/$lib -o $dir/$lib -r $bed -g $genome
        nanoplot --input $dir/$lib -o $dir/$lib/plot
        echo "[`date`] Run complete for predicting m6A site for $dir/$lib"
        echo '-----------------------------------------------'
fi

