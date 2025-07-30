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
%define parse.error verbose

/* Unión de tipos semánticos */
%union {
  struct elemento {
    int es_letra;
    int no_elem;
  } elem;
  int num;
  char caracter
}

/* Tokens tipados */
%token <num> DIGIT
%token <caracter> LETRA
%token <caracter> COMA
/* Tipo de los no-terminales que llevan valor */
%type  <elem> L
%type  <elem> E

/* Precedencias */
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

S:
    /* vacío */
  | S L '\n'       { printf("= Cadena Valida.\n"); }
  ;

L:
    L COMA E        { if ($1.es_letra == $3.es_letra) {
                        printf("Error en el elemento %d.\n", $1.no_elem + 1);
                        exit(1);
                      }
                      $$.es_letra = !$1.es_letra;
                      $$.no_elem = $1.no_elem + 1; }
  | E               { $$.es_letra = $1.es_letra; $$.no_elem = 1; }
  | error           { yyerrok; }
  ;

E:
    DIGIT   { $$.es_letra = 0; }
  | LETRA   { $$.es_letra = 1; }
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
