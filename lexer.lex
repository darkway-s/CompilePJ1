%{
#include "lexer.h"
#include<iostream>
#include <math.h>
#include <cstdio>
#include <iomanip>
using namespace std;


void TokenOutput(int& row, int& col, const char* type, char* text, char* msg);
void CommentOutput(int& row, int& col, const char* type, char* text, char* msg);

int row = 1;
int c_ori_row = 1;
int c_ori_col = 1;
int col = 1;
int TokensNumber = 0;

%}
%option     nounput
%option     noyywrap
%x COMMENT

KEYWORD     ("AND"|"ARRAY"|"BEGIN"|"BY"|"DIV"|"DO"|"ELSE"|"ELSIF"|"END"|"EXIT"|"FOR"|"IF"|"IN"|"IS"|"LOOP"|"MOD"|"NOT"|"OF"|"OR"|"OUT"|"PROCEDURE"|"PROGRAM"|"READ"|"RECORD"|"RETURN"|"THEN"|"TO"|"TYPE"|"VAR"|"WHILE"|"WRITE")
DIGIT       [0-9]
INTEGER     {DIGIT}+
REAL        {DIGIT}+"."{DIGIT}*
WS          [ \t]+

STRING      \"[^\"^\n]*\"
UNSTRING    \"[^\"^\n]*\n
ID          [a-zA-Z][a-zA-Z0-9]*
DELIMITER   (":"|";"|","|"."|"("|")"|"["|"]"|"{"|"}"|"[<"|">]"|'\')
OPERATOR    (":="|"+"|"-"|"*"|"/"|"<"|"<="|">"|">="|"="|"<>")


%%

<INITIAL><<EOF>> {
                        cout << endl << "Number of tokens: " << TokensNumber << endl;
                        return T_EOF;
                 }

{WS}            col += strlen(yytext);

{KEYWORD}       TokenOutput(row, col, "Keyword  ", yytext, "");

{UNSTRING}      {
                        
                        col = 1;
                        TokenOutput(row, col, "Invalid", yytext, "ERROR: Unterminated string");
                        row++;
                        
                }

{STRING}        {
                        if (strlen(yytext) > 257){
                                char msg[] = "ERROR: String is longer than 255";
                                TokenOutput(row, col, "Invalid", yytext, msg);
                                return 1;
                        }
                        for(int cnt=0; cnt<strlen(yytext); cnt++){
                                if(yytext[cnt] == '\t'){
                                        char msg[] = "ERROR: String contains tab";
                                        TokenOutput(row, col, "Invalid", yytext, msg);
                                        return 1;
                                }
                        }
                        TokenOutput(row, col, "String   ", yytext, "");
                }

{OPERATOR}      TokenOutput(row, col, "Operator ", yytext, "");

{DELIMITER}     TokenOutput(row, col, "Delimiter", yytext, "");

{ID}            {
                        if (strlen(yytext) > 255){
                                char msg[] = "ERROR: Identifier is longer than 255";
                                TokenOutput(row, col, "Invalid", yytext, msg);
                                return 1;
                        }
                        TokenOutput(row, col, "Identifer", yytext, "");
                }

{INTEGER}       {
                        if(strlen(yytext) > 9 && atoi(yytext) == -1)
                        {
                                char msg[] = "ERROR: Integer out of range";
                                TokenOutput(row, col, "Invalid", yytext, msg);
                                return 1;
                        }
                        TokenOutput(row, col, "Integer", yytext, "");
                }

{REAL}          TokenOutput(row, col, "Real", yytext, "");


\n              {
                        row++; col = 1;
                }   

.               {
                        if(!strcmp(yytext, " ")){
                                col++;
                        }
                        else{
                                TokenOutput(row, col, "Invalid", yytext, "ERROR: Bad character");
                        }
                }

"(*"                   {
                                c_ori_col = col; 
                                c_ori_row = row; 
                                col += 2; 
                                BEGIN COMMENT; 
                                yymore();
                        }
<COMMENT>.             {col ++; yymore();}

<COMMENT>\n            {col = 1; row++; yymore();} 

<COMMENT>"*)"           {
                                BEGIN INITIAL;
                                col += 2;
                                CommentOutput(c_ori_row, c_ori_col, "Comment", yytext, "");
                        }



<COMMENT><<EOF>>        {
                                CommentOutput(c_ori_row, c_ori_col, "Invalid", yytext, "ERROR: Unterminated comment");
                                BEGIN INITIAL;
                                cout << "Number of tokens: " << TokensNumber << endl;
                                return C_EOF;
                        }



%%

void TokenOutput(int& row, int& col, const char* type, char* text, char* msg){

        cout << left << setw(8) << row << setw(8) << col;
        if(msg != "")
                cout << setw(20) << type << msg << ": " << text << endl;
        else
                cout << setw(20) << type << text << endl;
        col += strlen(text);
        TokensNumber++;

        return;
}

void CommentOutput(int& row, int& col, const char* type, char* text, char* msg){
        cout << left << setw(8) << row << setw(8) << col;
        if(msg != "")
                cout << setw(20) << type << msg << ": " << text << endl;
        else
                cout << setw(20) << type << text << endl;
        return;
}
