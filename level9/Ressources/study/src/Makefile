NAME 		= clapTrap
CXXFLAGS	:= -m32 \
				-Wa,-L \
				-no-pie -fno-pie \
				-ggdb3 -gdwarf-5 \
				-maccumulate-outgoing-args \
				-fcf-protection=none -mmanual-endbr \
				-fno-omit-frame-pointer \
				-fno-eliminate-unused-debug-symbols \
				-fno-eliminate-unused-debug-types \
				-femit-class-debug-always

LDFLAGS		:= -m32 \
				-no-pie \
				-Wl,-z,norelro \
				-fno-stack-protector \
				-Wl,-z,execstack

CXX				= g++-9

SRCS			= ClapTrap.cpp

all: $(NAME) test

$(NAME): $(SRCS)
		$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@
		@echo "$(NAME) BUILD COMPLETE!"

test: main.cpp
		$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@
		@echo "$(NAME) BUILD COMPLETE!"

fclean: #clean
		@$(RM) -vf $(NAME) test

re: fclean
		+$(MAKE) all
