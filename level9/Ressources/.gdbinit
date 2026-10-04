#file ./level9
set $got = &_GLOBAL_OFFSET_TABLE_
python import re, gdb; \
    sec = gdb.execute('mt i sec .got.plt', to_string=True); \
    m = re.search(r'->(0x[0-9a-fA-F]+)', sec); \
    gdb.execute('set $got_end = ' + m.group(1))
set $gotsz = ((char *)$got_end - (char *)$got) / sizeof(void *)

macro define GOT $got
macro define GOTLAST $got_end - 1
macro define GOTSZ $gotsz

set print demangle on
set print asm-demangle on

set args $(perl -e 'print pack("N25", (0xbebafeca) x 25)')


define xa
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        x/a $p
        set $p = $p + 1
    end
end

br *main +136
br *main +10
commands
    printf "Hit PC = %p\n", $pc
    zs
    pi gdb.execute("continue")
end
