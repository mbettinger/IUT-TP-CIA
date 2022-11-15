FILES_FOLDER=files
ENC_FOLDER=encrypted
PREFIX=file
KEYS_DIR=keys

OUT_FILE=out.csv

FILE_PATH=${FILES_FOLDER}/${PREFIX}
FILE_SIZES="1w 100w 200w 1000w 1b 1k 10k 100k 1M 10M 100M 1G"

#Symmetric encryption
KEY_FILE=${KEYS_DIR}/key.txt
ALGOS="-rc4 -des -des3 -blowfish -aes-128-cbc -aes-256-cbc -chacha20"
#Asymetric encryption
RSA_KEY_SIZE=4096
RSA_PRIV_FILE=${KEYS_DIR}/rsa.priv
RSA_PUB_FILE=${KEYS_DIR}/rsa.pub

NB_REPEATS=10

all: mkdirs password create_files encrypt_sym

mkdirs:
	mkdir -p ${FILES_FOLDER} ${ENC_FOLDER} ${KEYS_DIR}

create_files: mkdirs
	mkdir -p ${FILES_FOLDER}
	./inc_size_file_gen.sh ${FILE_PATH} ${FILE_SIZES}

encrypt_sym:
	./encryptor.sh ${ENC_FOLDER} ${FILES_FOLDER} ${KEY_FILE} ${ALGOS} ${OUT_FILE} ${NB_REPEATS}

gen_asym_keys: mkdirs
	openssl genrsa -out ${RSA_PRIV_FILE} ${RSA_KEY_SIZE}
	openssl rsa -in ${RSA_PRIV_FILE} -pubout -out ${RSA_PUB_FILE}

encrypt_asym: gen_asym_keys
	./encryptor_asym.sh ${ENC_FOLDER} ${FILES_FOLDER} ${RSA_PUB_FILE} ${OUT_FILE} ${NB_REPEATS}

password: mkdirs
	./get_pass.sh ${KEY_FILE}

clean:
	rmdir -rf ${FILES_FOLDER}
	rmdir -rf ${ENC_FOLDER}
	rmdir -rf ${KEYS_DIR}
