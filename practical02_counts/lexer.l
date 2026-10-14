%option noyywrap noinput nounput
%{
#include <stdio.h>
static long comments = 0, keywords = 0, identifiers = 0, words = 0;
static long lines = 0, spaces = 0;
static int line_has_data = 0, saw_anything = 0;
%}
ID [A-Za-z_][A-Za-z0-9_]*
%x BLOCK LINE
%%
"/*"                    { ++comments; saw_anything = line_has_data = 1; BEGIN(BLOCK); }
<BLOCK>"*/"             { saw_anything = line_has_data = 1; BEGIN(INITIAL); }
"//"                    { ++comments; saw_anything = line_has_data = 1; BEGIN(LINE); }
<LINE>\n                 { ++lines; line_has_data = 0; saw_anything = 1; BEGIN(INITIAL); }
<BLOCK,LINE>\n           { ++lines; line_has_data = 0; saw_anything = 1; }
<BLOCK,LINE>[ \t]       { ++spaces; line_has_data = saw_anything = 1; }
<BLOCK,LINE>.            { line_has_data = saw_anything = 1; }
\n                      { ++lines; line_has_data = 0; saw_anything = 1; }
[ \t]                   { ++spaces; line_has_data = saw_anything = 1; }
"int"|"float"|"char"|"double"|"if"|"else"|"while"|"for"|"return"|"void" {
                          ++keywords; ++words; line_has_data = saw_anything = 1;
                        }
{ID}                    { ++identifiers; ++words; line_has_data = saw_anything = 1; }
.                       { line_has_data = saw_anything = 1; }
<<EOF>>                 {
                          if (line_has_data || (saw_anything && lines == 0)) ++lines;
                          return 0;
                        }
%%
int main(void) {
    yylex();
    printf("Comments:   %ld\nKeywords:   %ld\nIdentifiers:%ld\nWords:      %ld\nLines:      %ld\nSpaces/tabs:%ld\n",
           comments, keywords, identifiers, words, lines, spaces);
    return 0;
}
