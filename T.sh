#!/bin/bash
 
# The script is only for C++ source
# Please use freopen to I/O
# Write down the directory of the test data in file PathFile, "Orz" is defined.
# It can't tell RE from WA, so it's up to you. (if you know how to solve this problem, please tell me, thank you.)
# There must be some grammer errors in these sentence, just ignore it!
 
#Prepare for all Name
PathFile="Orz"
TmpName='__temporary__' #you can change this but you should make sure that there no filename conflict
ProgName=$1
DataDir=`cat ${PathFile}`/*.*
TimeLimit=1 #Change this for change time limit (unit : seconds)
 
Suffix=`echo ${ProgName} | sed -e 's/.*\.\(.*$\)/\1/'`
InputName=`sed -n 's/freopen\s*(\s*"\(.*\)"\s*,\s*"r".*$/\1/p' ${1}`
OutputName=`sed -n 's/freopen\s*(\s*"\(.*\)"\s*,\s*"w".*$/\1/p' ${1}`

echo "ProgName  ：	${ProgName}"
echo "InputName ：${InputName}"
echo "OutputName：${OutputName}"
echo "TimeLimit ：	${TimeLimit}s (+0.1s)"
 
#Compile
#Flag_cpp="g++ -o2 ${ProgName} -o ${TmpName} -pg"
Flag_cpp="g++ ${ProgName} -o ${TmpName} -pg"
Compile_Success=0
 
if [ "${Suffix}" = "cpp" ]; then
        $Flag_cpp
        if [ "$?" = 0 ] ; then Compile_Success=1; fi
fi
 
#Fail to Compile
if [ "${Compile_Success}" = 0 ]
then
        echo "Compile Error"
        exit
fi
 
#Test...
Total_Time=0
Total=0
cnt=0
input_list=$(find ${DataDir} -regex '.*\.in[.0-9]*') 
 
echo "-------------------------------------------------------------------"
$(cases=0)
for i in ${input_list}; do
        cp ${i} ${InputName}
        usetime=`{ time timeout ${TimeLimit}.1 ./${TmpName}; } 2>&1 | grep real | sed 's/real\s//g'`
        min=`echo ${usetime} | sed 's/\([^m]*\).*/\1/g'`
        sec=`echo ${usetime} | sed 's/.*m\([^s]*\).*/\1/g'`
        used_time=`python -c "print int(${min}*60*1000+${sec}*1000)"`

        #check tle
        msLimit=`expr $TimeLimit \* 1000`
        let msLimit=${msLimit}+100
        
        if [ $used_time -ge $msLimit ]; then
                TLE=1
        else
                TLE=0
        fi
        
        for j in {"out","ans","ou"}; do
                output_file=`echo ${i} | sed -e "s/\.in/\.${j}/g"`
                if [ -e ${output_file} ]; then
                        if [ "${j#.*}" != "in" ]; then
                                diff -b ${output_file} ${OutputName} -q > vani_log
                                if [ $? -eq 0 ]; then Status="Accepted"
                                        else Status="Wrong Answer"
                                fi
                        fi
                fi
        done
        let cnt=${cnt}+1
 
        if [ $TLE = "1" ]; then
                Status="Time Limit Exeeceded"
                if [ ${cnt} -le 9 ]; then
                        echo "Test Case	${cnt}	:	${Status}	Time: ${used_time} ms"
                else
                        echo "Test Case	${cnt}	:	${Status}	Time: ${used_time} ms"
                fi
        else 
                if [ ${cnt} -le 9 ]; then
                        echo "Test Case	${cnt}	:	${Status}		Time: ${used_time} ms"
                else
                        echo "Test Case	${cnt}	:	${Status}		Time: ${used_time} ms"
                fi
                let Total_Time=${Total_Time}+${used_time}
        fi
        if [ "$Status" = "Accepted" ]
        then 
                Total=`expr $Total + 1`
        fi
        
        echo $((cases=cases+1))"	"${output_file} >> datafile
           
done
 
if [ -e ${InputName} ]; then 
        sudo rm ${InputName} 
fi
if [ -e ${OutputName} ]; then 
        sudo rm ${OutputName} 
fi
if [ -e ${TmpName} ]; then
        sudo rm ${TmpName}
fi
 
echo "-------------------------------------------------------------------"
echo "Total used time:	$Total_Time ms"
echo "Total case(s):	$cnt"
echo "Accepted case(s):	$Total"
echo "-------------------------------------------------------------------"
#echo "Done"

 
