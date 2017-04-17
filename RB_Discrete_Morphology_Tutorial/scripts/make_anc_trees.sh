# Examples:
#
# Create an ancestral state tree for character 0
# > ./make_ase.sh 0
# 
# Create ancestral state trees for characters 3 through 5
# > ./

BASE_STR=$1
START_IDX=$2
END_IDX=$3
CHAR_LIST=`seq $START_IDX $END_IDX`

# make the output directory if it does not exist
mkdir -p $BASE_STR
BASE_FP=$(dirname $BASE_STR)
BASE_FN=$(basename $BASE_STR)

# create ancestral state estimates all characters in $CHAR_LIST
echo "Generating ancestral state trees...\n"
RB_COMMAND="out_fp = \"$BASE_FP\";
            out_str = \"$BASE_FN\";
            start_idx = $START_IDX;
            end_idx = $END_IDX;
            source(\"scripts/make_anc_state.Rev\");"

echo $RB_COMMAND | rb

# create pdfs for all characters in $CHAR_LIST
echo "Generating pdfs...\n"
PDF_FN_LIST=""
for IDX in $CHAR_LIST
do
    IDX_BASE_FN=$BASE_STR"/"$BASE_FN.char_$IDX.ase
    Rscript --vanilla scripts/plot_anc_state.R $IDX_BASE_FN.tre
    PDF_FN_LIST="$PDF_FN_LIST $IDX_BASE_FN.pdf"
done

## combine all characters' pdfs with gs
#echo "Combining pdfs...\n"
#MERGE_PDF_FN=$BASE_STR.char_$START_IDX"_to_"$END_IDX.pdf
#GS_CMD="gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$MERGE_PDF_FN $PDF_FN_LIST"
#$GS_CMD


