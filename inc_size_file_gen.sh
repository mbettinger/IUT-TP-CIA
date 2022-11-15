PREFIX=$1
FILE_SIZES=$2
for size in $FILE_SIZES
do
	./file_creator.sh $PREFIX.$size $size
done
