
## Examine file capabilities

```text
# For example:
# getcap ./program
# ./program cap_net_bind_service=ep
# No output means the file has no Linux file capabilities.
```

```bash
findmnt -T /usr/bin/gdb
getcap /path/to/executable
sudo setcap cap_sys_ptrace=ep /usr/bin/gdb
```

File capabilities are stored in the security.capability extended attribute
so you can also inspect it directly:
```bash
getfattr -n security.capability /path/to/executable
capsh --print
```