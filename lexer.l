%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// #include "y.tab.h" 

// تعريف الرموز
#define ID 1
#define INT 2
#define STR 3
#define AND 4
#define PBEGIN 5
#define FORWARD 6
#define DIV 7
#define DO 8
#define ELSE 9
#define END 10
#define FOR 11
#define FUNCTION 12
#define IF 13
#define ARRAY 14
#define MOD 15
#define NOT 16
#define OF 17
#define OR 18
#define PROCEDURE 19
#define PROGRAM 20
#define RECORD 21
#define THEN 22
#define TO 23
#define TYPE 24
#define VAR 25
#define WHILE 26
#define PLUS 27
#define MINUS 28
#define MULT 29
#define ASSIGN 30
#define EQUAL 31
#define LESS 32
#define LESSEQUAL 33
#define GREATER 34
#define GREATEREQUAL 35
#define NOTEQUAL 36
#define DOT 37
#define COMMA 38
#define COLON 39
#define SEMICOLON 40
#define DOTDOT 41
#define LPAREN 42
#define RPAREN 43
#define LBRACKET 44
#define RBRACKET 45

void print_token(int token, const char *value);

/* بداية كود جدول الرموز (Symbol Table) */

// عدد الرموز الأقصى
#define MAX_SYMBOLS 1000
// طول اسم الرمز الأقصى
#define MAX_SYMBOL_LENGTH 100

// هيكل جدول الرموز
typedef struct {
    char name[MAX_SYMBOL_LENGTH]; // اسم الرمز
    int token;                   // نوع الرمز
    int line;                    // رقم السطر
    int scope;                   // نطاق الرمز
} Symbol;

// تعريف جدول الرموز والمتغيرات
Symbol symbol_table[MAX_SYMBOLS]; // جدول الرموز
int symbol_count = 0;              // عدد الرموز الحالية
int current_scope = 0;             // نطاق الحالي
char id_text[MAX_SYMBOL_LENGTH];    // نص المعرف

// دوال جدول الرموز
int lookup_symbol(const char *name);
int insert_symbol(const char *name, int token, int line, int scope);
void register_keyword(const char *name, int token);
void print_symbol_table();
void enter_scope();
void exit_scope();

// دالة البحث عن الرمز
int lookup_symbol(const char *name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i].name, name) == 0 &&
            symbol_table[i].scope <= current_scope) {
            return i; // الرمز موجود
        }
    }
    return -1; // الرمز غير موجود
}

// دالة إدخال رمز جديد
int insert_symbol(const char *name, int token, int line, int scope) {
    if (symbol_count >= MAX_SYMBOLS) {
        fprintf(stderr, "Error: Symbol table full\n");
        return -1; // جدول الرموز ممتلئ
    }

    // إضافة الرمز إلى جدول الرموز
    strcpy(symbol_table[symbol_count].name, name);
    symbol_table[symbol_count].token = token;
    symbol_table[symbol_count].line = line;
    symbol_table[symbol_count].scope = scope;

    return symbol_count++; // زيادة عدد الرموز
}

// دالة تسجيل الكلمات المحجوزة
void register_keyword(const char *name, int token) {
    if (lookup_symbol(name) == -1) {
        insert_symbol(name, token, yylineno, current_scope);
    }
}

// دالة طباعة جدول الرموز
void print_symbol_table() {
    printf("\n===== SYMBOL TABLE =====\n");
    printf("%-20s %-10s %-10s %-10s\n", "NAME", "TOKEN", "LINE", "SCOPE");
    printf("----------------------------------------\n");

    for (int i = 0; i < symbol_count; i++) {
        printf("%-20s %-10s %-10d %-10d\n",
               symbol_table[i].name,
               symbol_table[i].token == ID ? "ID" : "KEYWORD",
               symbol_table[i].line,
               symbol_table[i].scope);
    }

    printf("========================\n");
}

// دالة دخول نطاق جديد
void enter_scope() {
    current_scope++;
}

// دالة الخروج من النطاق الحالي
void exit_scope() {
    if (current_scope > 0) {
        current_scope--;
    }
}
/* نهاية كود جدول الرموز (Symbol Table) */
%}

// تعريف الأنماط (Lex patterns)
DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT}|_)*
INT      {DIGIT}+
STR      \"[^"]*\"
WS       [ \t\n]+
COMMENT  "{"[^*]"}"

// قواعد التحليل
%%
{WS}                   { 
                         for(int i = 0; i < yyleng; i++) {
                             if(yytext[i] == '\n') yylineno++;
                         }
                       }

{COMMENT}              {
                         for(int i = 0; i < yyleng; i++) {
                             if(yytext[i] == '\n') yylineno++;
                         }
                       }

"and"                  { return AND; }
"begin"                { enter_scope(); return PBEGIN; }
"forward"              { return FORWARD; }
"div"                  { return DIV; }
"do"                   { return DO; }
"else"                 { return ELSE; }
"end"                  { exit_scope(); return END; }
"for"                  { return FOR; }
"function"             { return FUNCTION; }
"if"                   { return IF; }
"array"                { return ARRAY; }
"mod"                  { return MOD; }
"not"                  { return NOT; }
"of"                   { return OF; }
"or"                   { return OR; }
"procedure"            { return PROCEDURE; }
"program"              { return PROGRAM; }
"record"               { return RECORD; }
"then"                 { return THEN; }
"to"                   { return TO; }
"type"                 { return TYPE; }
"var"                  { return VAR; }
"while"                { return WHILE; }

"+"                    { return PLUS; }
"-"                    { return MINUS; }
"*"                    { return MULT; }
":="                   { return ASSIGN; }
"="                    { return EQUAL; }
"<"                    { return LESS; }
"<="                   { return LESSEQUAL; }
">"                    { return GREATER; }
">="                   { return GREATEREQUAL; }
"<>"                   { return NOTEQUAL; }
"."                    { return DOT; }
","                    { return COMMA; }
":"                    { return COLON; }
";"                    { return SEMICOLON; }
".."                   { return DOTDOT; }
"("                    { return LPAREN; }
")"                    { return RPAREN; }
"["                    { return LBRACKET; }
"]"                    { return RBRACKET; }

{ID}                   { 
                         int index = lookup_symbol(yytext);
                         if (index == -1) {
                             insert_symbol(yytext, ID, yylineno, current_scope);
                         }
                         strncpy(id_text, yytext, MAX_SYMBOL_LENGTH);
                         return ID; 
                       }

{INT}                  { return INT; }

{STR}                  { return STR; }

.                      { fprintf(stderr, "Unknown character: %s at line %d\n", yytext, yylineno); }

// نهاية قسم الليكس %%
%%

// دوال جدول الرموز
int lookup_symbol(const char *name);
int insert_symbol(const char *name, int token, int line, int scope);
void print_symbol_table();

// دالة لطباعة الرموز
void print_token(int token, const char *value) {
    switch (token) {
        case ID: printf("ID: %s\n", value); break;
        case INT: printf("INT: %s\n", value); break;
        case STR: printf("STR: %s\n", value); break;
        case AND: printf("AND\n"); break;
        case PBEGIN: printf("BEGIN\n"); break;
        case FORWARD: printf("FORWARD\n"); break;
        case DIV: printf("DIV\n"); break;
        case DO: printf("DO\n"); break;
        case ELSE: printf("ELSE\n"); break;
        case END: printf("END\n"); break;
        case FOR: printf("FOR\n"); break;
        case FUNCTION: printf("FUNCTION\n"); break;
        case IF: printf("IF\n"); break;
        case ARRAY: printf("ARRAY\n"); break;
        case MOD: printf("MOD\n"); break;
        case NOT: printf("NOT\n"); break;
        case OF: printf("OF\n"); break;
        case OR: printf("OR\n"); break;
        case PROCEDURE: printf("PROCEDURE\n"); break;
        case PROGRAM: printf("PROGRAM\n"); break;
        case RECORD: printf("RECORD\n"); break;
        case THEN: printf("THEN\n"); break;
        case TO: printf("TO\n"); break;
        case TYPE: printf("TYPE\n"); break;
        case VAR: printf("VAR\n"); break;
        case WHILE: printf("WHILE\n"); break;
        case PLUS: printf("PLUS\n"); break;
        case MINUS: printf("MINUS\n"); break;
        case MULT: printf("MULT\n"); break;
        case ASSIGN: printf("ASSIGN\n"); break;
        case EQUAL: printf("EQUAL\n"); break;
        case LESS: printf("LESS\n"); break;
        case LESSEQUAL: printf("LESSEQUAL\n"); break;
        case GREATER: printf("GREATER\n"); break;
        case GREATEREQUAL: printf("GREATEREQUAL\n"); break;
        case NOTEQUAL: printf("NOTEQUAL\n"); break;
        case DOT: printf("DOT\n"); break;
        case COMMA: printf("COMMA\n"); break;
        case COLON: printf("COLON\n"); break;
        case SEMICOLON: printf("SEMICOLON\n"); break;
        case DOTDOT: printf("DOTDOT\n"); break;
        case LPAREN: printf("LPAREN\n"); break;
        case RPAREN: printf("RPAREN\n"); break;
        case LBRACKET: printf("LBRACKET\n"); break;
        case RBRACKET: printf("RBRACKET\n"); break;
        default: printf("Unknown token\n");
    }
}

// دالة الرئيسية
int main() {
    int token;
    while ((token = yylex()) != 0){
        print_token(token, yytext);
    }

    print_symbol_table(); // طباعة جدول الرموز
    return 0;
}
