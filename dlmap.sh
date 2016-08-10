#!/bin/bash
 
 if [[ $# -ne 2 || $1 -ne 1 && $1 -ne 2 || $2 -gt 6 || $2 -lt 0 ]]; then
 	printf "Usage: `basename $0` Part Zoom
 	Part:	1: Metabolic Pathways
 		2: Cellular and Molecular Processes
 	Zoom: [0-6]
 	(6 take more time; 4 recommended)
 	\n"
 	exit -1
 fi
 
 # "schematicOverview"
 table=("background" "enzymes" "substrates" "coenzymes" "unicellularOrganisms" "higherPlants" "regulatoryEffects")
 url="http://mapserver0.biochemical-pathways.com/map$1"
 zoom=$2
 cols=0
 rows=0
 
 echo "[*] Checking the image size"
 colFlag=true
 rowFlag=true
 iter=0
 while [[ $colFlag = true || $rowFlag = true ]]; do
 
 	wget "$url/grid/$zoom/$iter/0.png" -nv -q -O col$iter.png
 	wget "$url/grid/$zoom/0/$iter.png" -nv -q -O row$iter.png
 	
 	sizeCol=$(stat -f%z col$iter.png)
 	if [[ $sizeCol -eq 43 ]]; then
 		colFlag=false
 	else
 		cols=$iter
 	fi
 	
 	sizeRow=$(stat -f%z row$iter.png)
 	if [[ sizeRow -eq 43 ]]; then
 		rowFlag=false
 	else 
 		rows=$iter
 	fi
 
 	iter=$(($iter + 1))
 done
 
 rm -f row*.png col*.png
 echo "[*] Image size checked : $rows x $cols"
 
 for i in ${!table[@]}; do
 	echo "[*] Downloading ${table[i]}"
 	mkdir ${table[i]}
 	cd ${table[i]}
 	
 	for (( j = 0; j <= $cols; j++ )); do
 		for (( k = 0; k <= $rows; k++ )); do
 
 			col=$j;
 			row=$k
 	
 			if [[ $j -le 9 ]]; then
 				col=0$j
 			fi
 			if [[ $k -le 9 ]]; then
 				row=0$k
 			fi
 
 			wget "$url/${table[i]}/$zoom/$j/$k.png" -nv -q -O $row$col.png
 		done
 	done
 	cd ..
 done
 
 echo "[*] Download done"
 
 mkdir "compil"
for i in ${!table[@]}; do
	echo '[*] Starting compiling '${table[i]};
	cd ${table[i]}

	montage -monitor -limit memory 12GiB -limit map 10GiB \
	-define registry:temporary-path=/Volumes/Data/tmp/ *.png \
	-geometry 1024x1024+0+0 -tile $($cols)x$($rows) -background none PNG32:${table[i]}.png
	
	echo '[*] Compiling '${table[i]}' done'
	mv ${table[i]}.png "../compil/"
	cd ..
	rm -rf ${table[i]}
done
echo "[*] Compilation done"

cd "compil"
for i in ${!table[@]}; do
	echo "[*] Adding ${table[i]}"
	if [[ $i == 0 ]]; then
		cp ${table[i]}.png tmp$i.png
	else
		composite -monitor -limit memory 12GiB -limit map 10GiB \
		-define registry:temporary-path=/Volumes/Data/tmp/ -background none \
		tmp`expr $i - 1`.png ${table[i]}.png PNG32:tmp$i.png
	fi
done


cd "compil"

if [[ $1 -eq 1 ]]; then
	fileName="Part1 Metabolic Pathways $2.png"
elif [[ condition ]]; then
	fileName="Part2 Cellular and Molecular Processes $2.png"
fi

mv $(ls tmp*.png | tail -1) "../$fileName"
cd ..
rm -rf "compil"
open "$fileName"
echo "[*] Finish"