//
// Created by HP on 24.12.2024.
//

#ifndef TS_H
#define TS_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

typedef struct{
    char nom[20];
    char code[20];
    char type[20];
    float val;
    char tab[20];
    int indice;
    char bitaff[1]; //1 = une val a ete affecte 0= aucune val n a ete affecte
}constvar;

typedef struct{
    char nom[20];
    char code[20];
}mcsep;

typedef struct liste1* TS1;
typedef struct liste1{
  constvar val;
  TS1 suiv;
}nodeliste1;

typedef struct liste2* TS2;
typedef struct liste2{
  mcsep val;
  TS2 suiv;
}nodeliste2;

static TS1 T1=NULL;
static TS2 T2=NULL, T3=NULL;

//fonction pour liberer tout l espace occupe par une liste

  void free_liste(int c){

    switch(c){
      case 1: {
        // vider liste T1
        TS1 P1=T1;
        while(P1!=NULL){
          T1=T1->suiv;
          free(P1);
          P1=T1;
        }
        T1=NULL;
      }break;

      case 2: {
        //vider liste T2
        TS2 P2;
        P2=T2;
        while(P2!=NULL){
          T2=T2->suiv;
          free(P2);
          P2=T2;
        }
        T2=NULL;
      }break;

      case 3: {
        //vider liste T3
        TS2 P3;
        P3=T3;
        while(P3!=NULL){
          T3=T3->suiv;
          free(P3);
          P3=T3;
        }
        T3=NULL;
      }break;
    }
}



// fonction d initialisation

  void initialisation(){

    free_liste(1);
    free_liste(2);
    free_liste(3);

}

// fonction d insertion

  void inserer(char entite[],char code[],char type[],float val,int numt) {
  switch(numt){
    case 1: {
      //insertion table 1
      TS1 P1; // P = le nouvel element a inserer
      P1=malloc(sizeof(nodeliste1));
      strcpy(P1->val.nom,entite);
      strcpy(P1->val.code,code);
      strcpy(P1->val.type,type);
      strcpy(P1->val.bitaff,"0");
      P1->val.val=val;
      P1->suiv=NULL;
      if(T1==NULL)
        T1=P1;
      else{
        TS1 Q=T1;
        while(Q->suiv!=NULL){
          Q=Q->suiv;
        }
        //Q = dernier element de la liste
        Q->suiv=P1;
      }
      break;
    }
    case 2: {
      // insertion table 2
      TS2 P2;
      P2=malloc(sizeof(nodeliste2));
      strcpy(P2->val.nom,entite);
      strcpy(P2->val.code,code);
      P2->suiv=NULL;
      if(T2==NULL)
        T2=P2;
      else {
        TS2 Q=T2;
        while(Q->suiv!=NULL){
          Q=Q->suiv;
        }
        Q->suiv=P2;
      }
      break;
      }
      case 3: {
      // insertion table 3
      TS2 P3;
      P3=malloc(sizeof(nodeliste2));
      strcpy(P3->val.nom,entite);
      strcpy(P3->val.code,code);
      P3->suiv=NULL;
      if(T3==NULL)
        T3=P3;
      else{
        TS2 Q=T3;
        while(Q->suiv!=NULL){
          Q=Q->suiv;
        }
        Q->suiv=P3;
      }
      break;
    }
    }
    printf("L'entite %s vient d'etre inserer dans la table %d.\n",entite,numt);
  }

  // fonction de recherche dans table des idf

    TS1 recherche1(char entite[]){
    int b=0;

        //recherche dans table des const et var
        TS1 P1=T1;
        b=0;
        while(P1 != NULL && b!=1){
          if(strcmp((P1->val.nom),entite)==0)
            b=1;
          else
            P1=P1->suiv;
        }

    if(b==1) // l entite existe
      return P1;
    else //l entite n existe pas
      return NULL;
  }

// recherche version int
  int recherche1i(char entite[]){
    if(recherche1(entite)==NULL)
      return 0; // n existe pas
    else
      return 1; // existe
  }

// recherche dans table des mc ou sep

  TS2 recherche2(char entite[],char code[],char type[],float val, int numt){
    int b=0;
    TS2 P2=T2;
    TS2 P3=T3;
    switch(numt){
      case 2: {
        //recherche dans table des mots cle
        b=0;
        while(P2 != NULL && b!=1){
          if(strcmp((P2->val.nom),entite)==0)
            b=1;
          else
            P2=P2->suiv;
        }
        break;
      }
      case 3: {
        //recherche dans la table des separateurs
        b=0;
        while(P3 != NULL && b!=1){
          if(strcmp((P3->val.nom),entite)==0)
            b=1;
          else
            P3=P3->suiv;
        }
        break;
      }
    }
    if(b==1) // l entite existe
      switch (numt) {
        case 2: {
          return P2;
          break;
        }
        case 3: {
          return P3;
          break;
        }
      }
    else //l entite n existe pas
      return NULL;

  }
  // recherche2 version int
  int recherche2i(char entite[],char code[],char type[],float val, int numt){
    if(recherche2(entite,code,type,val,numt)==NULL)
      return 0; //n existe pas
    else
      return 1; // existe
  }


  // recherche d un element d un tab
  TS1 rechercheT(char entite[],int i) {
    TS1 P1=T1;
    int b=0;
    while (P1 != NULL && b!=1) { // recherche de l elm dont l indice est i
      if (strcmp((P1->val.nom),entite)==0 && P1->val.indice==i)
        b=1;
      else
        P1=P1->suiv;
    }
    if(b==1) //elm trouve
      return P1;
    else
      return NULL;
  }
// rechercheT version int

  int rechercheTi(char entite[],int i) {
    if(rechercheT(entite,i)==NULL)
      return 0; // n existe pas
    else
      return 1; // existe
  }

 //retourne la taille d un tab
int taille(char entite[]) {
    TS1 P1=T1;
    int b=0;
    while (P1 != NULL && b!=1) {
      if(strcmp((P1->val.nom),entite)==0)
        b=1;
      else
        P1=P1->suiv;
    }
  if (P1==NULL)
    return -1;
  else
    return ((int)P1->val.val);
  }



  // inserer elm tab
  void insererT(char entite[],float val,int i) {
    TS1 P1,PTAB;
    P1=malloc(sizeof(nodeliste1));

    PTAB=recherche1(entite); // recherche du tab

    //creation de l elm a inserer
    strcpy(P1->val.nom,entite);
    strcpy(P1->val.code,PTAB->val.code);
    strcpy(P1->val.code,PTAB->val.code);
    P1->val.val=val;
    strcpy(P1->val.tab,"elm");
    P1->val.indice=i;
    P1->suiv=NULL;

    TS1 P2=T1;
    while (P2->suiv!=NULL) {
      P2=P2->suiv;
    }
    //P2 = dernier elm de T1

    //ajout de l elm a la fin
    P2->suiv=P1;

  }


  // fonction de mise a jour idf

 int update(char entite[],char code[],char type[],char vale[],char tab[],int i,int opt){
    TS1 P1;
    float f;
    P1=recherche1(entite); // recherche de l entite
    switch(opt){
      case 1: {
        //maj du type
        strcpy(P1->val.type,type);
        return 1; //fait
        break;
      }
      case 2: {
        //maj valeur
        f=atof(vale);
        P1->val.val=f;
        strcpy(P1->val.bitaff,"1");
        return 1;
        break;
      }
      case 3: {
        // cas type tab
        strcpy(P1->val.tab,tab);
        P1->val.indice=-1;
        return 1;
        break;
      }
      case 4: {
        // maj val elm tab
        f=atof(vale);
        P1=rechercheT(entite,i);
        P1->val.val=f;
        return 1;
        break;
      }
      case 5:{
        //maj code
        strcpy(P1->val.code,code);
        return 1;
        break;
      }
    }
    return -1; //erreur
  }


  // fonction d affichage

    void afficher(){
    TS1 P1=T1;
    ///////////////////// affichage de la premiere table
    printf("\n***************Table des symboles IDF*******************");
    printf("\n-------------------------------------------------------------------------------------------------------\n");
    printf("|    Nom    |      Code    |    Type      |    Valeur       |      Tab     |     Indice  |  bit decla  |\n");
    printf("---------------------------------------------------------------------------------------------------------\n");
    while(P1!=NULL){
      ////////////////////////// RAPPEL : UPDATE AFFICHAGE
      printf("|%10s | %15s |%12s | %12f | %12s | %12d | %12s |\n",P1->val.nom,P1->val.code,P1->val.type,P1->val.val,P1->val.tab,P1->val.indice,P1->val.bitaff);
      P1=P1->suiv;
    }
    ///////////////////// afffichage de la 2eme table
    TS2 P2=T2;
    printf("\n**Table des symboles mots cles**");
    printf("\n------------------------------\n");
    printf("|    Name   |      Code    |\n");
    printf("------------------------------\n");
    while(P2!=NULL){
      printf("|%10s | %12s |\n",P2->val.nom,P2->val.code);
      P2=P2->suiv;
    }
    ///////////////////// afffichage de la 3eme table
    TS2 P3=T3;
    printf("\n**Table des symboles Separateurs**");
    printf("\n------------------------------\n");
    printf("|    Name   |      Code    |\n");
    printf("------------------------------\n");
    while(P3!=NULL){
      printf("|%10s | %12s |\n",P3->val.nom,P3->val.code);
      P3=P3->suiv;
    }
  }

  // fonction d insertion de type (utilise dans l analyse syntaxique)

    int inserer_type(char entite[],char type[]){
    TS1 P=T1;
    while(P!=NULL){
      if(strcmp((P->val.nom),entite)==0)
        break; //P = l entite recherchee
      P=P->suiv;
    }
    if(P!=NULL) {
      //l entite existe
      strcpy(P->val.type,type);
      return 0; // insertion du type effectuee avec succes
    }
    return -1; //l entite n existe pas
  }

  // fonction pour verifier qu une entite a bien ete declaree (possede un type)

    int check_decla(char entite[]){
    TS1 P;
    P=recherche1(entite);
    if(P!=NULL){ //l entite existe
      if(strcmp(P->val.bitaff,"1")==0){
        return 1; // l entite a une valeur
        }
      else{
        return 0; // l entite n a pas de valeur
      }
      }
    else
        return -1; // l entite n existe pas
  }

// retourne le type

void type(char entite[],char resultat[]) {

    char t[20];

    TS1 P1=recherche1(entite);
    if (P1!=NULL)
      strcpy(t,P1->val.type);
    else
      strcpy(t,"-");

    strcpy(resultat,t);
  }

// retourne la val
float val(char entite[],int opt,int i) {
    TS1 P;
    float t;
    switch (opt) {
      case 1: { //cas const,var autre que tab
        P=recherche1(entite);
        if(P!=NULL)
          t=P->val.val;
        else
          t=NAN;
        break;
      }
      case 2: { //cas elm tab
        P=rechercheT(entite,i);
        if(P!=NULL)
          t=P->val.val;
        else
          t=NAN;
        break;
      }
    }
    return t;
  }

  // verifie type int ou float

int verift(char entite[], char type[]){
  TS1 P;
  P=recherche1(entite);
  if(P!=NULL)
    if(strcmp((P->val.type),type)==0)
      return 1; // meme type
    else
      return 0; // pas meme type
  else
    return -1; // l entite n existe pas

}

// pour avoir le code , resultat dans la var "resultat"
void code(char entite[],char resultat[]){
  TS1 P;
  P=recherche1(entite);
  if(P!=NULL)
    strcpy(resultat,P->val.code);
  else
    strcpy(resultat,"-");
}

int checkbit(char entite[]){
  TS1 P;
  P=recherche1(entite);
  if(P!=NULL){
    if(strcmp((P->val.bitaff),"1")==0){
      return 1; // possede une val
      }
    else{
      return 0; // possede pas de val
      }
    }
  else
    return -1; // n existe pas

    }

#endif //TS_H
