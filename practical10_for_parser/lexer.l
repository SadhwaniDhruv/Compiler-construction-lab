%option noyywrap noinput nounput
%{
#include "parser.tab.h"
%}
ID [A-Za-z_][A-Za-z0-9_]*
%%
"for"                   { return FOR; }
"++"                    { return INC; }
"--"                    { return DEC; }
"<="                    { return LE; }
">="                    { return GE; }
"=="                    { return EQ; }
"!="                    { return NE; }
{ID}                    { return ID; }
[0-9]+                  { return NUMBER; }
[ \t\r\n]+              { /* Ignore whitespace. */ }
[{}();=<>+*/-]           { return yytext[0]; }
.                       { return yytext[0]; }
%%
