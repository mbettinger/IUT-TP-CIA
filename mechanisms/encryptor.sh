ENC_FOLDER=$1
FILES_FOLDER=$2
KEY_FILE=$3
ALGOS=$4
OUT_FILE=$5
NB_REPEATS=$6
DECRYPT=$7
if test -z $DECRYPT
then
	for algo in $ALGOS
	do 
		echo $algo
		for file in `ls $FILES_FOLDER`
		do
			echo $file
			./chrono.sh "openssl enc $algo -in $FILES_FOLDER/$file -out $ENC_FOLDER/$file$algo.enc -kfile $KEY_FILE -pbkdf2" $OUT_FILE $NB_REPEATS
		done
	done
else
	for algo in $ALGOS
	do 
		echo $algo
		for file in `ls $ENC_FOLDER`
		do
			echo $file
			./chrono.sh "openssl enc $algo -in $ENC_FOLDER/$file -out $FILES_FOLDER/$file -kfile $KEY_FILE -pbkdf2" $OUT_FILE $NB_REPEATS
			old_file=`echo $FILES_FOLDER/$file | cut -d "-" -f 1`
			if test "`openssl dgst $FILES_FOLDER/$file | cut -d "=" -f 2`"="`openssl dgst $old_file | cut -d "=" -f 2`"
			then
				echo "Initial file and decrypted one match!"
			fi
		done
	done
fi