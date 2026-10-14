%option noyywrap noinput nounput yylineno
%{
#include <stdio.h>
%}
DIGIT   [0-9]
ID      [A-Za-z_][A-Za-z0-9_]*
NUMBER  {DIGIT}+([.]{DIGIT}+)?([eE][+-]?{DIGIT}+)?
%x COMMENT
%%
"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { /* yylineno is maintained by Flex */ }
<COMMENT>.              { /* Ignore comment contents. */ }
"//".*                  { /* Ignore a single-line comment. */ }
"int"|"float"|"char"|"if"|"else"|"while"|"return"|"for" {
                          printf("line %-3d KEYWORD      %s\n", yylineno, yytext);
                        }
{NUMBER}                 { printf("line %-3d NUMBER       %s\n", yylineno, yytext); }
{ID}                     { printf("line %-3d IDENTIFIER   %s\n", yylineno, yytext); }
"=="|"!="|"<="|">="|"++"|"--"|"&&"|"||"|[+*/%=<>!-] {
                          printf("line %-3d OPERATOR     %s\n", yylineno, yytext);
                        }
[(){};,]                 { printf("line %-3d PUNCTUATION  %s\n", yylineno, yytext); }
[ \t\r\n]+               { /* Ignore whitespace. */ }
.                        { printf("line %-3d UNKNOWN      %s\n", yylineno, yytext); }
%%
int main(void) {
    puts("Token stream:");
    return yylex();
}
