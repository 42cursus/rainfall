macro define PROT_NONE  0x0
macro define PROT_READ  0x1
macro define PROT_WRITE 0x2
macro define PROT_EXEC  0x4

set prompt \033[31m(gdb) \033[0m

file ./level7
set $got = &_GLOBAL_OFFSET_TABLE_
python import re, gdb; \
    sec = gdb.execute('mt i sec .got.plt', to_string=True); \
    m = re.search(r'->(0x[0-9a-fA-F]+)', sec); \
    gdb.execute('set $got_end = ' + m.group(1))
set $gotsz = ((char *)$got_end - (char *)$got) / sizeof(void *)

macro define GOT $got
macro define GOTSZ $gotsz


define xa
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        x/a $p
        set $p = $p + 1
    end
end

define pas
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        printf "["
        output/a $p
        printf "]\t\t=> "
        output/a *$p
        printf "\n"
        set $p = $p + 1
    end
end

define xas
    set $p = (void **)$arg0
    set $end = $p + $arg1

    while $p < $end
        # GOT address: cyan
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Target address: yellow
        printf "%c[33m%p%c[0m\t", 27, *$p, 27

        # Symbol: green
        printf "%c[32m", 27
        info symbol *$p
        printf "%c[0m", 27

        set $p = $p + 1
    end
end

define xas0
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        printf "%p:\t%p\t", $p, *$p
        info symbol *$p
        set $p = $p + 1
    end
end

define xas2
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        printf "%p:\t%p\t", $p, *$p
        info symbol *$p
        set $p = $p + 1
    end
end

define xai
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0

    while $p < $end
        printf "[%02d] ", $i
        output/a $p
        printf "\n     └──> "
        info symbol *$p
        printf "\n"
        set $p = $p + 1
        set $i = $i + 1
    end
end

define xai2
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        printf "[%p] ", $p
        info symbol $p

        printf "    => %p ", *$p
        info symbol *$p

        set $p = $p + 1
    end
end

define sa
    call (int)mprotect(0x8048000, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC)
    call sprintf(0x80486eb, "fake-pass.txt")
end

br *main +156
commands
    printf "Hit PC = %p\n", $pc
    sa
    continue
end

set trace-commands on
set args AA BB
set trace-commands off
