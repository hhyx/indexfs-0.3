IndexFS - 0.3.3
===============

IndexFS is designed as file system middleware layered on top of an
existing cluster file system deployment to improve metadata performance
as well as small file operation efficiency of the original file system.
IndexFS reuses the data path of the underlying file system and packs
directory entries, file attributes, and small file data into a set of
large, immutable, log-structured, and indexed, data structures
(**_SSTables_**) that are stored in the underlying file system. Our
experiments show that IndexFS is able to our-perform existing solutions
such as `PVFS`, `Lustre`, and `HDFS`, by as much as orders of magnitude.

The following is a guide describing how to install and run IndexFS on
your local Linux machine. Please visit our project home at
http://www.pdl.cmu.edu/indexfs for more information. Please also note that
the current implementation of IndexFS is not of production quality
and is recommended to be used for research purpose only. Thanks a lot.

INDEXFS INSTALLATION GUIDE
==========================

1. System Prerequisites
2. Build from Source
3. IndexFS in Standalone Mode

SYSTEM PREREQUISITES
--------------------

IndexFS depends on `gflags`, `glog`, and `thrift`. In order to build
IndexFS from its source, you will also need a C++ building system
such as `GUN` including `gcc`, `g++`, `make`, `autoconf`, `automake`,
and `libtool`.

In addition, some benchmarks that IndexFS uses to evaluate system
performance are build with `MPI` -- at least one implementation of MPI
(`OpenMPI`) should be present for these benchmarks to compile and run.

To help ease IndexFS deployment and avoid dependency issues, IndexFS
provides gflags, glog, and thrift source packages along with its src
code. System administrators may directly use these packages to build
and install these required IndexFS dependencies.

## STEP-BY-STEP INSTRUCTIONS

### INSTALL SYSTEM PACKAGES

        sudo apt-get install -y gcc g++ make flex bison
        sudo apt-get install -y autoconf automake libtool pkg-config
        sudo apt-get install -y zlib1g-dev libsnappy-dev
        sudo apt-get install -y libboost-all-dev libevent-dev libssl-dev
        sudo apt-get install -y pdsh libfuse-dev libopenmpi-dev

### Build & Install Depends


* **Install gflags and glog**:

        sudo apt install -y libgflags-dev libgoogle-glog-dev   

* **To build thrift 0.10.0**:

        sudo apt install -y checkinstall
        wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz
        tar -xzf openssl-1.0.2u.tar.gz
        cd openssl-1.0.2u/
        ./config --prefix=/usr/local/openssl-1.0.2 --openssldir=/usr/local/openssl-1.0.2 shared
        make -j
        sudo checkinstall --pkgname=openssl-1.0.2 --pkgversion=1.0.2u --backup=no --deldoc=yes --fstrans=no --default
        cd ..
        git clone https://github.com/apache/thrift.git
        cd thrift
        git checkout 0.10.0
        ./bootstrap.sh
        export LDFLAGS="-L/usr/local/openssl-1.0.2/lib"
        export CPPFLAGS="-I/usr/local/openssl-1.0.2/include"
        export LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH"
        ./configure --with-openssl=/usr/local/openssl-1.0.2 --without-qt4 --without-qt5 --without-c_glib --without-csharp --without-java --without-erlang --without-nodejs --without-lua --without-python --without-perl --without-php --without-php_extension --without-ruby --without-haskell --without-go --without-haxe --without-d --enable-tests=no --enable-tutorial=no
        make -j
        sudo checkinstall --pkgname=thrift-0.10.0 --pkgversion=0.10.0 --backup=no --deldoc=yes --fstrans=no --default
        cd ..

-------------------------

### Build IndexFS

IndexFS also follows GNU standard building process. For your
convenience, IndexFS provides `bootstrap.sh` which does this
automatically for you.

* **To build IndexFS**:
  
        git clone https://github.com/hhyx/indexfs-0.3.git
        cd indexfs-0.3
        export LDFLAGS="-L/usr/local/openssl-1.0.2/lib"
        export CPPFLAGS="-I/usr/local/openssl-1.0.2/include"
        export LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH"
        export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
        export LDFLAGS="-L/usr/local/lib"
        export CPPFLAGS="-I/usr/local/include"
        ./bootstrap.sh

NB: you don't have to install IndexFS into your system. Our scripts
will not assume IndexFS binaries to be accessible from your system path.

INDEXFS IN STANDALONE MODE
--------------------------

##### Run standalone IndexFS

Running IndexFS in standalone mode is a quick way to test if IndexFS
has been successfully built.

By being _standalone_, we mean running one single IndexFS (metadata)
server instance and multiple client processes at one single machine.
So everything is in one box.

* **To start IndexFS server**

        sbin/start-idxfs.sh

* **To start IndexFS clients (processes) and run tests**

        sbin/tree-test.sh

* **To stop IndexFS server**

        sbin/stop-idxfs.sh

In the above scripts, IndexFS server will be started as a daemon
running in the background. It's pid will be remembered at
**/tmp/indexfs/metadata_server.pid**.

A simple MPI-based test will be performed against IndexFS in terms of
its metadata path. The test will fork 2 client processes to
collectively create and stat 1600 files under 1 single shared
directory. This test is expected to conclude in less than 1 second.

INDEXFS IN DISTRIBUTED MODE
--------------------------

Assuming you have completed the interconnection of the machines, for example use noded0(10.10.1.1) and node1(10.10.1.2).

* **Deploy indexfs mds on one machine and run the client on other machines**: You need to deploy indexfs on one machine and complete INSTALL SYSTEM PACKAGES and Build&Install Depends on other machines. 

* **Deploy indexfs mds on multi machines and run the client on other machines**: You should modify server_list and configuring the indexfs environment in the same directory on each machine. You need to complete INSTALL SYSTEM PACKAGES, Build&Install Depends and Build IndexFS on the same directory for each machine. Then configure shared directories for multiple machines based on indexfs_conf: The default directory is/tmp/indexfs. Using nfs as an example, configure node0 and node1.

        # at node0
        sudo apt install -y nfs-kernel-server nfs-common
        mkdir /tmp/indexfs
        sudo chown nobody:nogroup /tmp/indexfs
        sudo chmod 777 /tmp/indexfs
        echo "/tmp/indexfs 10.10.1.1/24(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
        sudo exportfs -a
        sudo systemctl start nfs-kernel-server
        sudo systemctl enable nfs-kernel-server

        ssh node1 'sudo apt install -y nfs-kernel-server nfs-common'
        ssh node1 'mkdir /tmp/indexfs'
        ssh node1 'sudo mount 10.10.1.1:/tmp/indexfs /tmp/indexfs'

* **Change IP and configure**: Change IP and port at etc/indexfs-distributed/server_list. Change configure at etc/indexfs-distributed/indexfs_conf. If you deploy indexfs on multiple machines, the configuration file of each machine needs to be modified.

* **To start IndexFS server**

        sbin/start-all.sh

* **Transfer configuration file**: You need to send indexfs_conf, server_list and mdtest_nobk to the machine running the test. And modify the directory of mdtest below.

        ssh node1 "mkdir /users/penglb3/indexfs_conf/"
        scp etc/indexfs-distributed/* node1:/users/penglb3/indexfs_conf/
        scp build/md_test/mdtest_nobk  node1:/users/penglb3/indexfs_conf/

* **To run mdtest**: Reading test file not implemented, skipping with -C -T -r.

        mpirun --host node1:16 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 1000 -d / -C -T -r

* **To stop IndexFS server**

        sbin/stop-all.sh
