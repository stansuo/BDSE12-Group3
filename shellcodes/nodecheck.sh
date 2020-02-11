#!/bin/bash

#自動檢查節點
#目前還無法檢查HA

echo "Checking the environment..."

hadoop=$(cat /usr/local/hadoop/etc/hadoop/core-site.xml  | grep -A 1 "fs.defaultFS" | awk NR=="2" )
nna=$(echo ${hadoop#*://} | cut -d "." -f1)

hadoop=$(cat /usr/local/hadoop/etc/hadoop/yarn-site.xml | grep -A 1 "yarn.resourcemanager.hostname" | awk NR=="2" )
rma=$(echo ${hadoop#*value>} | cut -d "." -f1)

hadoop=$(cat /usr/local/hadoop/etc/hadoop/mapred-site.xml | grep -A 1 "mapreduce.jobhistory.address" | awk NR=="2")
jhs=$(echo ${hadoop#*value>} | cut -d "." -f1)


#check NameNode
ssh ${nna} jps &> /tmp/out
echo ""
cat /tmp/out | grep 'NameNode' &>/dev/null
[[ "$?" == "0" ]] && echo "NameNode started"  && echo "${nna}.example.org" || echo "NameNode exited" 
cat /tmp/out | grep 'NameNode' &>/dev/null 
[[ "$?" == "1" ]] && nna=$(echo "d")
echo ""


#check ResourceManager
ssh ${rma} jps &> /tmp/out
cat /tmp/out | grep 'ResourceManager' &>/dev/null
[[ "$?" == "0" ]] && echo "ResourceManager started" && echo "${rma}.example.org" || echo "ResourceManager exited" 
cat /tmp/out | grep 'ResourceManager' &>/dev/null 
[[ "$?" == "1" ]] && rma=$(echo "d")
echo ""


#check JobHistoryServer
ssh ${jhs} jps &> /tmp/out
cat /tmp/out | grep 'JobHistoryServer' &>/dev/null
[[ "$?" == "0" ]] && echo "JobHistoryServer started" && echo "${jhs}.example.org" || echo "JobHistoryServer exited"  
echo ""


#check DataNodes
[[ $nna == "d" ]] && exit 1
hdfs dfsadmin -report &> /tmp/out
total=$(cat /tmp/out | grep 'Name: ' | cut -d " " -f3 | wc -l)
echo "Live DataNodes: $total" 
cat /tmp/out | grep 'Name: ' | cut -d " " -f3
echo ""


#check NodeManager
[[ $rma == "d" ]] && exit 1
yarn node -list &> /tmp/out
total=$(cat /tmp/out | grep 'Nodes' | cut -d ":" -f2) 
echo  "Live NodeManager: $total"
cat /tmp/out | grep 'RUNNING' | cut -d " " -f1 | cut -d ":" -f1
echo ""

