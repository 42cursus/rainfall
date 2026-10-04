```bash
qemu-img create -f qcow2 vmstate.qcow2 8G

qemu-system-x86_64 -m 8192 \
  -cpu max \
  -boot d \
  -S \
  -cdrom RainFall.iso \
  -display curses \
  -monitor telnet:127.0.0.1:1234,server,nowait \
  -drive file=vmstate.qcow2,format=qcow2,if=none,id=vmstate \
  -nic user,model=e1000,hostfwd=tcp::4242-:4242

$ telnet 127.0.0.1 1234
(qemu) info status
VM status: paused (prelaunch)
# Only on subsequent launches
# =============================================================
(qemu) info snapshots
List of snapshots present on all disks:
ID        TAG               VM SIZE                DATE     VM CLOCK     ICOUNT
--        suspended         892 MiB 2026-09-21 15:33:50 00:14:32.785
(qemu) loadvm suspended
# =============================================================
(qemu) cont

$ ssh -tp '4242' level0@127.0.0.1

# After work is done:
$ telnet 127.0.0.1 1234
(qemu) info status
VM status: running
(qemu) stop
(qemu) savevm suspended
(qemu) info snapshots
List of snapshots present on all disks:
ID        TAG               VM SIZE                DATE     VM CLOCK     ICOUNT
--        suspended         2.5 GiB 2026-09-07 00:03:12160:20:54.942
(qemu) quit
```
