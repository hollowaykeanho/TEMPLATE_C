#include <stdio.h>

int main(int argc, char *argv[]) {
	int i;
	printf("Hello World!\n");
	printf("These are your arguments: \n");

	for (i=0; i<argc; i++) {
		printf("argv[%d] = %s\n", i, argv[i]);
	}

	return 0;
}
