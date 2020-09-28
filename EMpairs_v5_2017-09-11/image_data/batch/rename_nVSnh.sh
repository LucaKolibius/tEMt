#!/bin/bash

c=0;
for i in *.jpg;
	do
	c=$((c+1))
	echo "${i}" "${i%%[0-9].jpg}" 
	echo "${c}";
	mv "${i}" "${i%%[0-9].jpg}${c}.jpg";
done

