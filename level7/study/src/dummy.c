// gcc -m32 -g3 -c -fno-eliminate-unused-debug-types study/src/dummy.c
// (gdb):
// 	add-symbol-file dummy.o

typedef struct node { int id; char *buf; }	t_node;


gcc -m32 -g3 -c -fno-eliminate-unused-debug-types <<< 'typedef struct node { int id; char *buf; } t_node;'


