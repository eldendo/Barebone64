5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !         H2 the Interpreter         !"
50 print " +------------------------------------+"
60 print

900 rem *** repl ***
910 input w$: rem read word
920 gosub 1000: rem execute word
930 print ms$: rem print message
940 goto 900: rem loop

1000 rem *** interpreter ***
1010 ms$="ok."
1020 if w$="bye" then print "RETURNING TO BASIC.": end
1030 if w$="help" then print "Sorry no help yet...": return
1040 if w$="hello" then print "Hello to you too sir...": return
1200 ms$="SYNTAX ERROR."
1210 return


