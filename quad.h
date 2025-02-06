#ifndef QUAD_H
#define QUAD_H

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
typedef struct qdr
{ char oper [100];
  char oprd1 [100];  
  char oprd2 [100] ;
  char rst [100];
}qdr;

 static qdr quadr[1000];

  int qc=0; //compteur de quad

//fonction de création des quad avec chaque champ définie
void quad (char oper[], char oprd1[], char oprd2[], char rst[]){
     
     strcpy (quadr[qc].oper,oper);
     strcpy (quadr[qc].oprd1,oprd1);
     strcpy(quadr[qc].oprd2,oprd2);
     strcpy(quadr[qc].rst,rst);

     qc++;
}
 //mise a jour d'un quad qui est définie par num-qdt et les columns sont les champs du quad en fonction de la column une valeur est attribuer à chaque champ
void quad_updt(int num_qdt, int column_qdt, char val[]){
    if (column_qdt==1){strcpy(quadr[num_qdt].oper,val);}//champ operation donc operation=val
    else if (column_qdt==2){strcpy(quadr[num_qdt].oprd1,val);}//champ opérande1 donc opérande1=val
        else if (column_qdt==3){strcpy(quadr[num_qdt].oprd2,val);}//champ opérande2 donc opérande2=val
            else if (column_qdt==4){strcpy(quadr[num_qdt].rst,val);}//champ resultat donc resultat=val

}
//affichage des quad en format "qc - (oper, oprd1, oprd2, rst)"
void print_quad (){
    printf("*********************Les Quadruplets***********************\n");
	int i;
	for(i=1;i<=qc;i++){
        printf(" %d - (%s , %s , %s , %s)",i,quadr[i].oper,quadr[i].oprd1,quadr[i].oprd2,quadr[i].rst);
        printf("\n--------------------------------------------------------\n");
    }
}

#endif



