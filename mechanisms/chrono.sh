COMMAND=$1
OUT_FILE=$2
NB_REPEATS=$3

if test -n $OUT_FILE
then 
for i in `seq $NB_REPEATS`
do
\time -a -o $OUT_FILE -f "%C,%E,%U,%S,%P" $COMMAND 
done
else \time -f "Program: %C\nTotal time: %E\tUser Mode (s) %U\tKernel Mode (s) %S\tCPU: %P" $COMMAND
fi
