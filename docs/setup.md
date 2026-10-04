# RainFall VM setup

Use the RainFall ISO supplied by 42. Keep the ISO and the binaries extracted from it outside this Git repository. The level `source` files are readable reconstructions of those binaries; the `walkthrough` files describe commands to run against the ISO VM.

A QEMU example is in [qemu.md](qemu.md). For a simple live boot with local SSH forwarding:

```sh
qemu-system-x86_64 -m 2048 -boot d -cdrom /path/to/RainFall.iso \
  -display curses \
  -nic user,model=e1000,hostfwd=tcp:127.0.0.1:4242-:4242
ssh -p 4242 level0@127.0.0.1
```

The starting login and password are both `level0`. Use each level's `walkthrough` to reach the next account and read its `.pass` file. The walkthrough commands use the VM's Python 2.7, shell, and standard debugging tools. The 32-bit memory addresses and execution permissions were verified on the supplied VM and can differ on a modern host.
