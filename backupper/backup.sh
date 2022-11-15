PUSH_PULL=$1
BACKED_DIR=$2
BACKUP_DIR=$3

case $PUSH_PULL in
    push) 
    echo "Backing up $BACKED_DIR into $BACKUP_DIR"
    mkdir -p $BACKUP_DIR
    cp -r $BACKED_DIR/* $BACKUP_DIR
    echo "Successful backup of $BACKED_DIR into $BACKUP_DIR"
    ;;
    pull) 
    echo "Restoring $BACKUP_DIR into $BACKED_DIR"
    cp -r $BACKUP_DIR/* $BACKED_DIR
    echo "Successful restoration of $BACKUP_DIR into $BACKED_DIR"
    ;;
    *) echo "Unknown command: $PUSH_PULL, expected {push|pull} <backed_dir> <backup_dir>";;
esac
