ENC_FOLDER=$1
FILES_FOLDER=$2
KEY_FILE=$3
ALGOS=$4
OUT_FILE=$5
NB_REPEATS=$6
for algo in $ALGOS
do 
	echo $algo
	for file in `ls $FILES_FOLDER`
	do
		echo $file
		./chrono.sh "openssl enc $algo -in $FILES_FOLDER/$file -out $ENC_FOLDER/$file$algo.enc -kfile $KEY_FILE -pbkdf2" $OUT_FILE $NB_REPEATS
	done
done
