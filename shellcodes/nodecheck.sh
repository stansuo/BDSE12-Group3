#!/bin/bash

#自動叢集檢查服務運作狀態

# Copyright (c) IIIedu BDSE.
# BDSE12 Project <contactus@iii.org.tw>
# 指導老師：楊禎文老師


B='\033[1;34m'
G='\033[0;32m'
N='\033[0m'
R='\033[0;31m'
echo -e "${B}Checking the environment...${N}"
cat /usr/local/hadoop/etc/hadoop/core-site.xml &>/dev/null
[[ "$?" == "1" ]] && echo -e "${R}Can't find out core-site.xml,make sure your hadoop path: "/usr/local/hadoop/etc/hadoop/" " \
&& echo -e "Terminate program...!${N}" && exit 1
haCheck=$(cat /usr/local/hadoop/etc/hadoop/core-site.xml  | grep -A 1 "fs.defaultFS" | awk NR=="2" | grep 'cluster' )
[[ -n ${haCheck} ]] && echo -e "${B}Your cluster : HA cluster${N}" || echo "${B}Your cluster : Normal cluster${N}"
if [[ -n ${haCheck} ]]

	then
		#HA叢集
		#自動檢查檢查XML各服務主機
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/hdfs-site.xml | grep -A 1 "dfs.namenode.rpc-address.nncluster.nn1" | awk NR=="2" )
			nn1=$(echo ${hadoop#*value>} | cut -d "." -f1)
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/hdfs-site.xml | grep -A 1 "dfs.namenode.rpc-address.nncluster.nn2" | awk NR=="2" )
			nn2=$(echo ${hadoop#*value>} | cut -d "." -f1)
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/yarn-site.xml | grep -A 1 "yarn.resourcemanager.hostname.rm1" | awk NR=="2" )
			rm1=$(echo ${hadoop#*value>} | cut -d "." -f1)	
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/yarn-site.xml | grep -A 1 "yarn.resourcemanager.hostname.rm2" | awk NR=="2" )
			rm2=$(echo ${hadoop#*value>} | cut -d "." -f1)
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/mapred-site.xml | grep -A 1 "mapreduce.jobhistory.address" | awk NR=="2")
			jhs=$(echo ${hadoop#*value>} | cut -d "." -f1)
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/yarn-site.xml | grep -A 1 "yarn.resourcemanager.zk-address" | awk NR=="2" )
			zk1=$(echo ${hadoop#*<value>} | cut -d "." -f1)
			zk2=$(echo ${hadoop#*<value>} | cut -d "," -f2 | cut -d "." -f1)
			zk3=$(echo ${hadoop#*<value>} | cut -d "," -f3 | cut -d "." -f1)
			hadoop=$(cat /usr/local/hadoop/etc/hadoop/hdfs-site.xml | grep -A 1 "dfs.namenode.shared.edits.dir" | awk NR=="2" )
			jn1=$(echo ${hadoop#*://} | cut -d "." -f1)
			jn2=$(echo ${hadoop#*://} | cut -d ";" -f2 | cut -d "." -f1)
			jn3=$(echo ${hadoop#*://} | cut -d ";" -f3 | cut -d "." -f1)
		#check NameNode1
			ssh ${nn1} jps &> /tmp/out
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}NameNode1 started${N}"   || echo -e "${R}NameNode1 exited${N}" 
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "0" ]] && State=$(hdfs haadmin -getServiceState nn1) \
			&& echo "${nn1}.example.org State: "$State" "
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "1" ]] && nn1=$(echo "d")
		#check NameNode2
			ssh ${nn2} jps &> /tmp/out
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}NameNode2 started${N}"   || echo -e "${R}NameNode2 exited${N}" 
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "0" ]] && State=$(hdfs haadmin -getServiceState nn2) \
			&& echo "${nn1}.example.org State: "$State" "
			cat /tmp/out | grep 'NameNode' &>/dev/null
			[[ "$?" == "1" ]] && nn2=$(echo "d")
		#check ResourceManager1
			ssh ${rm1} jps &> /tmp/out
			cat /tmp/out | grep 'ResourceManager' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ResourceManager1 started${N}" || echo -e "${R}ResourceManager1 exited${N}" 
			cat /tmp/out | grep 'ResourceManager' &>/dev/null
			[[ "$?" == "0" ]] && State=$(yarn rmadmin -getServiceState rm1) \
			&& echo "${rm1}.example.org: "$State" " 
			cat /tmp/out | grep 'ResourceManager' &>/dev/null 
			[[ "$?" == "1" ]] && rm1=$(echo "d")
		#check ResourceManager2
			ssh ${rm2} jps &> /tmp/out
			cat /tmp/out | grep 'ResourceManager' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ResourceManager2 started${N}" || echo -e "${R}ResourceManager2 exited${N}" 
			cat /tmp/out | grep 'ResourceManager' &>/dev/null
			[[ "$?" == "0" ]] && State=$(yarn rmadmin -getServiceState rm1) \
			&& echo "${rm1}.example.org: "$State" " 
			cat /tmp/out | grep 'ResourceManager' &>/dev/null 
			[[ "$?" == "1" ]] && rm2=$(echo "d")
		#check JobHistoryServer
			ssh ${jhs} jps &> /tmp/out
			cat /tmp/out | grep 'JobHistoryServer' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}JobHistoryServer started${N}" && echo "${jhs}.example.org" || echo -e "${R}JobHistoryServer exited${N}"  
		#check ZooKeeper1,2,3
			ssh ${zk1} jps &> /tmp/out
			cat /tmp/out | grep 'QuorumPeerMain' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ZooKeeper1 started${N}"  && echo "${zk1}.example.org" || echo -e "${R}ZooKeeper1 exited${N}" 
			ssh ${zk2} jps &> /tmp/out
			cat /tmp/out | grep 'QuorumPeerMain' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ZooKeeper2 started${N}"  && echo "${zk2}.example.org" || echo -e "${R}ZooKeeper3 exited${N}" 
			ssh ${zk3} jps &> /tmp/out
			cat /tmp/out | grep 'QuorumPeerMain' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ZooKeeper3 started${N}"  && echo "${zk3}.example.org" || echo -e "${R}ZooKeeper3 exited${N}" 
		#check JournalNode1,2,3
			ssh ${jn1} jps &> /tmp/out
			cat /tmp/out | grep 'JournalNode' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}JournalNode1 started${N}"  && echo "${jn1}.example.org" || echo -e "${R}JournalNode1 exited${N}" 
			ssh ${jn2} jps &> /tmp/out
			cat /tmp/out | grep 'JournalNode' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}JournalNode2 started${N}"  && echo "${jn2}.example.org" || echo -e "${R}JournalNode3 exited${N}" 
			ssh ${jn3} jps &> /tmp/out
			cat /tmp/out | grep 'JournalNode' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}JournalNode2 started${N}"  && echo "${jn3}.example.org" || echo -e "${R}JournalNode3 exited${N}" 
		#check DataNodes
			[[ $nn1 && $nn2 == "d" ]] && exit 1
			hdfs dfsadmin -report &> /tmp/out
			total=$(cat /tmp/out | grep 'Name: ' | cut -d " " -f3 | wc -l)
			echo -e "${G}Live DataNodes: $total ${N}" 
			cat /tmp/out | grep 'Name: ' | cut -d " " -f3 | cut -d "(" -f2 | cut -d ")" -f1
		#check NodeManager
			[[ $rm1 && $rm2 == "d" ]] && exit 1
			yarn node -list &> /tmp/out
			total=$(cat /tmp/out | grep 'Nodes' | cut -d ":" -f2) 
			echo -e "${G}Live NodeManager: $total ${N}"
			cat /tmp/out | grep 'RUNNING' | cut -d " " -f1 | cut -d ":" -f1
	else
		#一般叢集
		#自動檢查檢查XML各服務主機
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
			[[ "$?" == "0" ]] && echo -e "${G}NameNode started${N}"  && echo "${nna}.example.org" || echo -e "${R}NameNode exited${N}" 
			cat /tmp/out | grep 'NameNode' &>/dev/null 
			[[ "$?" == "1" ]] && nna=$(echo "d")
			echo ""
		#check ResourceManager
			ssh ${rma} jps &> /tmp/out
			cat /tmp/out | grep 'ResourceManager' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}ResourceManager started${N}" && echo "${rma}.example.org" || echo -e "${R}ResourceManager exited${N}" 
			cat /tmp/out | grep 'ResourceManager' &>/dev/null 
			[[ "$?" == "1" ]] && rma=$(echo "d")
			echo ""
		#check JobHistoryServer
			ssh ${jhs} jps &> /tmp/out
			cat /tmp/out | grep 'JobHistoryServer' &>/dev/null
			[[ "$?" == "0" ]] && echo -e "${G}JobHistoryServer started${N}" && echo "${jhs}.example.org" || echo -e "${R}JobHistoryServer exited${N}"  
			echo ""
		#check DataNodes
			[[ $nna == "d" ]] && exit 1
			hdfs dfsadmin -report &> /tmp/out
			total=$(cat /tmp/out | grep 'Name: ' | cut -d " " -f3 | wc -l)
			echo -e "${G}Live DataNodes: $total ${N}" 
			cat /tmp/out | grep 'Name: ' | cut -d " " -f3
			echo ""
		#check NodeManager
			[[ $rma == "d" ]] && exit 1
			yarn node -list &> /tmp/out
			total=$(cat /tmp/out | grep 'Nodes' | cut -d ":" -f2) 
			echo  -e "${G}Live NodeManager: $total ${N}"
			cat /tmp/out | grep 'RUNNING' | cut -d " " -f1 | cut -d ":" -f1
			echo ""
fi

