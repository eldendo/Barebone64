5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !            H1 the REPL             !"
50 print " +------------------------------------+"
60 print

900 rem *** repl ***
910 input w$: rem read word
920 if w$="bye" then print "RETURNING TO BASIC.": end: rem execute word
930 print "ok.": rem print message
940 goto 900: rem loop


