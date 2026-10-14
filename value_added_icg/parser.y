%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int yylex(void);
void yyerror(const char *message);
static unsigned temporary_count = 0;
static char *make_temp(void) {
    char buffer[32];
    snprintf(buffer, sizeof buffer, "t%u", ++temporary_count);
    char *name = malloc(strlen(buffer) + 1);
    if (!name) { perror("malloc"); exit(EXIT_FAILURE); }
    strcpy(name, buffer);
    return name;
}
static char *emit_binary(char *left, char operation, char *right) {
    char *result = make_temp();
    printf("%s = %s %c %s\n", result, left, operation, right);
    return result;
}
%}
%define parse.error verbose
%union { char *text; }
%token <text> ID NUMBER
%type <text> expression
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
    | ID '=' expression '\n' {
          printf("%s = %s\n", $1, $3);
          puts("---");
      }
    | error '\n' { yyerrok; }
    ;
expression:
      ID                            { $$ = $1; }
    | NUMBER                        { $$ = $1; }
    | expression '+' expression    { $$ = emit_binary($1, '+', $3); }
    | expression '-' expression    { $$ = emit_binary($1, '-', $3); }
    | expression '*' expression    { $$ = emit_binary($1, '*', $3); }
    | expression '/' expression    { $$ = emit_binary($1, '/', $3); }
    | '-' expression %prec UMINUS  {
          $$ = make_temp();
          printf("%s = -%s\n", $$, $2);
      }
    | '(' expression ')'           { $$ = $2; }
    ;
%%
void yyerror(const char *message) { fprintf(stderr, "Parser: %s\n", message); }
int main(void) {
    puts("Enter assignments such as result = (a + b) * 3; Ctrl-D to finish.");
    return yyparse();
}
