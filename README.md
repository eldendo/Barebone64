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

<hr style="page-break-after: always;"/>

# Chapter 3
## A RPN calculator (part 1)

Now that we made a REPL and an interpreter, let's do something with it.
In this chapter we will make a stack based calculator.

A stack is a LIFO (Last In First Out) data structure: Data is entered at the top of the stack, and removed again from the top. Compare it with a stack of books. You put one on the top, and that's the first one which has to be removed when taking books from the stack. In basic we can implement a stack whith an array and a variable (the Stack Pointer - SP) which points to the top of the stack.

First we extend our language with the arithmic operators '+','-','*' and '/'. They take the two top elements from the stack, execute the operation on them, and put the result back on the top of the stack. Remark that first is checked if there are two elements present on the stack. If not, an error condition (the variable ec) is set. 

The print part of the REPL uses this value to produce an apropriate error message. Also the content of the stack is displayed to show how it works.

'.' takes the top element from the stack and prints it to the screen.

At last we need a way to put numeric values on the stack. A simple way is to presume that everything that is entered but not recognised by the interpreter is a value. Then we can just convert it to a numeric value using the BASIC function VAL. There is of course a danger involved: If you type an error you won't get a 'syntax error' anymore. The VAL function converts every string to numeric. So typing an error will result in a value. (zero if the first characters typed are not numeric).

Remark that here we will test for a stack overflow before putting the value on the stack.


Test out the program. Remember you are working with a stack:  
`4*(5+6)` should be entered `4 5 6 + * .` 
This is called post fix notation or Reverse Polish Notation (RPN). Users of a HP calculator will recognise the system. 

Remark that you have to put one entry a line:  
```
4 (return)  
5 (return)  
6 (return)  
+ (return)  
* (return)  
. (return)  
```
In the next chapter we will make it possible to put this on one line.

---

```basic
5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !    H3 RPN calculator (part 1)      !"
50 print " +------------------------------------+"
60 print

100 rem *** system settings ***
110 ls=255: rem last stack index (stack size-1)
120 rem *** end of settings ***

800 gosub 9000: rem initialise

900 rem *** repl ***
910 input w$: rem read word
920 gosub 1000: rem execute word
930 gosub 5000: rem print 
940 goto 900: rem loop

1000 rem *** interpreter ***
1010 ec=0:rem reset error condition
1020 if w$="+" then 2100
1030 if w$="-" then 2150
1040 if w$="*" then 2200 
1050 if w$="/" then 2250
1060 if w$="." then 2300
1620 if w$="bye" then print "RETURNING TO BASIC.":end
1630 if w$="help" then print "Sorry no help yet...":return
1640 if w$="hello" then print "Hello to you too sir...":return

1700 rem ** if the word is unknown, a value is presumed. **
1710 if sp>=ls then ec=2:return: rem check for stack overflow
1720 sp=sp+1:s(sp)=val(w$)
1730 return


2100 rem *** '+' (a b -> a+b) ***
2110 if sp<1 then sp=-1:ec=1:return
2120 sp=sp-1:s(sp)=s(sp)+s(sp+1):
2130 return

2150 rem *** '-' (a b -> a-b) ***
2160 if sp<1 then sp=-1:ec=1:return
2170 sp=sp-1:s(sp)=s(sp)-s(sp+1):
2180 return

2200 rem *** '*' (a b -> a*b) ***
2210 if sp<1 then sp=-1:ec=1:return
2220 sp=sp-1:s(sp)=s(sp)*s(sp+1):
2230 return

2250 rem *** '/' (a b -> a/b) ***
2260 if sp<1 then sp=-1:ec=1:return
2270 sp=sp-1:s(sp)=s(sp)/s(sp+1):
2280 return

2300 rem *** '.' (a -> ) ***
2310 if sp<0 then sp=-1:ec=1:return
2320 print s(sp):sp=sp-1
2330 return

5000 rem *** print ***
5010 if ec=0 then print "ok."
5020 if ec=1 then print "ERROR: stack underflow."
5030 if ec=2 then print "ERROR: stack overflow."
5040 gosub 6000: rem print the stack
5050 return

6000 rem *** print the stack ***
6010 if sp<0 then print "[empty]":return
6015 print "[";
6020 for i=0 to sp
6030   print s(i);
6040 next i
6050 print "<- top ]"
6060 return

9000 rem *** initialise ***
9010 dim s(ls): sp=-1: rem stack and stack pointer
9020 return

```

<hr style="page-break-after: always;"/>

# Chapter 4
## A RPN Calculator (part 2)

In this chapter we will enter a line instead of a word. The first word will be taken of the line and interpreted like before. Then the other words will be sequentially treated. 

How this is done is best explained with the following code sniped:

```basic
10 rem *** a string scanner ***
20 li$="   hello    brave   new    world    "
30 gosub 100: rem take first word of line
40 print "'";w$;"'","'";li$;"'"
50 if w$<>"" then 30: rem then the next word 
60 end

98 rem * get first word in li$ to w$ *
99 rem * and leave rest of string in li$ *
100 i=1:l=len(li$):w$=""
110 rem first skip leading blanks
120 if i>l then return
130 if mid$(li$,i,1)=" " then i=i+1: goto 120
140 i0=i: rem first non blank position
150 if i<=l and mid$(li$,i,1)<>" " then i=i+1: goto 150
160 w$=mid$(li$,i0,i-i0)
170 li$=mid$(li$,i)
180 return

```
running it gives:

```
'hello'   '    brave   new    world    '
'brave'   '   new    world    '
'new'     '    world    '
'world'   '    '
''        '    '
```

By adding this snippet to the RPN calculater, we can now enter a calculation on one line like:
`4 5 6 * + .`

```basic
5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !    H4 RPN calculator (part 2)      !"
50 print " +------------------------------------+"
60 print

100 rem *** system settings ***
110 ls=255: rem last stack index (stack size-1)
120 rem *** end of settings ***

500 gosub 9000: rem initialise

600 rem *** repl ***
610 input li$: rem read line
620 gosub 700: rem execute line
630 gosub 5000: rem print 
640 goto 600: rem loop

700 rem *** execute line ***
705 ec=0: rem reset error condition
710 gosub 8000: rem scan line
720 if ec=0 and w$<>"" then gosub 1000: goto 710: rem interprete word
730 return 

1000 rem *** interpreter ***
1020 if w$="+" then 2100
1030 if w$="-" then 2150
1040 if w$="*" then 2200 
1050 if w$="/" then 2250
1060 if w$="." then 2300
1620 if w$="bye" then print "RETURNING TO BASIC.":end
1630 if w$="help" then print "Sorry no help yet...":return
1640 if w$="hello" then print "Hello to you too sir...":return

1700 rem ** if the word is unknown, a value is presumed. **
1710 if sp>=ls then ec=2:return: rem check for stack overflow
1720 sp=sp+1:s(sp)=val(w$)
1730 return

2100 rem *** '+' (a b -> a+b) ***
2110 if sp<1 then sp=-1:ec=1:return
2120 sp=sp-1:s(sp)=s(sp)+s(sp+1):
2130 return

2150 rem *** '-' (a b -> a-b) ***
2160 if sp<1 then sp=-1:ec=1:return
2170 sp=sp-1:s(sp)=s(sp)+s(sp+1):
2180 return

2200 rem *** '*' (a b -> a*b) ***
2210 if sp<1 then sp=-1:ec=1:return
2220 sp=sp-1:s(sp)=s(sp)*s(sp+1):
2230 return

2250 rem *** '/' (a b -> a/b) ***
2260 if sp<1 then sp=-1:ec=1:return
2270 sp=sp-1:s(sp)=s(sp)/s(sp+1):
2280 return

2300 rem *** '.' (a -> ) ***
2310 if sp<0 then sp=-1:ec=1:return
2320 print s(sp):sp=sp-1
2330 return

5000 rem *** print ***
5010 if ec=0 then print "ok."
5020 if ec=1 then print "ERROR: stack underflow."
5030 if ec=2 then print "ERROR: stack overflow."
5040 gosub 6000: rem print the stack
5050 return

6000 rem *** print the stack ***
6010 if sp<0 then print "[empty]":return
6015 print "[";
6020 for i=0 to sp
6030   print s(i);
6040 next i
6050 print "<- top ]"
6060 return

8000 rem *** string scanner ***
8010 rem * get first word in li$ to w$ *
8020 rem * and leave rest of string in li$ *
8100 i=1:l=len(li$):w$=""
8110 rem first skip leading blanks
8120 if i>l then return
8130 if mid$(li$,i,1)=" " then i=i+1: goto 8120
8140 i0=i: rem first non blank position
8150 if i<=l and mid$(li$,i,1)<>" " then i=i+1: goto 8150
8160 w$=mid$(li$,i0,i-i0)
8170 li$=mid$(li$,i)
8180 return

9000 rem *** initialise ***
9010 dim s(ls): sp=-1: rem stack and stack pointer
9020 return

```
