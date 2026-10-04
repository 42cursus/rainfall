#include <stdio.h>
#include <stddef.h>

int main() {
	char s[64];
	fgets(s, sizeof(s), stdin);

	fwrite(s, 1, __builtin_strlen(s), stdout);

	printf("%2$x, %1$s", s, 25);
}
