/**
 * compile with:
c++ -m32 \
	-O0 \
	-ggdb3 \
	-gdwarf-5 \
	-fno-pie \
	-no-pie \
	-fno-omit-frame-pointer \
	-maccumulate-outgoing-args \
	-fcf-protection=none \
	-fno-stack-protector \
	ClapTrap.cpp \
	-Wl,-z,norelro \
	-Wl,-z,execstack \
	-o test
 */
#include <string>
#include <sysexits.h>

class ClapTrap {
protected:
	static const std::string _className;
	static const std::string& DEFAULT_NAME;
	std::string _name;
public:
	ClapTrap();
	~ClapTrap();
	explicit ClapTrap(const std::string &name);
	const std::string &getName() const;
	virtual const std::string& getClassName() const;
};

const std::string ClapTrap::_className = "ClapTrap";
const std::string& ClapTrap::DEFAULT_NAME = "CL4P-TP#";

ClapTrap::ClapTrap() : _name(DEFAULT_NAME) {}
ClapTrap::ClapTrap(const std::string &name) : _name(name) {}
ClapTrap::~ClapTrap(){}

const std::string &ClapTrap::getName() const { return _name; }
const std::string& ClapTrap::getClassName() const { return _className; }

int main(int ac, char *av[])
{
	ClapTrap *cp = new ClapTrap("CL4P-TP$");
	const char *name = cp->getName().c_str();
	const char *className = cp->getClassName().c_str();
	const char *format = "%s: %s\n";
	printf(format, className, name);
	delete cp;
	return EX_OK;
	(void)ac;
	(void)av;
}
