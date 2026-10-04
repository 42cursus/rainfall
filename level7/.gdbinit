set debuginfod enabled on
set height 0
set pagination off
set confirm off
set print pretty on
set print array on
set print array-indexes on
set disassembly-flavor intel

define xa
    set $p = (void **)$arg0
    set $end = $p + $arg1
    while $p < $end
        x/a $p
        set $p = $p + 1
    end
end

define zs
    python gdb.selected_inferior().write_memory(\
        int(gdb.parse_and_eval('(unsigned long)$sp')), \
        b'\x00' * int(gdb.parse_and_eval('$fp - $sp')) \
    )
end
document zs
    Zero memory from the current stack pointer up to the frame pointer.
end


macro define PROT_NONE  0x0
macro define PROT_READ  0x1
macro define PROT_WRITE 0x2
macro define PROT_EXEC  0x4

set prompt \001\033[1;32m\002(gdb)\001\033[0m\002\040

define xan
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0
    while $p < $end
        printf "[%02d] ", $i
        x/a $p
        set $p = $p + 1
        set $i = $i + 1
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

define xasn
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0

    while $p < $end
        printf "[%02d] ", $i

        # GOT address: cyan
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Target address: yellow
        printf "%c[33m%p%c[0m\t", 27, *$p, 27

        # Symbol: green
        printf "%c[32m", 27
        info symbol *$p
        printf "%c[0m", 27

        set $p = $p + 1
        set $i = $i + 1
    end
end

define sa
    call (int)mprotect(0x8048000, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC)
    !if [ ! -f "fake-pass.txt" ]; then \
        head -n 25 /dev/urandom | \
        tr -dc 'a-zA-Z0-9.$\@!{}' | \
        fold -w 64 | head -n 1 > "fake-pass.txt"; \
    fi
    call sprintf(0x80486eb, "fake-pass.txt")
end

define rpas
    set $base = (void **)$arg0
    set $count = $arg1

    if $argc >= 3
        set $ctx = $arg2
    else
        set $ctx = 1
    end

    set $step = sizeof(void *)

    # Positive/context side first
    set $i = $ctx
    set $p = $base + $ctx

    while $i > 0
        printf "%c[0m", 27

        set $addr = *$p
        set $off = $i * $step

        # Offset column
        #printf "%c[2m[%+4d]%c[0m ", 27, $off, 27
        printf "%c[2m[%+4d|+0x%02x]%c[0m ", 27, $off, $off, 27

        # Slot address
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Value
        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end

    # Anchor
    set $p = $base
    set $addr = *$p

    printf "%c[0m", 27

    printf "%c[1m[       => ]%c[0m ", 27, 27
    #printf "%c[1m[  =>]%c[0m ", 27, 27


    printf "%c[36m%p%c[0m:\t", 27, $p, 27
    printf "[%c[33m", 27
    output/a $addr
    printf "%c[0m]\n", 27

    # Negative side
    set $p = $base - 1
    set $i = -1
    set $end = $base - $count

    while $p > $end
        printf "%c[0m", 27

        set $addr = *$p
        set $off = $i * $step

        #printf "%c[2m[%+4d]%c[0m ", 27, $off, 27
        printf "%c[2m[%+4d|-0x%02x]%c[0m ", 27, $off, -$off, 27

        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end

#file ./level7

set $got = &_GLOBAL_OFFSET_TABLE_
python import re, gdb; \
    sec = gdb.execute('mt i sec .got.plt', to_string=True); \
    m = re.search(r'->(0x[0-9a-fA-F]+)', sec); \
    gdb.execute('set $got_end = ' + m.group(1))
set $gotsz = ((char *)$got_end - (char *)$got) / sizeof(void *)

macro define GOT $got
macro define GOTLAST $got_end - 1
macro define GOTSZ $gotsz


br *main +9
commands
    printf "Hit PC = %p\n", $pc
    zs
    #continue
end

br *main +103
commands
    rpas $sp 1 13
    set trace-commands on
    add-symbol-file dummy.o
    ptype t_node
    p **(t_node **)($sp + 24)
    p **(t_node **)($sp + 28)
    set trace-commands off
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
