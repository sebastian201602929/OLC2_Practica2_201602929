%{
#include <stdio.h>
#include <stdlib.h>

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
  struct lista {
    int entero;
    double decimal;
    double auxiliar;
  } slista;
  int num;
  double dec;
}

/* Tokens tipados */
%token <num> DIGIT
/* Tipo de los no-terminales que llevan valor */
%type <dec> X
%type <slista> L
%type <num> B

%%

S:
    /* vacío */
  | S X       { printf("= %lf\n", $2); }
  ;

X:
    '\n'
  | L '.' L '\n'    { $$ = $1.entero + $3.decimal; }
  | L '\n'          { $$ = $1.entero; }
  | error '\n'      { yyerrok; }
  ;

L:
    L B { $$.entero = $1.entero * 2 + $2; $$.auxiliar = $1.auxiliar / 2.0; $$.decimal = $1.decimal + $2 * $$.auxiliar; }
  | B   { $$.entero = $1; $$.auxiliar = 1.0 / 2.0; $$.decimal = $$.auxiliar * $1; }
  ;

B:
    DIGIT   { $$ = $1; }
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
