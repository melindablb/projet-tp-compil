%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "quad.h"
extern int nbL;
extern int nbC;
int yylex(void);
void yyerror(const char *s);
int entier=-1,a,b,seuil,cptT=0;
float reel=-1,f,expT=0;
char s1[20],sauvtype[50]=" ",sauvt[20];
char tmp[50];
int deb_while=0,fin_while=0;
%}

%union{
char* str;
int integer;
float floatt;

}

%token MFLOAT MELSE MWHILE MIF MPROGRAMME MVAR MBEGIN MEND MFOR MINTEGER MCONST Mwriteln Mreadln plus moins mul Mdiv et ou egale diff supeg infeg sup inf parouvr parferm crochouvr crochferm accouvr accferm
aff virg deuxpoints chainecar pvg non point app
%token <str>idf <floatt>FLOAT <integer>INT

%type <str> expression_t T U MPROGRAMME expression_a EXPA1 EXPA2 liste_cst

%left ou
%left et
%left egale diff
%left inf sup supeg infeg
%left plus moins
%left mul Mdiv
%left parouvr deuxpoints
%nonassoc non

%start programme

%%

programme:
    MPROGRAMME idf bloc_decla bloc_code
    ;

bloc_decla:
    MVAR accouvr liste_decla accferm
    | MVAR accouvr accferm
    ;

liste_decla:
    declaration 
    | liste_decla declaration  
    ;

declaration:
    type liste_var pvg
    | typeC liste_cst pvg
    ;
type:
  MINTEGER {strcpy(sauvtype,"INTEGER");}
  | MFLOAT {strcpy(sauvtype,"FLOAT");}
  ;

typeC:
   MCONST {strcpy(sauvtype,"CONST");}
    ;

liste_var:
    idf {if (recherche1i($1)==1){
                                 type($1,sauvt);
                                 if (strcmp(sauvt,"")==0){
                                    update($1,"",sauvtype,"","",0,1);
                                 }
                                else{
                                     printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                                     YYABORT;
                                 }
          }
    }
    | tab
    | liste_var virg idf {if (recherche1i($3)==1){
                                 type($3,sauvt);
                                 if (strcmp(sauvt,"")==0){
                                    update($3,"",sauvtype,"","",0,1);
                                 }
                                else{
                                     printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                                     YYABORT;
                                 }
          }
    }
    | liste_var virg tab
    ;

liste_cst:
    idf aff INT   {if (recherche1i($1)==1){
                    type($1,sauvt);
                    if(strcmp(sauvt,"")==0){

                        update($1,"","INTEGER","","",0,1);
                        update($1,"CONST","","","",0,5);
                        char abc[20];
                        sprintf(abc,"%d",$3);
                        update($1,"","",abc,"",0,2);

                    }
                    }
                else{
                    printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                    YYABORT;
                    }
                }

    | idf aff FLOAT {if (recherche1i($1)==1){
                    type($1,sauvt);
                    if(strcmp(sauvt,"")==0){

                        update($1,"","FLOAT","","",0,1);
                        update($1,"CONST","","","",0,5);
                        char abc[20];
                        sprintf(abc,"%d",$3);
                        update($1,"","",abc,"",0,2);

                    }
                    }
                else{
                    printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                    YYABORT;
                    }
                }
    | liste_cst virg idf aff INT{if (recherche1i($3)==1){
                    type($3,sauvt);
                    if(strcmp(sauvt,"")==0){

                        update($3,"","INTEGER","","",0,1);
                        update($3,"CONST","","","",0,5);
                        char abc[20];
                        sprintf(abc,"%d",$5);
                        update($1,"","",abc,"",0,2);

                    }
                    }
                else{
                    printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                    YYABORT;
                    }
                }
    | liste_cst virg idf aff FLOAT {if (recherche1i($3)==1){
                    type($3,sauvt);
                    if(strcmp(sauvt,"")==0){

                        update($3,"","FLOAT","","",0,1);
                        update($3,"CONST","","","",0,5);
                        char abc[20];
                        sprintf(abc,"%d",$5);
                        update($1,"","",abc,"",0,2);

                    }
                    }
                else{
                    printf("\n --> Erreur semantique : double declaration la ligne %d a la colonne %d !\n", nbL, nbC);
                    YYABORT;
                    }
                }
    ;

tab:
    idf crochouvr INT crochferm {

      if(recherche1i($1)==1){ // existe dans ts
          type($1,sauvt);
          if(strcmp(sauvt,"")==0){ // declaration pour la premiere fois
            update($1,"","","","tab",1,3);
            sprintf(sauvt,"%d",$3);
            update($1,"","",sauvt,"",1,2);
            update($1,"",sauvtype,"","",1,1);
          }
          else{ //double declaration
            printf("Erreur Semantique a la ligne %d colonne %d : double declaration\n",nbL,nbC);
            YYABORT;
          }
      }
    }

    ;

bloc_code:
    MBEGIN liste_instructions MEND
    | MBEGIN MEND
    ; 

liste_instructions :
    instruction
    | liste_instructions instruction
    ;

instruction :
    affectation pvg
    | condition
    | boucle
    | entree_sortie pvg
    ;

affectation :
    idf aff expression_a {if (recherche1i($1)==1){ // entite existe
                                type($1,sauvt);

                                 if (strcmp(sauvt,"")==0){

                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;
                                 }
                                else{
                                   char d[20];
                                   code($1,d);
                                   if(strcmp(d,"CONST")==0){
                                     printf("\n --> Erreur semantique : idf %s est une constante la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;
                                       }
                                  }
                              }
                          }
    | idf crochouvr expression_t crochferm aff expression_a
    ;

condition :
    MIF parouvr liste_cond parferm accouvr liste_instructions accferm
    | MIF parouvr liste_cond parferm accouvr liste_instructions accferm MELSE accouvr liste_instructions accferm
    ;

boucle:
    MFOR parouvr idf deuxpoints INT deuxpoints INT deuxpoints expression_for parferm accouvr liste_instructions accferm
    | MFOR parouvr idf deuxpoints INT deuxpoints INT deuxpoints expression_for parferm accouvr accferm
    | MFOR parouvr idf deuxpoints INT deuxpoints INT deuxpoints idf crochouvr expression_for crochferm parferm accouvr liste_instructions accferm
    | deb1 accouvr liste_instructions accferm{
   char* var3;
   quad("BR","","vide","vide");
   sprintf(var3,"%d",qc);
   quad_updt(fin_while,2,var3);
   sprintf(var3,"%d",deb_while);
   quad("BR",var3,"","");
}
    ;

deb1:
    deb2 parouvr liste_cond parferm {
      quad("BZ","","tmp_cond","");
      fin_while=qc;
    }

deb2:
     MWHILE {
  deb_while=qc;
}

expression_for:
    expression_for plus EXPF1
    | expression_for moins EXPF1
    | EXPF1
    ;

EXPF1:
    EXPF1 mul EXPF2
    | EXPF1 Mdiv EXPF2
    | EXPF2
    ;

EXPF2:
    idf
    | INT
    ;


entree_sortie:
    Mreadln parouvr idf parferm {if (recherche1i($3)==1){ // entite existe
                                type($3,sauvt);

                                 if (strcmp(sauvt,"")==0){

                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$3, nbL, nbC);
                                     YYABORT;
                                 }
                              }
                          }
    | Mwriteln parouvr chainecar parferm
    | Mwriteln parouvr chainecar virg listeIDF parferm
    | Mwriteln parouvr listeIDF virg chainecar parferm
    | Mwriteln parouvr listeIDF virg chainecar virg listeIDF parferm
    ;

listeIDF:
    listeIDF virg idf{if (recherche1i($3)==1){ // entite existe
                                type($3,sauvt);

                                 if (strcmp(sauvt,"")==0){

                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$3, nbL, nbC);
                                     YYABORT;
                                 }
                              }
                          }
    | idf {if (recherche1i($1)==1){ // entite existe
                                type($1,sauvt);

                                 if (strcmp(sauvt,"")==0){

                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;
                                 }
                              }
                          }
    ;

liste_cond:     expression_cond op1 liste_cond
                    | parouvr expression_cond op2 expression_cond parferm op1 liste_cond
                    | expression_cond
                    ;

expression_cond:
    expression_a op2 expression_a
    ;

op1:
    et
    | ou
    | non
    ;

op2: infeg
    | inf
    | supeg
    | sup
    | egale
    | diff
    ;


expression_a:
    expression_a plus EXPA1{
          if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("+",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
            YYABORT;
           }
       }
    | expression_a moins EXPA1{
          if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("-",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
            YYABORT;
           }
       }
    | EXPA1
    ;

EXPA1:
    EXPA1 mul EXPA2{
          if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("*",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
       }
    | EXPA1 Mdiv EXPA2{ if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            if(strcmp($3,"0")==0){
              printf("Erreur semantique : division par 0 a la ligne %d colonne %d\n",nbL,nbC);
            YYABORT;}
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("/",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
       }
    | EXPA2
    ;

EXPA2:
    idf {if (recherche1i($1)==1){ // entite existe
                                type($1,sauvt);

                                 if (strcmp(sauvt,"")==0){

                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;
                                 }
                              }
                          }
    | INT
    | FLOAT
    | idf crochouvr expression_t crochferm
    | parouvr expression_a parferm
    ;


expression_t:
    expression_t plus T {
          if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("+",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
       }
    | expression_t moins T {
          if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("-",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
       }
    |T
;

T:
    T mul U { if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("*",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
           }

    | T Mdiv U { if(verift($1,"INTEGER")==1 && verift($3,"INTEGER")==1){
            if(strcmp($3,"0")==0){
              printf("Erreur semantique : division par 0 a la ligne %d colonne %d\n",nbL,nbC);
            YYABORT;}
            sprintf(tmp,"%d",cptT);
            cptT++;
            quad("/",$1,$3,tmp);
          }
          else{
            printf("Erreur semantique: incompatibilite de type a la ligne %d colonne %d",nbL,nbC);
           YYABORT;}
       }
    | U
    ;

U:
    idf {if (recherche1i($1)==1){ // entite existe
                                type($1,sauvt);
                                 if (strcmp(sauvt,"")==0){
                                     printf("\n --> Erreur semantique : idf %s non declare la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;
                                 }
                                 b=verift($1,"INTEGER");
                                 if(b!=1){
                                     printf("\n --> Erreur semantique : idf %s de type incompatible ( type attendu: entier)a la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                     YYABORT;}
                                     else {
                                       if(checkbit($1)==0){
                                           printf("\n --> Erreur semantique : idf %s n a pas de valeur , a la ligne %d a la colonne %d !\n",$1, nbL, nbC);
                                       YYABORT;}
                                       else {
                                         float valeurr=val($1,1,0);

                                       }
                                     }
                              }
                          }
    | INT
    | parouvr expression_t parferm
    ;
 
%%


void yyerror(const char *s) {
    fprintf(stderr, "\nErreur syntaxique a la ligne %d colonne %d : %s\n", nbL,nbC,s);
}

int main() {

    initialisation();

    printf("\nDebut de l'analyse syntaxique...\n");
    if (yyparse() == 0) {
        printf("\nAnalyse syntaxique terminee avec succes.\n");
    } else {
        printf("\nAnalyse syntaxique echouee.\n");
    }

    afficher();
    print_quad();
    return 0;
}

 