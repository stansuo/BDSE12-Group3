#!/bin/bash

echo " 0 -------創建一個spark容器"
echo " 1 -------將spark容器重啟喚起運作"
echo " 2 -------停止正在運作的spark容器"
echo " 3 -------查看spark容器的log"
echo " 4 -------查看正在運作的容器"
echo " 5 -------顯示虛擬機IP"
echo " 6 -------刪除spark容器"
echo "=======================CHOSE ONE======================="

read -p "Please enter a value: " answer 
	case "$answer" in
		q*|exit|bye ) echo "Terminate program...!" ; exit ;;
		0) 
			docker-machine ip 
			docker container run --name pyspark_exercise -v $HOME/share/pyspark:/home/jovyan/work -p 8800:8888 -p4040:4040 jupyter/pyspark-notebook ;;
		1) 
			docker container restart pyspark_exercise 
			docker container ls ;;
		2) 
			docker container stop pyspark_exercise 
			docker container ls ;;
		3) 
			docker container logs pyspark_exercise;;
		4)
			docker container ls ;;
		5)
			docker-machine ip ;;
		6)
			docker container rm pyspark_exercise 
			docker container ls -a;;
			
		*) echo "Only choices 0, 1, 2, 3, 4, 5, 6" ;;
	esac

exit

		
		