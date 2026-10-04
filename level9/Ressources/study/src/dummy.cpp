class N
{
public:
	N(int x) : number(x) {}

	void setAnnotation(char *a);
	virtual int operator+(N &r) {return number + r.number;}
	virtual int operator-(N &r) {return number - r.number;}
private:
	char annotation[100];
	int number;
};
