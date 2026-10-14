%option noyywrap noinput nounput
%{
#include <ctype.h>
#include <stdio.h>
#include <string.h>
static int mode_upper = 1;
%}
%%
[A-Za-z]+               {
                          for (int i = 0; i < yyleng; ++i) {
                              unsigned char c = (unsigned char)yytext[i];
                              putchar(mode_upper ? toupper(c) : tolower(c));
                          }
                        }
.                       { ECHO; }
%%
int main(int argc, char **argv) {
    if (argc > 2 || (argc == 2 && strcmp(argv[1], "--lower") != 0 &&
                                  strcmp(argv[1], "--upper") != 0)) {
        fprintf(stderr, "Usage: %s [--upper|--lower] < input.txt\n", argv[0]);
        return 2;
    }
    if (argc == 2 && strcmp(argv[1], "--lower") == 0) mode_upper = 0;
    return yylex();
}
