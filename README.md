
# barebone64
## (c)2022 by ir. Marc Dendooven
---
# Introduction
The Commodore 64 was, and is, a great computer. I had a lot of fun with it but never explored it to its limits. Now that I have retired I really want to do the things I always wanted to do with the c64: building an environment that is better than the native BASIC environment, without using modern tools.

The c64 was shipped in a hurry... the BASIC interpreter was the same one used for the older PET computers which lacked the graphic and sound possibilities of the 64. In contrast to other computers of the '80 one can not simply draw a point or a line to the screen. There is no software onboard to do that. Almost all hardware has to be accessed using memory mapped IO. That means reading and writing to the IO registers of the hardware using the basic commands PEEK and POKE. But this is also an opportunity: one is obliged to learn how the hardware works in order to use it. And if you want to do something at a reasonable speed, you are almost obliged to learn machine language. Every step learning opens a complete new world of possibilities. 

Of course later a whole bunch of development software was available... Alternative interpreters like Simon's Basic or C and Pascal compilers became available. Nowadays there are complete cross development systems where one can develop c64 programs on a PC using all modern facilities.

But it is my goal here to restart my Commodore adventures where I started them in 1983: With a bare computer and a storage device (a cassette recorder or a harddrive) and no other software than the native BASIC V2 interpreter. All necessary tools have to be build in BASIC, hand-translated machine code or using the tools already (self)made in this project before.

Of course it is not necessary to use a real Commodore. An emulator is perfect replacement. I will use VICE. Writing code can be done in a simple editor, using cut & paste in vice. 

Retro computing is not only a hobby, it is also a learning method. It shows certain techniques and principles which are often neglected in modern computer science courses. As a former instructor in computer science, I will focus on the educative aspects while building this environment.   




Let the games begin...

<hr style="page-break-after: always;"/>

# Chapter 1
## The REPL

Let's start with a simple command line environment: a REPL.

REPL stands for:

Read
Evaluate (or Execute)
Print
Loop

The user is presented with an input prompt, the input is evaluated or executed. Evaluation is a term mostly used in functional languages while execution is more appropriate in imperative languages. The result of the evaluation is presented in the print part. Since our environment will be imperative, output will be displayed (just like in BASIC) while executing (by an equivalent of the BASIC print instruction). Here the print part will only display error messages (or "ok." when there are no errors). The loop part closes the loop so that the REPL runs forever if not some how interrupted by an instruction in the execute part.

The following piece of code is quite comprehensible:

---
```basic
5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !            H1 the REPL             !"
50 print " +------------------------------------+"
60 print

900 rem *** repl ***
910 input w$: rem read
920 if w$="bye" then print "RETURNING TO BASIC.": end: rem execute
930 print "ok.": rem print
940 goto 900: rem loop
```

<hr style="page-break-after: always;"/>

# Chapter 2
## The interpreter

Now that we have a REPL it's very simple to add an interpreter for a lexical language.
A lexical language is nothing more than a list of words the system understands.
Again the code is very simple: The execute part of the REPL calls the interpreter subroutine.
The interpreter is nothing more than a list of 'IF THEN' instructions. If no word matches, an error string (ms$) defaulting to 'ok.' is set to 'SYNTAX ERROR'. This string is used as text in the print part of the REPL.

---
```basic
5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !         H2 the Interpreter         !"
50 print " +------------------------------------+"
60 print

900 rem *** repl ***
910 input w$: rem read
920 gosub 1000: rem execute
930 print ms$: rem print
940 goto 900: rem loop

1000 rem *** interpreter ***
1010 ms$="ok."
1020 if w$="bye" then print "RETURNING TO BASIC.": end
1030 if w$="help" then print "Sorry no help yet...": return
1040 if w$="hello" then print "Hello to you too sir...": return
1200 ms$="SYNTAX ERROR."
1210 return

```

