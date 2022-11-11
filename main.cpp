#include <iostream>
#include <cstdio>
#include <iomanip>
#include "lexer.h"
using namespace std;

int yylex();
extern "C" FILE *yyin;
extern "C" char *yytext;

int main(int argc, char **argv)
{
    if (argc > 1){
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    cout << left << setw(8) << "ROW" << setw(8) << "COL";
    cout << setw(20) << "TYPE" << setw(20) << "TOKEN/ERROR MESSAGE" << endl;
    while (true){
        int n = yylex();
        if (n == T_EOF || n == C_EOF){
            break;
        }
        // cout << yytext << endl;
    }
    
    return 0;
}
