#!/bin/bash

# reverse DXY data file so that the lastest record is in the end instead of beginning
tac data/dxy-data/DXYArea.csv > data/DXYArea_reversed.csv

# generate data in JSON format and include data in TOPOJSON maps
data_processing_filenames="world_current world china china_overall korea italy us us_1p3a france germany japan austria australia canada switzerland uk sweden poland norway iran portugal brazil malaysia belgium czechia russia2 latin_america india ireland south_africa philippines romania indonesia saudi_arabia thailand hong_kong pakistan croatia finland ukraine hungary denmark slovakia albania latvia estonia slovenia haiti algeria nigeria senegal ghana morocco bangladesh2 venezuela bolivia turkey sri_lanka nepal guatemala"

# skipped: Netherlands, Spain

for filename in $data_processing_filenames; do
    echo "Running data_processing_${filename}.js ..."
    node scripts/data_processing_${filename}.js
    if [ $? != 0 ]; then
       exit 1
    fi
done

yarn mapshaper ./public/maps/gadm36_NOR_1.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_NOR_1.json
yarn mapshaper ./public/maps/gadm36_GBR_2.json -dissolve NAME_2 copy-fields=CHINESE_NAME,COUNTRY_CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_GBR_2.json
yarn mapshaper ./public/maps/gadm36_USA_2.json -dissolve NAME_1,NAME_2 copy-fields=CHINESE_NAME,STATE_CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_USA_2.json
yarn mapshaper ./public/maps/NLD.json -dissolve GM_NAAM copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/NLD.json
yarn mapshaper ./public/maps/gadm36_PRT_2.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_PRT_2.json
yarn mapshaper ./public/maps/gadm36_PER_1.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_PER_1.json
yarn mapshaper ./public/maps/gadm36_HKG_1.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_HKG_1.json
yarn mapshaper ./public/maps/gadm36_PAK_1.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_PAK_1.json
yarn mapshaper ./public/maps/gadm36_FIN_4.json -dissolve NAME_2 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_FIN_4.json
yarn mapshaper ./public/maps/gadm36_TUR_1.json -dissolve NAME_1 copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/gadm36_TUR_1.json
yarn mapshaper ./public/maps/IND.json -dissolve st_nm copy-fields=CHINESE_NAME,REGION -o format=topojson ./public/maps/IND.json

script_filenames="data_merge missing_data_fix"

for filename in $script_filenames; do
    echo "Running ${filename}.js ..."
    node scripts/${filename}.js
    if [ $? != 0 ]; then
       exit 1
    fi
done