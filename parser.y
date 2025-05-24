%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

extern int yylex();
extern int yyparse();
extern FILE *yyin;
extern char *yytext;
extern int yylineno;

void yyerror(const char *s);
%}

%token ID INT STR
%token AND PBEGIN FORWARD DIV DO ELSE END FOR FUNCTION IF ARRAY
%token MOD NOT OF OR PROCEDURE PROGRAM RECORD THEN TO TYPE VAR WHILE
%token PLUS MINUS MULT ASSIGN EQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token NOTEQUAL DOT COMMA COLON SEMICOLON DOTDOT LPAREN RPAREN LBRACKET RBRACKET

%left PLUS MINUS
%left MULT DIV MOD

%%

program
    : PROGRAM ID LPAREN identifier_list RPAREN SEMICOLON block DOT
    {
        printf("Recognized program declaration\n");
    }
    ;

identifier_list
    : ID
    {
        printf("Recognized identifier: %s\n", yytext);
    }
    | identifier_list COMMA ID
    {
        printf("Recognized identifier list with: %s\n", yytext);
    }
    ;

block
    : PBEGIN statements END
    {
        printf("Recognized block\n");
    }
    ;

statements
    : statement
    {
        printf("Recognized statement\n");
    }
    | statements SEMICOLON statement
    {
        printf("Recognized multiple statements\n");
    }
    ;

statement
    : assignment
    | if_statement
    ;

assignment
    : ID ASSIGN expr
    {
        printf("Recognized assignment statement\n");
    }
    ;

if_statement
    : IF expr THEN statement
    {
        printf("Recognized if statement\n");
    }
    ;

expr
    : expr PLUS expr
    {
        printf("Recognized addition expression\n");
    }
    | expr MINUS expr
    {
        printf("Recognized subtraction expression\n");
    }
    | expr GREATER expr
    {
        printf("Recognized greater-than expression\n");
    }
    | expr LESS expr
    {
        printf("Recognized less-than expression\n");
    }
    | expr GREATEREQUAL expr
    {
        printf("Recognized greater-or-equal expression\n");
    }
    | expr LESSEQUAL expr
    {
        printf("Recognized less-or-equal expression\n");
    }
    | expr EQUAL expr
    {
        printf("Recognized equal expression\n");
    }
    | expr NOTEQUAL expr
    {
        printf("Recognized not-equal expression\n");
    }
    | ID
    {
        printf("Recognized identifier in expression\n");
    }
    | INT
    {
        printf("Recognized integer in expression\n");
    }
    ;

%%

void yyerror(const char *s) {
    
}

int main(int argc, char *argv[]) {
   
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (!file) {
            fprintf(stderr, "Cannot open file %s\n", argv[1]);
            return 1;
        }
        yyin = file;
    }
    
    printf("Starting parser...\n");
    yyparse();
    
    printf("Parsing complete.\n");
    return 0;
}
