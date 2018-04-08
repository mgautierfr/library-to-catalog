#!/bin/bash
#
# library-to-catalog.sh
#	converts a kixix.xml library file into a pibox/ideascube yaml catalog
#
######### 

ROOT="$( cd "$(dirname "$0")" ; pwd -P )"
VIRTUAL_ENV=$ROOT/lib2catalog_env
library_xml=$1
catalog_yaml=$2
tmp_yaml=${ROOT}/.kiwix-catalog.yml


function fail {
	if [ "$1a" != "a" ] ; then
		echo $1
	fi
	exit 1
}


function usage {
	echo "Usage: $0 LIBRARY_XML_PATH CATALOG_YML_PATH [zim|zip]"
	exit
}


function setup {
	if [ -d $VIRTUAL_ENV -a -f $VIRTUAL_ENV/bin/python ] ; then
		# virtualenv is present and OK
		return 0
	fi

	virtualenv $VIRTUAL_ENV
	$VIRTUAL_ENV/bin/pip install -r ${ROOT}/requirements.pip
}


function run {

	setup

	rm -f $tmp_yaml
	$VIRTUAL_ENV/bin/python $ROOT/library-to-catalog.py $library_xml $tmp_yaml || fail
	if [ -f $tmp_yaml ] ; then
		mv $tmp_yaml $catalog_yaml
		exit 0
	else
		fail "YAML file ${tmp_yaml} has not been created."
	fi
}


if [ "${library_xml}a" = "a" -o "${catalog_yaml}a" = "a" ] ; then
	usage
fi

if [ ! -f $library_xml ] ; then
	fail "Unable to read library file ${library_xml}"
fi

run
