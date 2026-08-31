
## Menu

[Main README](../README.md)

## Start the VM

```bash
qemu-system-x86_64 -m 4096 \
	-cpu max -boot d \
	-cdrom RainFall.iso \
	-display curses \
	-nic user,model=e1000,hostfwd=tcp::4242-:4242
```

## Setup ssh connection

```bash
sshpass -p level0 ssh -p '4242' 'level0@127.1' -i .ssh/ft_id_rsa 'setfacl -kb ~; chmod -v u+rwx ~;'
sshpass -p level0 ssh-copy-id -p 4242 -i ~/.ssh/ft_id_rsa.pub level0@127.1
```

## Run these commands under sudo 

```bash
cat >/etc/sudoers.d/users <<'EOF'
#!/bin/sh
level0 ALL=(ALL:ALL) NOPASSWD: ALL
EOF

chmod -v 0440 /etc/sudoers.d/users

cat >/etc/gdb/gdbinit  <<'EOF'
# System-wide GDB initialization file.

set backtrace past-main on
set backtrace past-entry on

set disassembly-flavor intel

# These make gdb never pause in its output
set height 0
set width 0
set confirm off
set pagination off

set logging on
set history filename ~/.gdb_history
set history save
set history size 10000

define hook-stop
x/16i $pc - 16
end

EOF

cat >/usr/local/bin/gdb <<'EOF'
#!/bin/sh
exec /usr/bin/gdb -q "$@"
EOF
chmod +x /usr/local/bin/gdb

setfacl -kb /etc/gdb
setfacl -kb /etc/gdb/gdbinit
getfacl -pe /etc/gdb/gdbinit

cat >/etc/apt/sources.list <<'EOF'
deb http://old-releases.ubuntu.com/ubuntu/ precise main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://old-releases.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse
EOF

rm -rf /var/lib/apt/lists/*
mkdir -p /var/lib/apt/lists/partial
apt-get -o Acquire::Check-Valid-Until=false update

{
dpkg -L binutils
dpkg -L coreutils
dpkg -L groff-base
dpkg -L update-notifier-common
dpkg -L gettext-base
dpkg -L install-info
dpkg -L sudo
dpkg -L libc-bin
dpkg -L libc-dev-bin
} | while IFS= read -r path;
do
[ -d "$path" ] && continue

    if file -- "$path" 2>&1 | grep -q 'Input/output error'; then
        rm -vf - "$path";
    fi
done

apt-get --reinstall install install-info groff-base gettext-base update-notifier-common -y && \
apt-get --reinstall install coreutils binutils libc-bin libc-dev-bin libc6-dbg -y && \
apt-get --reinstall install sudo attr libcap2-bin -y

```

## Mount ISO

```bash
sudo mkdir -p /mnt/RainFall_iso
sudo mount -o loop RainFall.iso /mnt/RainFall_iso
```

## Examine the ISO contents

```bash
sudo mkdir -p /mnt/squashfs
sudo mount -t squashfs -o loop /mnt/RainFall_iso/casper/filesystem.squashfs /mnt/squashfs
unsquashfs -cat /mnt/RainFall_iso/casper/filesystem.squashfs root/.bash_history | grep passwd -A1
```
