%option yylineno
%{
#include<stdio.h>
#include<stdlib.h>
#include "sin.tab.h"
#include <string.h>
#define yywrap() 1
extern int  yyparse();
extern FILE *yyout;
FILE *com;
//funcao que checa a extensao de um arquivo
//retorna true quando a extensao esta correta
int check_filename_ext(const char *filename, const char *ext) {
    int n = 0;
    const char *dot = strrchr(filename, '.');
    return (strcmp(dot,ext) == 0 ?  1 : 0);
    if(!dot || dot == filename) return 0;
}
%}
%%
"if" {fprintf(com,"COMANDO CONDICIONAL\n");return IF;}
"else" {fprintf(com,"COMANDO CASO CONTRARIO\n");return ELSE;}
"while" {fprintf(com,"COMANDO ENQUANTO\n");return WHILE;}
"for" {fprintf(com,"COMANDO LOOP\n");return FOR;}
"int" {fprintf(com,"DECLARA INT\n");return INT_TYPE;}
"real" {fprintf(com,"DECLARA REAL\n");return REAL_TYPE;}
"char" {fprintf(com,"DECLARA CHAR\n");return CHAR_TYPE;}
"print" {fprintf(com,"COMANDO SAIDA\n");return PRINT;}
"read" {fprintf(com,"COMANDO ENTRADA\n");return READ;}
"main" {fprintf(com,"INICIO PROGRAMA\n");return MAIN;}
[0-9]+ {yylval.str_val = (char *)malloc(sizeof(yytext));sprintf(yylval.str_val,"%s",yytext); return INT;}
[0-9]+"."[0-9]+ {yylval.str_val = (char *)malloc(sizeof(yytext));sprintf(yylval.str_val,"%s",yytext); return REAL;}
\'.\' {yylval.str_val = (char *)malloc(sizeof(yytext));sprintf(yylval.str_val,"%s",yytext); return CHAR;}
"+"|"/"|"*"|"-"|">"|"<"|"("|")"|";"|","|"="|"%"|"^" {return *yytext;}
"{" {fprintf(com,"INICIO BLOCO\n");return *yytext;}
"}" {fprintf(com,"FIM BLOCO\n");return *yytext;}
"==" {return EQ;}
">=" {return EMT;}
"<=" {return ELT;}
"!=" {return NE;}
"and" {return AND;}
"or" {return OR;}
"not" {return NOT;}
\".+\" {yylval.str_val = (char *)malloc(sizeof(yytext));sprintf(yylval.str_val,"%s",yytext);return STRING;}
[a-zA-Z][a-zA-Z0-9]* {yylval.str_val = (char *)malloc(sizeof(yytext));sprintf(yylval.str_val,"%s",yytext);return VAR;}
%%
int main(int argc, char *argv[]){
    FILE *yyin;
      if (argc == 3)
      {
          char *ext = ".di";
          if(!check_filename_ext(argv[1], ext)){
            printf("Extensao de arquivo de origem invalida.");
            return (-1);
          }
          if (!(yyin = fopen(argv[1], "r")))
          {
              perror("Falha ao abrir o arquivo origem: ");
              return (-1);
          }
          char *ext2 = ".c";
          if(!check_filename_ext(argv[2], ext2)){
            printf("Extensao de arquivo de destino invalida.");
            return (-1);
          }
          if (!(yyout = fopen(argv[2], "w+")))
          {
              perror("Falha ao criar o arquivo destino: ");
              return (-1);
          }
          if (!(com = fopen("comandos.txt", "w+")))
          {
              perror("Falha ao criar o arquivo de comandos: ");
          }
          YY_BUFFER_STATE buf = yy_create_buffer(yyin,YY_BUF_SIZE);
          yy_switch_to_buffer(buf);
          yyparse();
          yy_delete_buffer(buf);
          fclose(yyin);
          fclose(yyout);
          fclose(com);
      }
      else
          printf("Uso: compilador.exe [source.d] [destination.c]");
      return (0);
    }
