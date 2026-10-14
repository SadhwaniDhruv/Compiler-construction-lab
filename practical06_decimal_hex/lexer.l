%option noyywrap noinput nounput
%{
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
extern FILE *yyin;
%}
%%
[0-9]+                  {
                          errno = 0;
                          unsigned long long value = strtoull(yytext, NULL, 10);
                          if (errno == ERANGE) {
                              fprintf(stderr, "Decimal value out of range: %s\n", yytext);
                              ECHO;
                          } else {
                              printf("0x%llX", value);
                          }
                        }
.                       { ECHO; }
\n                      { ECHO; }
%%
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input.txt > converted.txt\n", argv[0]);
        return 2;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) { perror(argv[1]); return 1; }
    int result = yylex();
    fclose(yyin);
    return result;
}
