
#include <stdio.h>
#include <unistd.h>
#include <string.h>

void bar(int a, int b)
{
	int x, y;

	x = 555;
	y = a+b;
}

void foo(void) {
	bar(111,222);
/* => */
}



int main(int ac, char **av) {

	const char *string = "Hello world!\n";
	foo();
	if (write(STDOUT_FILENO, string, strlen(string)))
		;
	return 0;
}