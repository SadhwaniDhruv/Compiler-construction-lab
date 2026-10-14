%option noyywrap noinput nounput
%{
#include <stdio.h>
%}
%%
^.*COM\r?$               { printf("MATCH: %s\n", yytext); }
.*\n                    { /* A complete nonmatching line. */ }
.+                      { /* A final unterminated nonmatching line. */ }
%%
int main(void) {
    puts("Lines ending with COM:");
    return yylex();
}
