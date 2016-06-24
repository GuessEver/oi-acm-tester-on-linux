#!/bin/bash
filename=$1
if [ -e log ]; then
    sudo rm log
fi
if [ -e datafile ]; then
    sudo rm datafile
fi

sudo ./T.sh $filename | tee log
echo "--------------Writing in log..."
echo "" >> log
echo "-------------------------------------------------------------------" >> log
cat datafile >> log
echo "-------------------------------------------------------------------" >> log

echo "--------------Delete tmp_file..."
if [ -e gmon.out ]; then 
	sudo rm gmon.out
fi
if [ -e vani_log ]; then 
	sudo rm vani_log
fi
if [ -e datafile ]; then
    sudo rm datafile
fi
