# RE + Pwn Workshop: Student Guide

Four small programs, each hiding a flag that looks like `flag{something}`. The
first two we do together, the last two are yours.

## Setup

### Option A: GitHub Codespaces (easiest, runs in your browser)

1. Sign in to GitHub (make a free account if you need one)
2. Open the workshop repo link, click the green **Code** button, then the
   **Codespaces** tab, then **Create codespace on main**
3. Wait a few minutes the first time. When the terminal at the bottom shows
   `student@...:/challenges$`, you are in

### Option B: Docker on your own computer

Install Docker Desktop (https://www.docker.com/products/docker-desktop), open
it, then in a terminal run:

```bash
docker run -it ghcr.io/choice404/re-pwn:latest
```

Either way, type `ls` and you should see
`bank  door  flag.txt  keypad  vault.pyc`.

## Tools inside the box

- `uncompyle6 file.pyc` turns Python bytecode back into Python source
- `strings`, `file`, `nm`, `objdump` inspect a program without running it
- `gdb` steps through a running program
- `nc` connects to the workshop server
- Online decompiler for the C programs: https://dogbolt.com (the files are in
  `challenges/` in this folder, drag them in from your file browser)

## About flag.txt

Try `cat flag.txt`. Permission denied, only root can read it. `bank` and `door`
run with root's permission, so if you can trick one of them into printing the
flag, you win. (Under gdb that root permission is dropped, so do your
exploring in gdb, then run the final attack normally.)

## Demo 1: The Python Vault (`vault.pyc`) [together]

`python vault.pyc` asks for a password. Decompile it with `uncompyle6 vault.pyc`
and undo the math.

## Demo 2: Bank of Overflow (`bank`) [together]

`./bank` only shows the vault to admins. Your name is stored right next to the
`is_admin` setting in memory. What happens if your name is really long?

## Challenge 3: Keypad (`keypad`)

`./keypad` wants an access code. `strings` will not help you this time, the
code is never stored as plain text. Decompile it on dogbolt and look at
`check_code`.

Hints (try before reading the next one):
1. The bytes in `EXPECTED` and `KEY` are in the decompiled output, or use
   `objdump -s -j .rodata keypad`.
2. Undo the steps in reverse order: first undo the `+ 3`, then undo the XOR.
3. XOR undoes itself: if `a ^ k == b`, then `b ^ k == a`.
4. Write a short python3 loop to do all 11 characters at once.

## Challenge 4: Smart Door (`door`)

`./door` lets you leave a note. The PIN is stored right after the note. You
need the PIN to be one exact value, not just "not zero".

Hints:
1. Decompile it. How big is the note? What PIN does it want?
2. The `[debug] pin = ...` line shows what you wrote. Try 48 A's, then 52.
3. x86 stores numbers backwards in memory (little endian). `0x11223344` is the
   bytes `44 33 22 11`.
4. You cannot type those bytes on a keyboard. Let Python do it:
   `python3 -c 'import sys; sys.stdout.buffer.write(b"A"*48 + b"\x44\x33\x22\x11")' | ./door`

Good luck. Break things (these ones).
