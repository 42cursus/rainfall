#include <iostream>
#include <cstring>
#include <csignal>

class N
{
private:
	char annotation[100];
	int number;

public:
	N(int x);
	void setAnnotation(char *a);

	virtual int operator+(N &r);
	virtual int operator-(N &r);

};

N::N(int x) : number(x) {}
void N::setAnnotation(char *a) {
	memcpy(annotation, a, strlen(a));
}

int N::operator+(N &r) {
	return number + r.number;
}

int N::operator-(N &r) {
	return number - r.number;
}

int main(int argc, char **argv)
{
	if(argc < 2) _exit(1);

	N *x = new N(5);
	N *y = new N(6);
	N &five = *x, &six = *y;

	five.setAnnotation(argv[1]);

	return six + five;
}
