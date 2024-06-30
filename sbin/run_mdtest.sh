#!/bin/bash
set -x

NODES=("node1" "node2" "node3" "node4" "node5" "node6" "node7" "node8")
for NODE in "${NODES[@]}"; do
    ssh $NODE "mkdir /users/penglb3/indexfs_conf/"
    scp etc/indexfs-distributed/* $NODE:/users/penglb3/indexfs_conf/
    scp build/md_test/mdtest_nobk  $NODE:/users/penglb3/indexfs_conf/
done

# 8 100 000
env ./sbin/start-all.sh
mpirun --host node1:2,node2:2,node3:2,node4:2 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
wait
./sbin/stop-all.sh

# # 8 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:2,node2:2,node3:2,node4:2 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 16 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:2,node2:2,node3:2,node4:2,node5:2,node6:2,node7:2,node8:2 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 32 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:4,node2:4,node3:4,node4:4,node5:4,node6:4,node7:4,node8:4 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 64 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:8,node2:8,node3:8,node4:8,node5:8,node6:8,node7:8,node8:8 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 128 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:16,node2:16,node3:16,node4:16,node5:16,node6:16,node7:16,node8:16 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 256 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:32,node2:32,node3:32,node4:32,node5:32,node6:32,node7:32,node8:32 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh

# # 512 100 000
# env INDEXFS_ROOT=/dev/shm/indexfs ./sbin/start-all.sh
# mpirun --host node1:64,node2:64,node3:64,node4:64,node5:64,node6:64,node7:64,node8:64 -x LDFLAGS="-L/usr/local/openssl-1.0.2/lib" -x CPPFLAGS="-I/usr/local/openssl-1.0.2/include" -x LD_LIBRARY_PATH="/usr/local/openssl-1.0.2/lib:$LD_LIBRARY_PATH" -x IDXFS_CONFIG_FILE=/users/penglb3/indexfs_conf/indexfs_conf -x IDXFS_SERVER_LIST=/users/penglb3/indexfs_conf/server_list /users/penglb3/indexfs_conf/mdtest_nobk -n 100000 -d / -C -T -r
# wait
# ./sbin/stop-all.sh
