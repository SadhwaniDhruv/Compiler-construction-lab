%option noyywrap noinput nounput
%{
#include "parser.tab.h"
#include <stdlib.h>
%}
%%
([0-9]+([.][0-9]*)?|[.][0-9]+)([eE][+-]?[0-9]+)? {
                          yylval.number = strtod(yytext, NULL);
                          return NUMBER;
                        }
[ \t\r]+                { /* Ignore horizontal whitespace. */ }
\n                      { return '\n'; }
[()+*/-]                { return yytext[0]; }
.                       { return yytext[0]; }
%%
