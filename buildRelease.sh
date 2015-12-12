#!/bin/bash

executeFileName=webgisGo_linux64

executeFilePath="./output/$executeFileName"

if [ -e $executeFilePath ]
then
    echo "execute file OK"
else
    echo "execute does NOT exists, will exit"
    exit
fi

cp $executeFilePath $executeFileName

rm $executeFilePath