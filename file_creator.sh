FILE_NAME=$1
SIZE=$2

dd if=/dev/zero of=$FILE_NAME bs=1 count=0 seek=$SIZE
