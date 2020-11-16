%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sin.tab.h"
#define YYERROR_VERBOSE 1
extern FILE *yyout;
extern FILE *com;
extern int yylineno;
void yyerror(char const *s);
%}

%union{
  char *str_val;
}
%token<str_val> INT
%token<str_val> REAL
%token<str_val> CHAR
%token PRINT
%token IF
%token ELSE
%token WHILE
%token FOR
%token INT_TYPE
%token REAL_TYPE
%token CHAR_TYPE
%token<str_val> VAR
%token READ
%token<str_val> STRING
%token MAIN
%start main
%token '('
%token ')'
%token ';'
%token ','
%token '='
%left '+' '-'
%left '*' '/'
%left '%'
%left '<' '>' EQ NE EMT ELT
%left '^'
%left AND OR NOT
%type <str_val> exp print read dec_var atrib block while_st for_st if_st
%%

/* ---------------------------------- expressões ---------------------------------- */
exp : exp '+' exp    {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s+%s",$1,$3)}
    | exp '-'  exp   {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s-%s",$1,$3)}
    | exp '*'  exp   {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s*%s",$1,$3)}
    | exp '/'  exp   {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s/%s",$1,$3)}
    | exp'<' exp     {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s<%s",$1,$3)}
    | exp '>' exp    {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s>%s",$1,$3)}
    | exp '%' exp    {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s%c%s",$1,37,$3)}
    | exp EQ exp     {int len = strlen($1)+strlen($3)+2;$$ = malloc(len+1);sprintf($$,"%s==%s",$1,$3)}
    | exp NE exp     {int len = strlen($1)+strlen($3)+2;$$ = malloc(len+1);sprintf($$,"%s!=%s",$1,$3)}
    | exp EMT exp    {int len = strlen($1)+strlen($3)+2;$$ = malloc(len+1);sprintf($$,"%s>=%s",$1,$3)}
    | exp ELT exp    {int len = strlen($1)+strlen($3)+2;$$ = malloc(len+1);sprintf($$,"%s<=%s",$1,$3)}
    | exp AND exp    {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s&%s",$1,$3)}
    | exp OR exp     {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s|%s",$1,$3)}
    | NOT exp        {int len = strlen($2)+1;$$ = malloc(len+1);sprintf($$,"~%s",$2)}
    | '-' exp        {int len = strlen($2)+1;$$ = malloc(len+1);sprintf($$,"-%s",$2)}
    | '(' exp ')'    {int len = strlen($2)+2;$$ = malloc(len+1);sprintf($$,"(%s)",$2)}
    | exp '^' exp    {int len = strlen($1)+strlen($3)+22;$$ = malloc(len+1);sprintf($$,"pow((double)%s,(double)%s)",$1,$3)}
    | INT            {int len = strlen($1);$$ = malloc(len+1);sprintf($$,"%s",$1)}
    | REAL           {int len = strlen($1);$$ = malloc(len+1);sprintf($$,"%s",$1)}
    | CHAR           {int len = strlen($1)+6;$$ = malloc(len+1);sprintf($$,"(char)%s",$1)}
    | VAR            {int len = strlen($1);$$ = malloc(len+1);sprintf($$,"%s",$1)}
    ;


/* ---------------------------------- entrada/saida ---------------------------------- */
print : PRINT '(' VAR ')'    {int len = strlen($3)+7;$$ = malloc(len+1);sprintf($$,"print(%s)",$3);}
      | PRINT '(' exp ')'    {int len = strlen($3)+7;$$ = malloc(len+1);sprintf($$,"print(%s)",$3);}
      | PRINT '(' STRING ')'    {int len = strlen($3)+7;$$ = malloc(len+1);sprintf($$,"print(%s)",$3);}
      ;
read  : READ '(' VAR ')'     {int len = strlen($3)+6;$$ = malloc(len+1);sprintf($$,"read(%s)",$3);}

/* ---------------------------------- declaração/atribuição ---------------------------------- */
dec_var : INT_TYPE VAR           {int len = strlen($2)+4;$$ = malloc(len+1);sprintf($$,"int %s",$2);}
        | INT_TYPE VAR '=' exp   {int len = strlen($2)+strlen($4)+5;$$ = malloc(len+1);sprintf($$,"int %s=%s",$2,$4);}
        | REAL_TYPE VAR          {int len = strlen($2)+7;$$ = malloc(len+1);sprintf($$,"double %s",$2);}
        | REAL_TYPE VAR '=' exp  {int len = strlen($2)+strlen($4)+7;$$ = malloc(len+1);sprintf($$,"float %s=%s",$2,$4);}
        | CHAR_TYPE VAR          {int len = strlen($2)+5;$$ = malloc(len+1);sprintf($$,"char %s",$2);}
        | CHAR_TYPE VAR '=' exp  {int len = strlen($2)+strlen($4)+6;$$ = malloc(len+1);sprintf($$,"char %s=%s",$2,$4);}
        ;
atrib : VAR '=' exp {int len = strlen($1)+strlen($3)+1;$$ = malloc(len+1);sprintf($$,"%s=%s",$1,$3);}


/* ---------------------------------- bloco de instruções ---------------------------------- */
block : block block   {int len = strlen($1)+strlen($2);$$ = malloc(len+1);sprintf($$,"%s%s",$1,$2)}
      | if_st         {int len = strlen($1)+1;$$ = malloc(len+1);sprintf($$,"%s\n",$1);}
      | for_st        {int len = strlen($1)+1;$$ = malloc(len+1);sprintf($$,"%s\n",$1);}
      | while_st      {int len = strlen($1)+1;$$ = malloc(len+1);sprintf($$,"%s\n",$1);}
      | print ';'     {int len = strlen($1)+2;$$ = malloc(len+1);sprintf($$,"%s;\n",$1);}
      | dec_var ';'   {int len = strlen($1)+2;$$ = malloc(len+1);sprintf($$,"%s;\n",$1);}
      | read ';'      {int len = strlen($1)+2;$$ = malloc(len+1);sprintf($$,"%s;\n",$1);}
      | atrib ';'     {int len = strlen($1)+2;$$ = malloc(len+1);sprintf($$,"%s;\n",$1);}

      ;

/* ---------------------------------- comandos ---------------------------------- */
while_st : WHILE '(' exp ')' '{' block '}' {int len = strlen($3)+strlen($6)+10;$$ = malloc(len+1);sprintf($$,"while(%s){\n%s}",$3,$6);}
for_st : FOR '(' atrib ';' exp ';' atrib ')' '{' block '}' {int len = strlen($3)+strlen($5)+strlen($7)+strlen($10)+10;$$ = malloc(len+1);sprintf($$,"for(%s;%s;%s){\n%s}",$3,$5,$7,$10);}
if_st : IF '(' exp ')' '{' block '}' {int len = strlen($3)+strlen($6)+7;$$ = malloc(len+1);sprintf($$,"if(%s){\n%s}",$3,$6);fprintf(com,"COMANDO CONDICIONAL\n");}
      | IF '(' exp ')' '{' block '}' ELSE '{' block '}' {int len = strlen($3)+strlen($6)+strlen($10)+15;$$ = malloc(len+1);sprintf($$,"if(%s){\n%s\n}else{\n%s}",$3,$6,$10);}


/* ---------------------------------- função main ---------------------------------- */
main : MAIN '{' block '}' {fseek(yyout, 0, SEEK_SET);fprintf(yyout,"\
#include <stdio.h>\n\
#include <stdlib.h>\n\
#include <math.h> \n\
#define print(x) printf(_Generic(x, signed: \"%cd\", double: \"%clf\", char:\"%cc\", char*:\"%cs\"), x)\n\
#define read(x) scanf(_Generic(x, signed: \"%cd\", double: \"%clf\", char:\"%cc\"), &x)\n\
void main(int argc, char **argv){\n%s}",37,37,37,37,37,37,37,$3)}
%%

/* ---------------------------------- erro  ---------------------------------- */
void yyerror (char const *s) {
   fprintf(stderr,"%s at line %d",s,yylineno);
 }
