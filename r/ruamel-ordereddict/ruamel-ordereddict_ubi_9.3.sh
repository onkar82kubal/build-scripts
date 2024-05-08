#!/bin/bash -e
# -----------------------------------------------------------------------------
#
# Package           : ordereddict
# Version           : 0.4.15
# Source repo       : https://github.com/ruamel/ordereddict
# Tested on         : UBI:9.3
# Language          : Python
# Travis-Check      : True
# Script License    : Apache License, Version 2 or later
# Maintainer        : Vinod K <Vinod.K1@ibm.com>
#
# Disclaimer        : This script has been tested in root mode on given
# ==========          platform using the mentioned version of the package.
#                     It may not work as expected with newer versions of the
#                     package and/or distribution. In such case, please
#                     contact "Maintainer" of this script.
#
# ----------------------------------------------------------------------------
PACKAGE_NAME=ordereddict
PACKAGE_VERSION=${1:-0.4.15}
PACKAGE_URL=https://github.com/ruamel/ordereddict

set -e

yum -y update && yum install -y python2 python2-devel git gcc gcc-c++ make redhat-rpm-config
python2 -m pip install Mercurial

HOME_DIR=`pwd`
OS_NAME=$(cat /etc/os-release | grep ^PRETTY_NAME | cut -d= -f2)

if ! git clone $PACKAGE_URL $PACKAGE_NAME; then
    	echo "------------------$PACKAGE_NAME:clone_fails---------------------------------------"
		echo "$PACKAGE_URL $PACKAGE_NAME"
		echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Clone_Fails"
    	exit 0
fi

cd $HOME_DIR/$PACKAGE_NAME
git checkout $PACKAGE_VERSION
if ! python2 -m pip install .; then
    echo "------------------$PACKAGE_NAME:install_fails---------------------------------------"
	echo "$PACKAGE_URL $PACKAGE_NAME"
	echo "$PACKAGE_NAME  |  $PACKAGE_URL |  $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_Fails"
	exit 0
fi

cd $HOME_DIR/$PACKAGE_NAME
if ! python2 test/testordereddict.py; then
	echo "------------------$PACKAGE_NAME:install_success_but_test_fails---------------------"
	echo  "$PACKAGE_URL $PACKAGE_NAME " 
	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE | Fail |  Install_success_but_test_Fails"
	exit 0
else
	echo "------------------$PACKAGE_NAME:install_and_test_both_success-------------------------"
	echo  "$PACKAGE_URL $PACKAGE_NAME " 
	echo "$PACKAGE_NAME  |  $PACKAGE_URL | $PACKAGE_VERSION | $OS_NAME | $SOURCE  | Pass |  Both_Install_and_Test_Success"
	exit 0
fi