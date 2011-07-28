#!/bin/bash

#   ***************************************************************************
#     build-libs.sh - builds all needed libraries for android QGIS
#      --------------------------------------
#      Date                 : 01-Jun-2011
#      Copyright            : (C) 2011 by Marco Bernasocchi
#      Email                : marco at bernawebdesign.ch
#   ***************************************************************************
#   *                                                                         *
#   *   This program is free software; you can redistribute it and/or modify  *
#   *   it under the terms of the GNU General Public License as published by  *
#   *   the Free Software Foundation; either version 2 of the License, or     *
#   *   (at your option) any later version.                                   *
#   *                                                                         *
#   ***************************************************************************/

set -e

source `dirname $0`/config.conf

########START SCRIPT########
usage(){
 echo "Usage:"
 echo " build-libs.sh 
        --help (-h)
        --version (-v)
        --echo <text> (-e)      this option does noting"
}

echo "BUILDING ANDROID QGIS LIBS2"
echo "SRC location: " $SRC_DIR
echo "NDK location: " $ANDROID_NDK_ROOT
echo "Standalone toolchain location: " $ANDROID_NDK_TOOLCHAIN_ROOT
echo "PATH:" $PATH
echo "You can configure all this and more in `dirname $0`/config.conf"

export REMOVE_DOWNLOADS=0

while test "$1" != "" ; do
        case $1 in
                --echo|-e)
                        echo "$2"
                        shift
                ;;
                --help|-h)
                        usage
                        exit 0
                ;;
                --version|-v)
                        echo "build.sh version 0.0.1"
                        exit 0
                ;;
                -*)
                        echo "Error: no such option $1"
                        usage
                        exit 1
                ;;
        esac
        shift
done

#confirm settings if not running build_all.sh
if [ ! -n "${QGIS_ANDROID_BUILD_ALL+x}" ]; then
  CONTINUE="n"
  echo "OK? [y, n*]:"
  read CONTINUE
else
  CONTINUE="y"
fi
  
CONTINUE=$(echo $CONTINUE | tr "[:upper:]" "[:lower:]")
if [ "$CONTINUE" != "y" ]; then
  echo "Abort"
  exit 1
else
  cd $SRC_DIR


  #########QTUITOOLS########
  echo "QTUITOOLS"	
  cd $QT_SRC/tools/designer/src/uitools
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  $QMAKE  uitools.pro 
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END QTUITOOLS########
  

  #########QWT5.2.0########
  echo "QWT5.2.0"	
  cd $SRC_DIR/qwt-5.2.0/
  #configure
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  $QMAKE qwt.pro
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END EXPAT2.0.1########


  #########EXPAT2.0.1########
  echo "EXPAT2.0.1"
  cd $SRC_DIR/expat-2.0.1/
  #configure
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --prefix=$INSTALL_DIR --host=arm-linux-androideabi
  #compile
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END EXPAT2.0.1########
  
  #########GSL1.14########
  echo "GSL1.14"
  cd $SRC_DIR/gsl-1.14/
  #configure
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --prefix=$INSTALL_DIR --host=arm-linux-androideabi
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END GSL1.14########



  #########SQLITE3.7.4########
  echo "SQLITE"
  cd $SRC_DIR/sqlite-autoconf-3070400/
  #configure
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --prefix=$INSTALL_DIR --host=arm-linux-androideabi
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END SQLITE3.7.4########


  ##########PROJ4########
  echo "PROJ4"
  cd $SRC_DIR/proj-4.7.0/
  #configure
  CFLAGS=$MY_STD_CFLAGS \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --prefix=$INSTALL_DIR --host=arm-linux-androideabi
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END PROJ4########


  #########LIBICONV1.13.1########
#  echo "LIBICONV"
#  cd $SRC_DIR/libiconv-1.13.1/
#  #configure
#  CFLAGS=$MY_STD_CFLAGS \
#  LDFLAGS=$MY_STD_LDFLAGS \
#  ./configure --host=arm-linux-androideabi --prefix=$INSTALL_DIR
#  #compile
#  make -j$CORES 2>&1 | tee make.out
#  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END LIBICONV1.13.1########
  

  #########GEOS3.2.2########
  echo "GEOS3.2.2"
  cd $SRC_DIR/geos-3.2.2/
  #configure
  CFLAGS=$MY_STD_CFLAGS LIBS="-lsupc++ -lstdc++" \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --host=arm-linux-androideabi --prefix=$INSTALL_DIR
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END GEOS3.2.2########


  #########GDAL1.8.0########
  echo "GDAL"
  cd $SRC_DIR/gdal-1.8.0/
  #configure
  CFLAGS=$MY_STD_CFLAGS LIBS="-lsupc++ -lstdc++" \
  LDFLAGS=$MY_STD_LDFLAGS \
  ./configure --host=arm-linux-androideabi --without-grib --prefix=$INSTALL_DIR
  #compile
  make -j$CORES 2>&1 | tee make.out
  make -j$CORES 2>&1 install | tee makeInstall.out
  #########END GDAL1.8.0########
  
  exit 0
fi