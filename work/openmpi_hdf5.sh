#!/bin/bash
# gcc compilation and install of openmpi and hdf5 in parallel

INSTALLDIR=/home/$(logname)/software/
MAKEDIR=/home/$(logname)/code/testing/tmp

cd MAKEDIR
mkdir openmpi
mkdir hdf5

cd openmpi
wget https://download.open-mpi.org/release/open-mpi/v4.0/openmpi-4.0.2.tar.gz
tar xf openmpi-4.0.2.tar.gz
cd openmpi-4.0.2/

./configure --prefix=INSTALLDIR/openmpi TMPDIR=MAKEDIR/tmp | tee openmpi.out
make && make install

less openmpi.out

cd ../hdf5
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.5/src/hdf5-1.10.5.tar.gz
tar xf hdf5-1.10.5.tar.gz
cd hdf5-1.10.5

./configure --prefix=INSTALLDIR/hdf5 TMPDIR=MAKEDIR/tmp/ CC=mpicc LD_LIBRARY_PATH=INSTALLDIR/openmpi/lib/ --enable-parallel | tee hdf5.out
make && make install

less hdf5.out