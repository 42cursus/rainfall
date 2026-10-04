# RainFall

42 School binary exploitation project on the supplied 32-bit RainFall VM.

## Team

- Andrei Belov — `abelov`
- Yookyeong Choi — `yookyeoc`

## Submission

Each `level0`–`level9` and `bonus0`–`bonus3` directory contains:

- `flag`: the next account's password, obtained from the running VM;
- `source`: readable C or C++ reconstruction of that level's binary;
- `walkthrough`: the vulnerability, payload derivation, and VM demonstration;
- `Ressources/`: investigation notes and supporting text source files.

The mandatory levels and bonuses were checked against the supplied VM. Shellcode and fixed stack or heap addresses are specific to that environment. The VM ISO and challenge binaries are excluded from Git, as required by the project subject.

See [VM setup](docs/setup.md) for how to start and access the VM. For the defense, run each walkthrough manually and explain the relevant branch, memory layout, and exploit result. The [correction sheet](https://www.42evalhub.com/spec/rainfall) asks for a precise explanation and a source reconstruction matching the real binary at each level.
