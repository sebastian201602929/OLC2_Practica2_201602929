#include <stdio.h>

/* Declaraciones generadas por Bison/Flex */
int yyparse(void);

int main(void) {
    printf("Analizador de cadenas alternadas (Ctrl+D para salir)\n> ");
    if (yyparse() != 0) {
        fprintf(stderr, "Fallo en el parseo\n");
        return 1;
    }
    return 0;
}
