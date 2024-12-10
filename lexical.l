%{
#include <string.h>
#include <stdio.h>
#include "syntaxique.tab.h"
extern YYSTYPE yylval;
int nbL=1;
int nbC=1;
int i;
%}

INTT "("[-+][0-9][0-9]*")"|[0-9][0-9]*
FLOATT "("[-+][1-9][0-9]*"."[0-9]*[0-9]")"|([0-9][0-9]*"."[0-9]*[0-9])
ERREUR1 [a-zA-Z]([a-zA-Z]|[0-9]|_){7,}
IDF [a-zA-Z]([a-zA-Z]|[0-9]|_){0,6}
COMMENTS "//".*
COMMENTC "/*"((\n)*[^/])*"*/"
PHRASE "'"[a-zA-Z :*+-/\?%&@!:;,_#$]+"'"

%%
PROGRAMME { nbC=nbC+strlen(yytext); return mc_prg; }
VAR { nbC=nbC+strlen(yytext); return mc_var; }
BEGIN { nbC=nbC+strlen(yytext); return mc_begin; }
END { nbC=nbC+strlen(yytext); return mc_end; }
INTEGER { nbC=nbC+strlen(yytext); return mc_int; }
FLOAT { nbC=nbC+strlen(yytext); return mc_float; }
CONST { nbC=nbC+strlen(yytext); return mc_cst; } 
ELSE { nbC=nbC+strlen(yytext); return mc_else; }
IF { nbC=nbC+strlen(yytext); return mc_if; }
WHILE { nbC=nbC+strlen(yytext); return mc_while; }
FOR { nbC=nbC+strlen(yytext); return mc_for; }
READLN { nbC=nbC+strlen(yytext); return mc_readln; }
WRITELN { nbC=nbC+strlen(yytext); return mc_writeln; }
"=" { nbC=nbC+strlen(yytext); return eg; }
";" { nbC=nbC+strlen(yytext); return pv; }
"," { nbC=nbC+strlen(yytext); return v; }
":" { nbC=nbC+strlen(yytext); return dp; }
"(" { nbC=nbC+strlen(yytext); return po; }
")" { nbC=nbC+strlen(yytext); return pf; }
"[" { nbC=nbC+strlen(yytext); return co; }
"]" { nbC=nbC+strlen(yytext); return cf; }
"+" { nbC=nbC+strlen(yytext); return plus; }
"-" { nbC=nbC+strlen(yytext); return moins; }
"*" { nbC=nbC+strlen(yytext); return mult; }
"/" { nbC=nbC+strlen(yytext); return divi; }
"&&" { nbC=nbC+strlen(yytext); return AND; }
"||" { nbC=nbC+strlen(yytext); return OR; }
"!"  { nbC=nbC+strlen(yytext); return NOT; }
">=" { nbC=nbC+strlen(yytext); return GE; }
"<=" { nbC=nbC+strlen(yytext); return LE; }
"==" { nbC=nbC+strlen(yytext); return EQ; }
"!=" { nbC=nbC+strlen(yytext); return NEQ; }
">"  { nbC=nbC+strlen(yytext); return sup; }
"<"  { nbC=nbC+strlen(yytext); return inf; }
"{" { nbC=nbC+strlen(yytext); return acco; }
"}" { nbC=nbC+strlen(yytext);return accf; }
"'" { nbC=nbC+strlen(yytext);return app; }

{ERREUR1} { nbC=nbC+strlen(yytext); 
        printf("\nErreur lexicale : caractere inattendu '%s' a la ligne %d colonne %d : Identifiant trop long\n",yytext,nbL,nbC);
        exit(1);
        }
{IDF} { nbC=nbC+strlen(yytext); return IDF; }
{INTT} { nbC=nbC+strlen(yytext); return INT; }
{FLOATT} { nbC=nbC+strlen(yytext); return FLOAT; }
{PHRASE} { nbC=nbC+strlen(yytext); return PHRASE; }
" " {nbC++;}
\n {nbL++; nbC=1;} 
{COMMENTS} { nbC=nbC+strlen(yytext); }
{COMMENTC} { for (i = 0; yytext[i] != '\0'; i++) {
                        if (yytext[i] == '\n') nbL++;
                    }
            nbC=nbC+strlen(yytext);        
                }
. {nbC=nbC+strlen(yytext);
     printf("\nErreur lexicale : caractere inattendu '%s' a la ligne %d colonne %d\n",yytext,nbL,nbC);     
     exit(1);
     }


%%

