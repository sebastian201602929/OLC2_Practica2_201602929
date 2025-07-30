%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Prototipo del scanner */
extern int yylex(void);
/* yyerror con firma estándar */
void yyerror(const char *s);
%}

/* Seguimiento de ubicaciones */
%locations
/* Mensajes de error más detallados */
//%define parse.error verbose

/* Unión de tipos semánticos */
%union {
  int num;
  struct ex {
    int nec_par;
    char cadena[100];
  } expre
}

/* Tokens tipados */
%token <num> NUMBER
/* Tipo de los no-terminales que llevan valor */
%type  <expre> expr

%%

input:
    /* vacío */
  | input line
  ;

line:
    '\n'
  | expr '\n'   { printf("= %s\n", $1.cadena); }
  | error '\n'  { yyerrok; }
  ;

expr:
    expr expr '+'         { strcpy($$.cadena, $1.cadena);
                            strcat($$.cadena, " + ");
                            strcat($$.cadena, $2.cadena);
                            $$.nec_par = 1; }
  | expr expr '-'         { strcpy($$.cadena, $1.cadena);
                            strcat($$.cadena, " - ");
                            strcat($$.cadena, $2.cadena);
                            $$.nec_par = 1; }
  | expr expr '*'         { if ($1.nec_par) {
                              strcpy($$.cadena,"(");
                              strcat($$.cadena,$1.cadena);
                              strcat($$.cadena,")");
                            } else {
                              strcpy($$.cadena, $1.cadena);
                            }
                            strcat($$.cadena, " * ");
                            if ($2.nec_par) {
                              strcat($$.cadena,"(");
                              strcat($$.cadena,$2.cadena);
                              strcat($$.cadena,")");
                            } else {
                              strcat($$.cadena, $2.cadena);
                            }
                            $$.nec_par = 0; }
  | expr expr '/'         { if ($1.nec_par) {
                              strcpy($$.cadena,"(");
                              strcat($$.cadena,$1.cadena);
                              strcat($$.cadena,")");
                            } else {
                              strcpy($$.cadena, $1.cadena);
                            }
                            strcat($$.cadena, " / ");
                            if ($2.nec_par) {
                              strcat($$.cadena,"(");
                              strcat($$.cadena,$2.cadena);
                              strcat($$.cadena,")");
                            } else {
                              strcat($$.cadena, $2.cadena);
                            }
                            $$.nec_par = 0; }
  | NUMBER                { sprintf($$.cadena, "%d", $1); $$.nec_par = 0; }
  ;
%%

/* definición de yyerror, usa el yylloc global para ubicación */
void yyerror(const char *s) {
    fprintf(stderr,
            "%s en %d:%d\n",
            s,
            yylloc.first_line,
            yylloc.first_column);
}
