

#include <sys/types.h>
#include <malloc.h>
#include <stdlib.h>
#include <string.h>

int m(void)
{
	puts("Nope");
	return 0;
}


int n(void)
{
	if (system("/bin/cat /home/user/level7/.pass"))
		return 0;
	return 1;
}

typedef int (*fun_t)(void);

int main(int ac,char **av) {
	char *dest;
	fun_t *puVar1;
	int iVar2;

	dest = malloc(64);
	puVar1 = malloc(sizeof (fun_t));
	*puVar1 = m;
	strcpy(dest,av[1]);
	iVar2 = (**puVar1)();
	return iVar2;
}
