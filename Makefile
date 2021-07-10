#! /usr/bin/make -f

SHELL:=/bin/bash

yyyy:=2021
j:=190

J:=$(shell printf %03d ${j})


glm:=GLM-L2-LCFA

d:=${yyyy}/${J}
gd:=${glm}/${d}
cd:=csv/${d}

datasets.header:=id,platform_id,dataset_name,date_created,time_coverage_start,time_coverage_end
flashes.header:=flash_id,dataset_id,time_offset_of_first_event,time_offset_of_last_event,frame_time_offset_of_first_event,frame_time_offset_of_last_event,lat,lon,area,energy,quality_flag

.PHONY:files flashes datasets clean

INFO:
	echo "GLM processing for ${d}."

files:
	[[ -d ${glm}/${yyyy}/${J} ]] || mkdir -p ${glm}/${yyyy}/${J} ]];\
	aws s3 cp s3://noaa-goes17/${gd} ${gd} --recursive --no-sign-request

#datasets:${cd}/datasets.csv
flashes:${cd}/flashes.csv

#${cd}/datasets.csv ${cd}/flashes.csv:${cd}/%.csv:
${cd}/flashes.csv:${cd}/%.csv:
	[[ -d ${cd} ]] || mkdir -p ${cd} ;\
	echo '${datasets.header}' >${cd}/datasets.csv
	echo '${flashes.header}' >${cd}/flashes.csv
	for f in $$(find ${gd} -type f -name \*.nc); do \
	  echo $$(basename $$f);\
	  sed -e 's|YYYY/DDD|${d}|g;' -e "s|GLM.nc|$$f|g" < flashes_datasets_DDD.ncl > DDD.ncl;\
	  ncl -Q DDD.ncl;\
  done;

clean-csv:
	rm -rf ${cd}

clean-cache:
	rm -rf ${gd}
