%{
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "TS.h"
#include "syntaxique.tab.h"
extern YYSTYPE yylval;
int nbL=1;
int nbC=1;
int i;

%}

INTT "("[-+][0-9][0-9]*")"|[0-9][0-9]*
FLOATT "("[-+][0-9][0-9]*"."[0-9]*[0-9]")"|([0-9][0-9]*"."[0-9]*[0-9])
IDF [a-zA-Z]([a-zA-Z]|[0-9]|_){0,6}
COMMENTS "//".*
COMMENTC "/*"([^*]*("*"+[^*/])*)*"*"+"/"
PHRASE "'".+"'"

%%
PROGRAMME { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_prg","",NAN,2);
  return MPROGRAMME; }

VAR { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_var","",NAN,2);
  return MVAR; }

BEGIN { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_begin","",NAN,2);
  return MBEGIN; }

END { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_end","",NAN,2);
  return MEND; }

INTEGER { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_int","",NAN,2);
  return MINTEGER; }

FLOAT { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_float","",NAN,2);
  return MFLOAT; }

CONST { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_cst","",NAN,2);
  return MCONST; }

ELSE { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_else","",NAN,2);
  return MELSE; }

IF { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_if","",NAN,2);
  return MIF; }

WHILE { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_while","",NAN,2);
  return MWHILE; }

FOR { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_for","",NAN,2);
  return MFOR; }

READLN { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_readln","",NAN,2);
  return Mreadln; }

WRITELN { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,2)==NULL)
  inserer(yytext,"mc_writeln","",NAN,2);
  return Mwriteln; }

"=" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"eg","",NAN,3);
  return aff; }

";" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"pv","",NAN,3);
  return pvg; }

"," { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"v","",NAN,3);
  return virg; }

":" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"dp","",NAN,3);
  return deuxpoints; }

"(" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"po","",NAN,3);
  return parouvr; }

")" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"pf","",NAN,3);
  return parferm; }

"[" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"co","",NAN,3);
  return crochouvr; }

"]" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"cf","",NAN,3);
  return crochferm; }

"+" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"plus","",NAN,3);
  return plus; }

"-" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"moins","",NAN,3);
  return moins; }

"*" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"mult","",NAN,3);
  return mul; }

"/" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"divi","",NAN,3);
  return Mdiv; }

"&&" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"AND","",NAN,3);
  return et; }

"||" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"OR","",NAN,3);
  return ou; }

"!=" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"NEQ","",NAN,3);
  return diff; }

"!"  { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"NOT","",NAN,3);
  return non; }

">=" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"GE","",NAN,3);
  return supeg; }

"<=" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"LE","",NAN,3);
  return infeg; }

"==" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"EQ","",NAN,3);
  return egale; }



">"  { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"sup","",NAN,3);
  return sup; }

"<"  { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"inf","",NAN,3);
  return inf; }

"{" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"acco","",NAN,3);
  return accouvr; }

"}" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"accf","",NAN,3);
  return accferm; }

"'" { nbC=nbC+strlen(yytext);
  if(recherche2(yytext,"","",NAN,3)==NULL)
  inserer(yytext,"app","",NAN,3);
  return app; }


{IDF} { nbC=nbC+strlen(yytext); 
        if(strlen(yytext)>=8)
                printf("\nErreur lexicale : caractere inattendu '%s' a la ligne %d colonne %d : Identifiant trop long\n",yytext,nbL,nbC);
        else{
                if(recherche1(yytext)==NULL)
                inserer(yytext,"IDF","",0,1);
                yylval.str = strdup(yytext);
                return idf;
                }
        }
{INTT} { nbC=nbC+strlen(yytext);
        int v=atoi(yytext);
        if(v>=-32768 && v<=32767){
          yylval.integer = atoi(yytext);
          return INT;
          }
        else
          printf("\nErreur lexicale : caractere inattendu '%s' a la ligne %d colonne %d : la valeur d un entier doit etre comprise entre -32768 et 32767.\n",yytext,nbL,nbC);
}
{FLOATT} { nbC=nbC+strlen(yytext); return FLOAT; }
{PHRASE} { nbC=nbC+strlen(yytext); return chainecar; }
" " {nbC++;}
\n {nbL++; nbC=1;} 
{COMMENTS} { nbC=nbC+strlen(yytext); }
{COMMENTC} { for (i = 0; yytext[i] != '\0'; i++) {
                        if (yytext[i] == '\n') nbL++;
                    }
            nbC=nbC+strlen(yytext);        
                }
. {nbC=nbC+strlen(yytext);
     printf("\nErreur lexicale : caractere inattendu '%s' a la ligne %d colonne %d.\n",yytext,nbL,nbC);
     }


%%
