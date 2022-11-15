ENC_FOLDER=$1
FILES_FOLDER=$2
KEY_FILE=$3

split -b 100 $FILES_FOLDER
for file in `ls`
do
    openssl rsautl -encrypt -pubin -inkey $KEY_FILE -in $file -out $ENC_FOLDER/$file-rsa
done
