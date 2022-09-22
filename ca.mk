#!/usr/bin/make -f

csv:=$(wildcard csv/*/*/flashes.csv)

ca:=$(patsubst %.csv,%.ca.csv,${csv})
ca_p:=$(patsubst %,%.p,${ca})

dataset.csv:=$(wildcard csv/*/*/datasets.csv)
dataset.p:=$(patsubst %,%.p,${dataset.csv})

info:
	echo ${dataset.p}

ca:${ca}

${ca}:%.ca.csv:%.csv
	csvgrep -c 5 -r '^((3[2-9])|(4[012]))\.' $< | csvgrep -c 6 -r '^-1((1[89])|(2[0-5]))\.' > $@

ca_p:${ca_p}

${ca_p}:%.csv.p:%.csv
	psql service=glm -c '\copy flash from $< with csv header' > $@

dataset.p:${dataset.p}

${dataset.p}:%.csv.p:%.csv
	psql service=glm -c '\copy dataset from $< with csv header' > $@
