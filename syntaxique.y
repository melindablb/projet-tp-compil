%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int nbL;
extern int nbC;
void yyerror(const char *s);
%}


%token mc_prg mc_var mc_begin mc_end mc_int mc_float mc_cst mc_if mc_else mc_for mc_while mc_readln mc_writeln eg pv v dp po pf co cf plus moins mult divi acco accf app
%token AND OR NOT GE LE EQ NEQ sup inf
%token IDF FLOAT INT PHRASE


%left OR
%left AND
%left EQ NEQ
%left inf sup GE LE
%left plus moins
%left mult divi
%left po dp
%nonassoc NOT

%%

programme:
    mc_prg IDF bloc_decla bloc_code 
    ;

bloc_decla:
    mc_var acco liste_decla accf
    | mc_var acco accf
    ;

liste_decla:
    declaration 
    | liste_decla declaration  
    ;

declaration:
    mc_int liste_var pv
    | mc_float liste_var pv
    | mc_cst liste_cst pv
    ;

liste_var:
    IDF
    | tab
    | liste_var v IDF
    | liste_var v tab
    ;

liste_cst:
    IDF eg INT
    | IDF eg FLOAT
    | liste_cst v IDF eg INT
    | liste_cst v IDF eg FLOAT
    ;

tab:
    IDF co INT cf 
    ;

bloc_code:
    mc_begin liste_instructions mc_end
    | mc_begin mc_end
    ; 

liste_instructions :
    instruction
    | liste_instructions instruction
    ;

instruction :
    affectation pv
    | condition
    | boucle
    | entree_sortie pv
    ;

affectation :
    IDF eg expression_a
    | IDF co expression_t cf eg expression_a
    ;

condition :
    mc_if po expression_cond pf acco liste_instructions accf
    | mc_if po expression_cond pf acco accf
    | mc_if po expression_cond pf acco liste_instructions accf mc_else acco liste_instructions accf
    | mc_if po expression_cond pf acco liste_instructions accf mc_else acco accf
    | mc_if po expression_cond pf acco accf mc_else acco liste_instructions accf
    | mc_if po expression_cond pf acco accf mc_else acco accf
    ;

boucle:
    mc_for po IDF dp INT dp INT dp expression_t pf acco liste_instructions accf
    | mc_for po IDF dp INT dp INT dp expression_t pf acco accf
    | mc_for po IDF dp INT dp INT dp IDF co expression_t cf pf acco liste_instructions accf
    | mc_for po IDF dp INT dp INT dp IDF co expression_t cf pf acco accf
    | mc_while po expression_cond pf acco liste_instructions accf
    | mc_while po expression_cond pf acco accf
    ;

entree_sortie:
    mc_readln po IDF pf 
    | mc_writeln po PHRASE pf
    | mc_writeln po PHRASE v listeIDF pf
    | mc_writeln po listeIDF v PHRASE pf
    | mc_writeln po listeIDF v PHRASE v listeIDF pf
    ;

listeIDF:
    listeIDF v IDF
    | IDF
    ;

expression_cond:
    expression_cond OR expression_cond
    | expression_cond AND expression_cond
    | po expression_cond OR expression_cond pf
    | po expression_cond AND expression_cond pf
    | expression_condprime
    ;


expression_condprime:
    | NOT expression_a 
    | expression_a inf expression_a
    | expression_a sup expression_a
    | expression_a GE expression_a
    | expression_a LE expression_a
    | expression_a EQ expression_a
    | expression_a NEQ expression_a
    | po NOT expression_a pf
    | po expression_a inf expression_a pf
    | po expression_a sup expression_a pf
    | po expression_a GE expression_a pf
    | po expression_a LE expression_a pf
    | po expression_a EQ expression_a pf
    | po expression_a NEQ expression_a pf
    | expression_a 
    ;

expression_a:
    expression_a plus expression_a
    | expression_a moins expression_a
    | expression_a mult expression_a
    | expression_a divi expression_a
    | IDF
    | INT
    | FLOAT
    | IDF co expression_t cf
    | po expression_a pf
    ;

expression_t:
    expression_t plus expression_t
    | expression_t moins expression_t
    | expression_t mult expression_t 
    | expression_t divi expression_t
    | IDF
    | INT
    ;
 
%%


void yyerror(const char *s) {
    fprintf(stderr, "\nErreur syntaxique a la ligne %d colonne %d : %s\n", nbL,nbC,s);
}


int main() {

    printf("\nDebut de l'analyse syntaxique...\n");
    if (yyparse() == 0) {
        printf("\nAnalyse syntaxique terminee avec succes.\n");
    } else {
        printf("\nAnalyse syntaxique echouee.\n");
    }
    return 0;
}

 