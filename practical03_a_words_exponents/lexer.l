%option noyywrap noinput nounput
%{
#include <stdio.h>
static long a_words = 0, exponent_numbers = 0;
%}
EXP [0-9]+([.][0-9]+)?[eE][+-]?[0-9]+
WORD [A-Za-z]+
%%
{EXP}                   { ++exponent_numbers; printf("exponential number: %s\n", yytext); }
{WORD}                  {
                          if (yytext[0] == 'A' || yytext[0] == 'a') {
                              ++a_words;
                              printf("word starting with A: %s\n", yytext);
                          }
                        }
[0-9]+([.][0-9]+)?      { /* Ordinary decimal number. */ }
.                       { /* Ignore punctuation and whitespace. */ }
%%
int main(void) {
    yylex();
    printf("Words starting with A/a: %ld\nExponential numbers: %ld\n",
           a_words, exponent_numbers);
    return 0;
}
