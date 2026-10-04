```bash
python3 -c 'print("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x31\xd2\xb0\x0b\xcd\x80".encode("utf-8").hex())'
31c38050682f2f7368682f62696ec289c3a35053c289c3a131c392c2b00bc38dc280
```


```bash
python2.7 -c 'print "hello".encode("hex")'
68656c6c6f

python -c 'print("hello".encode("utf-8").hex())'
python -c 'print "\x08\xa0\x04\x08".encode("utf-8").hex()'
68656c6c6f
```