%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *message);
%}
%define parse.error verbose
%union { double number; }
%token <number> NUMBER
%type <number> expression
%left '+' '-'
%left '*' '/'
%right UMINUS
%%
input:
      %empty
    | input line
    ;
line:
      '\n'
    | expression '\n' { printf("= %.10g\n", $1); }
    | error '\n'      { puts("Invalid input; continuing with the next line."); yyerrok; }
    ;
expression:
      NUMBER                         { $$ = $1; }
    | expression '+' expression     { $$ = $1 + $3; }
    | expression '-' expression     { $$ = $1 - $3; }
    | expression '*' expression     { $$ = $1 * $3; }
    | expression '/' expression     {
          if ($3 == 0.0) { yyerror("division by zero"); $$ = 0.0; }
          else $$ = $1 / $3;
      }
    | '-' expression %prec UMINUS   { $$ = -$2; }
    | '(' expression ')'            { $$ = $2; }
    ;
%%
void yyerror(const char *message) { fprintf(stderr, "Parser: %s\n", message); }
int main(void) {
    puts("Desk calculator: one expression per line; Ctrl-D to finish.");
    return yyparse();
}
