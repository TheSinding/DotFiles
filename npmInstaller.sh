#!/bin/bash

declare -a array
readarray array < ./applications
echo -e "${array[6]}"
