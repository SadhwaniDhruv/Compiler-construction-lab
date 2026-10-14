%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *message);
%}
%define parse.error verbose
%union { long number; }
%token <number> NUMBER
%type <number> expression
%left '+' '-'
%left '*' '/'
%left UMINUS
%%
input:
      %empty
    | input line
    ;
line:
      '\n'
    | expression '\n' { printf("= %ld\n", $1); }
    | error '\n'      { yyerrok; }
    ;
expression:
      NUMBER                    { $$ = $1; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression {
          if ($3 == 0) { yyerror("division by zero"); $$ = 0; }
          else $$ = $1 / $3;
      }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')'         { $$ = $2; }
    ;
%%
void yyerror(const char *message) { fprintf(stderr, "Parser: %s\n", message); }
int main(void) {
    puts("Enter one integer arithmetic expression per line; Ctrl-D to finish.");
    return yyparse();
}
