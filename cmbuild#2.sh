#!/bin/sh

umask 0022

PRODUCT_NAME=1uxdbpatches
PRODUCT_FULLNAME="1ux dbpatches"
PRODUCT_VER=he43.rel1
PRODUCT_GROUP_NAME=1ux
OUTPUT_DIR=`pwd`

# Set CHANGENUM_VERSIONING to Y to number the builds with the most recent change #
CHANGENUM_VERSIONING=N

SUDO=sudo

COMPONENT_SERIES=$PRODUCT_NAME-$PRODUCT_VER
STAGING_DIR=/mnt/staging/builds.acn/$PRODUCT_VER/$PRODUCT_GROUP_NAME
REPORTS_DIR=/mnt/scm/reports/diff/$PRODUCT_VER/$PRODUCT_NAME

source /home/build/scm/$PRODUCT_VER/common/scm/builds.common.sh
source /home/build/scm/$PRODUCT_VER/common/scm/perforce.common.sh

BUILDFILE_NAME=$PRODUCT_VER-$PRODUCT_NAME-$CURRBUILD

BASE_DIR=../$PRODUCT_NAME
BUILD_DIR=$BASE_DIR

build () {
echo ''
echo '----------------------------------------------------------------'
echo " Pre-Build cleanup for $CURRBUILD_NAME"
echo '----------------------------------------------------------------'
echo ''

echo 'Cleaning targets...'
$SUDO rm -rf $BUILD_DIR
rm -f $BASE_DIR/*.log

echo "Cleaning up old diff reports..."
cd $BASE_DIR
rm $PRODUCT_VER-*.txt

echo ''
echo "------------------------------------------------------"
echo "Assembling files and creating $BUILDFILE_NAME.tar" 
echo "------------------------------------------------------"

cd $BASE_DIR 

# Create tar file
echo "Creating $BUILDFILE_NAME.tar..."
$SUDO tar cfpP $BUILDFILE_NAME.tar 1UX_DB_HE4.0.01-mysql.sql
$SUDO chown build:build $BUILDFILE_NAME.tar
cd -

if [ $? -gt 0 ]
then 
  ERROR_STR="Error bulding Trggerserver-dbpatches!"
  RETVAL=4
  return 
fi
return
}

finish () {
	echo "Copying tar file log to $STAGING_DIR/$BASE_SWVERSION..."
	mkdir -p $STAGING_DIR
	cp $OUTPUT_DIR/$BUILDFILE_NAME.tar $STAGING_DIR/.

	deploy
} 

#build_prep
#  if [ $RETVAL -gt 0 ]; then build_error $ERROR_STR ; fi
build
  if [ $RETVAL -gt 0 ]; then build_error $ERROR_STR ; fi
finish
echo ''
echo "$CURRBUILD_NAME build completed!"
