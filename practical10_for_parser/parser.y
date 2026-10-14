%{
#include <stdio.h>
int yylex(void);
void yyerror(const char *message);
%}
%define parse.error verbose
%token FOR ID NUMBER INC DEC LE GE EQ NE
%left '+' '-'
%left '*' '/'
%%
program:
      %empty
    | program for_loop { puts("Valid FOR loop"); }
    ;
for_loop:
      FOR '(' assignment ';' condition ';' update ')' block
    ;
assignment:
      ID '=' expression
    ;
update:
      ID '=' expression
    | ID INC
    | ID DEC
    | INC ID
    | DEC ID
    ;
condition:
      expression '<' expression
    | expression '>' expression
    | expression LE expression
    | expression GE expression
    | expression EQ expression
    | expression NE expression
    ;
block:
      '{' statements '}'
    ;
statements:
      %empty
    | statements assignment ';'
    ;
expression:
      ID
    | NUMBER
    | '(' expression ')'
    | expression '+' expression
    | expression '-' expression
    | expression '*' expression
    | expression '/' expression
    ;
%%
void yyerror(const char *message) { fprintf(stderr, "Syntax error: %s\n", message); }
int main(void) {
    puts("Enter a FOR loop, for example: for (i=0; i<5; i=i+1) { sum=sum+i; }");
    return yyparse();
}
