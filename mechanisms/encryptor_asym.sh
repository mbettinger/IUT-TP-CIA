ENC_FOLDER=$1
FILES_FOLDER=$2
RSA_PUB_FILE=$3
OUT_FILE=$4
NB_REPEATS=$5
NAIVE=$6
echo $algo

if test -z $NAIVE
then
	rootdir=`pwd`
	mkdir -p tmp
	cd tmp
	for file in `ls ../$FILES_FOLDER`
	do
		echo $file
		../chrono.sh "$rootdir/splitNencrypt.sh ../${ENC_FOLDER} ../${FILES_FOLDER} $file ../${RSA_PUB_FILE}" ../${OUT_FILE} ${NB_REPEATS}
		rm -f x*
	done
	cd ..
	rm -rf tmp
else
	for file in `ls $FILES_FOLDER`
	do
		echo $file
		./chrono.sh "openssl rsautl -encrypt -pubin -inkey $RSA_PUB_FILE -in $FILES_FOLDER/$file -out $ENC_FOLDER/$file-rsa" $OUT_FILE $NB_REPEATS
		if test -s $ENC_FOLDER/$file-rsa
		then echo Successfully encrypted $ENC_FOLDER/$file-rsa!
		fi
	done
fi