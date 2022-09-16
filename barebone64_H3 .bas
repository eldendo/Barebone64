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


