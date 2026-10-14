%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *message);
%}
%define parse.error verbose
%union { double number; }
%token <number> NUMBER
%type <number> expression
%%
input:
      %empty
    | input line
    ;
line:
      '\n'
    | expression '\n' { printf("= %.10g\n", $1); }
    | error '\n'      { yyerrok; }
    ;
expression:
      NUMBER                         { $$ = $1; }
    | expression expression '+'     { $$ = $1 + $2; }
    | expression expression '-'     { $$ = $1 - $2; }
    | expression expression '*'     { $$ = $1 * $2; }
    | expression expression '/'     {
          if ($2 == 0.0) { yyerror("division by zero"); $$ = 0.0; }
          else $$ = $1 / $2;
      }
    ;
%%
void yyerror(const char *message) { fprintf(stderr, "Parser: %s\n", message); }
int main(void) {
    puts("Postfix evaluator: enter one expression per line; Ctrl-D to finish.");
    return yyparse();
}
