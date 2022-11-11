
# compile
flex -o lexer.c lexer.lex
g++ -c lexer.c -o lexer.o
g++ main.cpp lexer.o -o lexer


rm ans/all_cases.txt
for((i=1; i<=14; i++));
do
    # echo case_${i}
    ./lexer tests/case_${i}.pcat > ans/case_${i}.txt
    cat ans/case_${i}.txt >> ans/all_cases.txt # this file is only for checking
done


