macro define PROT_NONE  0x0
macro define PROT_READ  0x1
macro define PROT_WRITE 0x2
macro define PROT_EXEC  0x4

set prompt \001\033[1;32m\002(gdb)\001\033[0m\002\040

file ./level8
set $got = &_GLOBAL_OFFSET_TABLE_
python import re, gdb; \
    sec = gdb.execute('mt i sec .got.plt', to_string=True); \
    m = re.search(r'->(0x[0-9a-fA-F]+)', sec); \
    gdb.execute('set $got_end = ' + m.group(1))
set $gotsz = ((char *)$got_end - (char *)$got) / sizeof(void *)

macro define GOT $got
macro define GOTLAST $got_end - 1
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
    set $i = 0

    while $p < $end
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%02d]%c[0m ", 27, $i, 27
        # GOT address: cyan
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Target address: yellow
        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p + 1
        set $i = $i + 1
    end
end

define xas
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0

    while $p < $end
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%02d]%c[0m ", 27, $i, 27

        printf "(%c[36m", 27
        output/a $p
        printf "%c[0m) ", 27

        printf "%c[90m->%c[0m ", 27, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p + 1
        set $i = $i + 1
    end
end

define pan
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0

    while $p < $end
        printf "%c[2m[%02d]%c[0m ", 27, $i, 27
        # GOT address: cyan
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Target address: yellow
        printf "%c[33m0x%08x%c[0m\t", 27, *$p, 27

        # Symbol: green
        printf "%c[32m", 27
        info symbol *$p
        printf "%c[0m", 27

        set $p = $p + 1
        set $i = $i + 1
    end
end

define xan
    set $p = (void **)$arg0
    set $end = $p + $arg1
    set $i = 0

    while $p < $end
        # Reset in case some previous command left the terminal dirty.
        printf "%c[0m", 27

        # Fault-prone work first.
        set $addr = *$p
        printf "%c[2m[%02d]%c[0m ", 27, $i, 27
        printf "(%c[36m", 27
        output/a $p
        printf "%c[0m)\t", 27

        # dimmed arrow
        printf "%c[90m->%c[0m ", 27, 27

        # Target address: yellow
        printf "[%c[33m0x%08x%c[0m] - ", 27, $addr, 27

        # Symbol: green
        printf "%c[32m", 27
        info symbol $addr
        printf "%c[0m", 27

        set $p = $p + 1
        set $i = $i + 1
    end
end

define rpas
    set $_rp_base = (void **)$arg0
    set $count = $arg1

    if $argc >= 3
        set $ctx = $arg2
    else
        set $ctx = 1
    end

    set $step = sizeof(void *)

    # Positive/context side first
    set $i = $ctx
    set $p = $_rp_base + $ctx

    while $i > 0
        printf "%c[0m", 27

        set $addr = *$p
        set $off = $i * $step

        # Offset column
        printf "%c[2m[%+4d]%c[0m ", 27, $off, 27

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
    set $p = $_rp_base
    set $addr = *$p

    printf "%c[0m", 27
    printf "%c[1m[  =>]%c[0m ", 27, 27
    printf "%c[36m%p%c[0m:\t", 27, $p, 27
    printf "[%c[33m", 27
    output/a $addr
    printf "%c[0m]\n", 27

    # Negative side
    set $p = $_rp_base - 1
    set $i = -1
    set $end = $_rp_base - $count

    while $p > $end
        printf "%c[0m", 27

        set $addr = *$p
        set $off = $i * $step

        printf "%c[2m[%+4d]%c[0m ", 27, $off, 27

        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end

define rpas2
    set $p = (void **)$arg0
    set $i = 0
    set $end = $p - $arg1

    while $p > $end
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%3d]%c[0m ", 27, $i, 27

        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end


define rxas
    set $p = (void **)$arg0
    set $i = 0
    set $end = $p - $arg1

    while $p > $end
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%3d]%c[0m ", 27, $i, 27

        printf "(%c[36m", 27
        output/a $p
        printf "%c[0m) ", 27

        printf "%c[90m->%c[0m ", 27, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end

define xasi
    set $_rp_base = (void **)$arg0
    set $count = $arg1
    set $p = $_rp_base + $count - 1
    set $i = $count - 1

    while $p >= $_rp_base
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%02d]%c[0m ", 27, $i, 27

        printf "(%c[36m", 27
        output/a $p
        printf "%c[0m) ", 27

        printf "%c[90m->%c[0m ", 27, 27

        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end

define pasi
    set $_rp_base = (void **)$arg0
    set $count = $arg1
    set $p = $_rp_base + $count - 1
    set $i = $count - 1

    while $p >= $_rp_base
        printf "%c[0m", 27

        set $addr = *$p

        printf "%c[2m[%02d]%c[0m ", 27, $i, 27

        # Slot address: cyan
        printf "%c[36m%p%c[0m:\t", 27, $p, 27

        # Target address: yellow
        printf "[%c[33m", 27
        output/a $addr
        printf "%c[0m]\n", 27

        set $p = $p - 1
        set $i = $i - 1
    end
end

define rpas2
    set $_rp_base = (void **)$arg0
    set $p = $_rp_base + $arg1 - 1

    while $p >= $_rp_base
        printf "["
        output/a $p
        printf "]\t\t=> "
        output/a *$p
        printf "\n"

        set $p = $p - 1
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
