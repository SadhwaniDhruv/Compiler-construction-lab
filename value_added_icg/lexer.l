%option noyywrap noinput nounput
%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
static char *copy_text(const char *s) {
    size_t n = strlen(s) + 1;
    char *p = malloc(n);
    if (!p) { perror("malloc"); exit(EXIT_FAILURE); }
    memcpy(p, s, n);
    return p;
}
%}
ID [A-Za-z_][A-Za-z0-9_]*
%%
{ID}                    { yylval.text = copy_text(yytext); return ID; }
[0-9]+                  { yylval.text = copy_text(yytext); return NUMBER; }
[ \t\r]+                { /* Ignore horizontal whitespace. */ }
\n                      { return '\n'; }
[=()+*/-]                { return yytext[0]; }
.                       { return yytext[0]; }
%%
