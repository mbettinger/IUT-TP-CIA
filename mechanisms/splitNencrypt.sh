ENC_FOLDER=$1
FILES_FOLDER=$2
FILE=$3
KEY_FILE=$4

split -b 100 $FILES_FOLDER/$FILE
echo $FILES_FOLDER/$FILE
for file in `ls`
do
    openssl rsautl -encrypt -pubin -inkey $KEY_FILE -in $file -out $ENC_FOLDER/$FILE-$file-rsa
done
