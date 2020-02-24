#!/bin/bash
# gcc compilation and install of openmpi and hdf5 in parallel

INSTALLDIR=/home/$(logname)/software/
MAKEDIR=/home/$(logname)/code/testing/
CORES_TO_USE=$((`nproc` - 4))

mkdir $MAKEDIR
mkdir $INSTALLDIR

cd $MAKEDIR
mkdir tmp
mkdir openmpi
mkdir hdf5

cd openmpi
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz
tar xf openmpi-4.0.2.tar.gz
cd openmpi-4.0.2/

./configure --prefix=$INSTALLDIR/openmpi TMPDIR=$MAKEDIR/tmp | tee openmpi.out
make -j $CORES_TO_USE && make install

cd $MAKEDIR/hdf5
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
tar xf hdf5-1.10.5.tar.gz
cd hdf5-1.10.5

./configure --prefix=$INSTALLDIR/hdf5 TMPDIR=$MAKEDIR/tmp/ CC=mpicc LD_LIBRARY_PATH=$INSTALLDIR/openmpi/lib/ --enable-parallel | tee hdf5.out
make -j $CORES_TO_USE && make install

echo "success! outputting log files now..."
sleep 5

less $MAKEDIR/openmpi/openmpi-4.0.2/openmpi.out
less $MAKEDIR/hdf5/hdf5-1.10.5/hdf5.out