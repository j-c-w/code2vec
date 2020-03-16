#!/bin/bash
set -eu
set -x

install=yes

cd /home/s1988171/CodeModels/code2vec
source ~/.bash_scriptrc
echo $TMPDIR
if [[ $install == yes ]]; then
	echo "Starting Python Install" > /dev/stderr
	# User specific aliases and functions
	# Install python and add it to path.
	output=$(install_python.sh $TMPDIR/python_installation)
	echo $output
fi
export PATH=$TMPDIR/python_installation/bin:$PATH

# Get the code:
code_dir=$TMPDIR/code
output_dir=$EXPORTSDIR/preprocessed_code_qsub
mkdir -p $code_dir
pushd $code_dir
cp $EXPORTSDIR/java_projects_short.tar.gz .
tar -xvf java_projects_short.tar.gz
# wget http://groups.inf.ed.ac.uk/cup/javaGithub/java_projects.tar.gz
# tar -xvf java_projects.tar.gz
# mkdir -p java_projects
# touch java_projects/test.java

mkdir train
mkdir val
mkdir test

# files_list=( $(find -name '*.java') )
# len_files=${#files_list}
# train_percent=$(($len_files * 0.9 ))
# val_percnet=$(( $len_files * 0.05 ))
# test_percnet=$(( $len_files * 0.05 ))

count=0

# TODO -- make this actually copy only bits and peices.
echo "WARNING: USING THE SAME SET FOR TRAIN/VAL/TEST --- TO FIX"
cp -r java_projects/* train
cp -r java_projects/* val
cp -r java_projects/* test
popd
pwd

# Run the extract process
./preprocess.sh $code_dir extracted_github_data $output_dir
echo "Extracted!"
