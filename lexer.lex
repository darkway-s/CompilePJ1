%{
#include "lexer.h"
#include <math.h>

void TokenOutput(int& row, int& col, const char* type, char* text);
int row = 1;
int col = 1;
%}
%option     nounput
%option     noyywrap

KEYWORD     ("AND"|"ARRAY"|"BEGIN"|"BY"|"DIV"|"DO"|"ELSE"|"ELSIF"|"END"|"EXIT"|"FOR"|"IF"|"IN"|"IS"|"LOOP"|"MOD"|"NOT"|"OF"|"OR"|"OUT"|"PROCEDURE"|"PROGRAM"|"READ"|"RECORD"|"RETURN"|"THEN"|"TO"|"TYPE"|"VAR"|"WHILE"|"WRITE")
DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
WS          [ \t]+

STRING      ["][^'\"']*["]
ID          [a-zA-Z][a-zA-Z0-9]*
DELIMETER   (":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"[<"|">]"|'\')
OPERATOR    (":="|'+'|'-'|'*'|"/"|"<"|"<="|">"|">="|"="|"<>")


%%

<<EOF>>     return T_EOF;

{KEYWORD}       TokenOutput(row, col, "Keyword  ", yytext);

{STRING}        TokenOutput(row, col, "String   ", yytext);

{OPERATOR}      TokenOutput(row, col, "Operator ", yytext);

{DELIMETER}     TokenOutput(row, col, "Delimeter", yytext);

{ID}            TokenOutput(row, col, "Identifer", yytext);

{INTEGER}       TokenOutput(row, col, "Integer  ", yytext);

{REAL}          TokenOutput(row, col, "Real     ", yytext);


\n              {
                row++; col = 1;
                }   


.               col++;

%%

void TokenOutput(int& row, int& col, const char* type, char* text){

        printf("%d\t%d\t%s\t%s\n",
                        row, col, type ,text);
        col += strlen(text);

        return;
}
    