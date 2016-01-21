#!/bin/bash

USER_CONFIG=0
if [ -f .config ]; then
	mv .config .config_user
	USER_CONFIG=1
fi


for i in $(find configs -name *.config); do
	echo "$i"
	cp "$i" .config
	make olddefconfig > /dev/null
	cp .config "$i"
done


if [ $USER_CONFIG -eq 0 ]; then
	rm .config
else
	mv .config_user .config
fi
