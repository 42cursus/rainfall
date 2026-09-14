#include <sys/mman.h>
#include <malloc.h>
#include <string.h>
#include <sys/types.h>
#include <time.h>

#include "stdio.h"

typedef struct internet {
	int priority;
	char *name;
} internet;


char c[70];

void m(void)
{
	uint uVar1;

	uVar1 = time(NULL);
	printf("%s - %d\n", c, uVar1);
	return;
}


int main(int ac,char **av)

{
	internet *i1;
	char *malloc_result;
	internet *i2;
	FILE *__stream;

	i1 = malloc(8);
	i1->priority = 1;
	malloc_result = malloc(8);
	i1->name = malloc_result;
	i2 = malloc(8);
	i2->priority = 2;
	malloc_result = malloc(8);
	i2->name = malloc_result;
	strcpy(i1->name,av[1]);
	strcpy(i2->name,av[2]);
	__stream = fopen("/home/user/level8/.pass","r");
	fgets(c,0x44,__stream);
	puts("~~");
	return 0;
}