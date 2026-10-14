%option noyywrap noinput nounput
%{
#include "parser.tab.h"
#include <stdlib.h>
%}
%%
[0-9]+                  { yylval.number = strtol(yytext, NULL, 10); return NUMBER; }
[ \t\r]+                { /* Ignore horizontal whitespace. */ }
\n                      { return '\n'; }
[()+*/-]                { return yytext[0]; }
.                       { return yytext[0]; }
%%
