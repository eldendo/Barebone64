5 print chr$(147);chr$(14);:rem clearscreen/charset 2
10 print " +------------------------------------+"
20 print " !            Barebone64              !"
30 print " !    (c)2022 ir. Marc Dendooven      !"
40 print " !           H6 Dictionary            !"
50 print " +------------------------------------+"
60 print

100 rem *** system settings ***
110 ls=255: rem last stack index (stack size-1)
120 ll=15: rem editor last line (0..ll)
130 ld=1000: rem last dictionary index (dic size-1)
150 rem *** end of settings ***

500 gosub 9000: rem initialise

600 rem *** repl ***
610 gosub 800: rem read line
620 gosub 700: rem execute line
630 gosub 5000: rem print 
640 goto 600: rem loop

700 rem *** execute line ***
705 ec=0: rem reset error condition
710 gosub 8000: rem scan line
720 if ec=0 and w$<>"" then gosub 900: goto 710: rem interprete word
730 return 

800 rem *** input ***
810 print ">";:input# id,li$:print
815 if li$="" then 830: rem workaround for empty lines
820 if st=0 then return
830 close id
840 id=50
850 return

900 rem *** interpreter ***
910 rem ** look in dictionary first **
920 v$=w$:gosub 7600
930 if v=-1 then 1000:rem not in dictionary
940 if t=1 then gosub 7000:return:rem it is a bound var
950 sys v:return:rem it's a MC routine
1000 rem ** else look here **
1020 if w$="+" then gosub 7100:v1=v:gosub 7100:v=v+v1:gosub 7000:return
1030 if w$="-" then gosub 7100:v1=v:gosub 7100:v=v-v1:gosub 7000:return
1040 if w$="*" then gosub 7100:v1=v:gosub 7100:v=v*v1:gosub 7000:return 
1050 if w$="/" then 2250
1060 if w$="." then gosub 7100:print v:return
1100 if w$="l" then 2500
1120 if w$="r" then 2600
1130 if w$="d" then 2700
1140 if w$="i" then 2800
1150 if w$="save" then 2900
1160 if w$="load" then 3000
1170 if w$="scratch" then 3100
1180 if w$="files" then 3200
1190 if w$="new" then for i=0 to ll:l$(i)="":next:return
1200 if w$="exec" then 3300
1210 if w$="constant" then t=1:goto 3400: rem add constant to dictionary
1220 if w$="external" then t=0:goto 3400: rem add function to dictionary
1230 if w$="_" then 4000: rem compiler
1620 if w$="bye" then print "RETURNING TO BASIC.":close 50:end
1630 if w$="help" then print "Sorry no help yet...":return
1640 if w$="hello" then print "Hello to you too sir...":return
1700 rem * if the word is unknown, a value is presumed. *
1720 v=val(w$):gosub 7000
1730 return

2250 rem *** '/' (a b -> a/b) ***
2260 gosub 7100:v1=v:gosub 7100
2265 if v1=0 then sp=-1:ec=3: return: rem div by zero
2270 v=v/v1:gosub 7000
2280 return

2500 rem *** l: list ***
2510 for i = 0 to ll
2520    print i;l$(i)
2530 next i
2540 return

2600 rem *** r: replace line ***
2610 gosub 7100:if ec<>0 or v>ll then return
2620 l$(v)=mid$(li$,2):li$=" "
2630 return

2700 rem *** d: delete line ***
2710 gosub 7100:if ec<>0 or v>ll then return
2720 if v<>ll then for i=v to ll-1:l$(i)=l$(i+1):next
2730 l$(ll)=" "
2740 return

2800 rem *** i: insert line ***
2810 gosub 7100:if ec<>0 or v>ll then return
2820 if v<>ll then for i=ll-1 to v step -1:l$(i+1)=l$(i):next
2830 l$(v)=mid$(li$,2):li$=""
2840 return

2900 rem *** save ***
2910 gosub 7100:if ec<>0 then return
2920 open 8,8,8,str$(v)+",s,w"
2930 for i=0 to ll
2933   if l$(i)="" then l$(i)=" " 
2935   print#8,l$(i)+" "
2937 next i
2940 close 8
2950 return

3000 rem *** load ***
3010 gosub 7100:if ec<>0 then return
3020 open 8,8,8,str$(v)+",s,r"
3030 i=0
3035 input#8,l$(i):i=i+1:if st=0 then 3035
3040 close 8
3050 return

3100 rem *** scratch ***
3110 gosub 7100:if ec<>0 then return
3120 open 8,8,15,"s0:"+str$(v)
3140 close 8
3150 return

3200 rem *** files ***
3205 qo$=chr$(34):qo=0
3207 print "disk:";
3210 open 1,8,0,"$"
3220 get#1,a$
3230 if st then close 1:return
3240 if a$="" then 3220
3250 if a$=qo$ then qo=not qo:if not qo then print qo$
3260 if qo then print a$;
3270 goto 3220

3300 rem *** exec ***
3310 gosub 7100:if ec<>0 then return
3320 open 8,8,8,str$(v)+",s,r"
3330 id=8
3340 return

3400 rem *** add to dict ***
3410 gosub 8000:v$=w$
3420 gosub 7100
3430 gosub 7500
3440 return

4000 rem *** compiler ***
4005 rem * test set border black *
4010 print "set testroutine at 49152"
4020 poke 49152,169  :rem lda# 00
4030 poke 49153,0
4040 poke 49154,141: rem sta $D020
4050 poke 49155,32
4060 poke 49156,208
4070 poke 49157,96: rem rts
4080 return

5000 rem *** print ***
5010 if ec=0 then print "ok."
5020 if ec=1 then print "ERROR: stack underflow."
5030 if ec=2 then print "ERROR: stack overflow."
5035 if ec=3 then print "ERROR: division by zero"
5037 if ec=4 then print "ERROR: dictionary full"
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

7000 rem *** push v on stack ***
7005 if ec<>0 then return
7010 if sp>=ls then ec=2:return: rem check for stack overflow
7020 sp=sp+1:s(sp)=v
7030 return

7100 rem *** pop v from stack ***
7105 if ec<>0 then return
7110 if sp<0 then sp=-1:ec=1:return: rem check for stack underflow
7120 v=s(sp):sp=sp-1
7130 return

7500 rem *** add dict entry ***
7510 if dp>=ld then ec=4:return: rem check for dictionary overflow
7520 dp=dp+1:di$(dp)=v$:dv(dp)=v:dt(dp)=t
7530 return

7600 rem *** search dict ***
7610 i=dp
7620 if i=-1 then v=i:return
7630 if di$(i)=v$ then v=dv(i):t=dt(i):return
7640 i=i-1
7650 goto 7620

8000 rem *** string scanner ***
8010 rem * get first word in li$ to w$ *
8020 rem * and leave rest of string in li$ *
8100 i=1:l=len(li$):w$=""
8110 rem first skip leading blanks
8120 if i>l then return:rem end of string
8130 if mid$(li$,i,1)=" " then i=i+1: goto 8120
8140 i0=i: rem first non blank position
8150 if i<=l and mid$(li$,i,1)<>" " then i=i+1: goto 8150
8160 w$=mid$(li$,i0,i-i0)
8170 li$=mid$(li$,i)
8180 return

9000 rem *** initialise ***
9010 dim s(ls): sp=-1: rem stack and stack pointer
9020 dim l$(ll): rem editor lines
9030 dim di$(ld),dv(ld),dt(ld): dp=-1: rem dictionary and pointer
9050 id=50:open id,0: rem open the keyboard as device
9100 return



