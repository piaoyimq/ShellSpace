#!/bin/bash
DIALOG=${DIALOG=dialog}
# ??
#$DIALOG  --title 'nice' --calendar    "wowow" 3 30  28 10 2014
#$DIALOG --title 'nice'   --calendar     <text> <height> <width> <day> <month> <year>
 
# ???
#$DIALOG --title 'nice'  --checklist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
#$DIALOG   --title 'nice'  --checklist    "check" 20  100  20  tag1 item1 status1  tag2 item2 status2 tag3 item3 status3 
 
# ?????
#$DIALOG --title 'nice'  --dselect      /home/devop/  20 100
 
#$DIALOG --title 'nice'  --editbox      <file> <height> <width>
# ?????
#$DIALOG --title 'nice'  --editbox       /home/devop/1.sh 20 100
#$DIALOG --title 'nice'  --fselect      <filepath> <height> <width>
# ?????
#$DIALOG --title 'nice'  --fselect      <filepath> <height> <width>
#$DIALOG --title 'nice'  --fselect      /home/devop 20 100
 
# ???
#$DIALOG --title 'nice'  --gauge        <text> <height> <width> [<percent>]
#(for i in $(seq 1 100); do sleep 0.1 ; echo $i ; done) | $DIALOG --title 'nice'  --gauge        nice 20 100
#http://bash.cyberciti.biz/guide/A_progress_bar_(gauge_box)
 
# ????? (?????)
#$DIALOG --title 'nice'  --infobox      <text> <height> <width>
#$DIALOG --title 'nice'  --infobox     nice 20 100 
 
#???
#$DIALOG --title 'nice'  --inputbox     <text> <height> <width> [<init>]
#$DIALOG --title 'nice'  --inputbox     wow  20 100 shalk 
 
#????? Xdialog ???
#$DIALOG --title 'nice'  --inputmenu    wow 20 100   20  tag1 item1 tag2 item2 
 
#???
#$DIALOG --title 'nice'  --menu        wow 20 100   20  tag1 item1 tag2 item2
 
# ???
#$DIALOG --title 'nice'  --msgbox       <text> <height> <width>
#$DIALOG --title 'msgbox'  --msgbox       wow 20 100
 
 
# ???
#$DIALOG --title 'nice'  --passwordbox  <text> <height> <width> [<init>]
#$DIALOG --title 'passwordbox'  --passwordbox  wow 20 100 111111 
 
#????? Xdialog ???
#$DIALOG --title 'nice'  --pause        <text> <height> <width> <seconds>
#$DIALOG --title 'pause'  --pause        wow 20 100 5 
 
#??? tailf ????? Xdialog ???
#$DIALOG --title 'nice'  --progressbox  [<text>] <height> <width>
#cat '/etc/hosts' | $DIALOG --title 'progressbox'  --progressbox  20 100 
 
#??? ????????? ?menu???
#$DIALOG --title 'nice'  --radiolist    <text> <height> <width> <list height> <tag1> <item1> <status1>...
#$DIALOG --title 'radiolist'  --radiolist    wow 20 100  50  tag1 item1 status1 tag2 item2 status2
 
#??? tail -f ??
#$DIALOG --title 'nice'  --tailbox      <file> <height> <width>
#$DIALOG --title 'tailbox'  --tailbox      /home/devop/1.sh 20 100
#??? tailf -f &??
#$DIALOG --title 'nice'  --tailboxbg    <file> <height> <width>
#$DIALOG --title 'tailboxbg'  --tailboxbg  /home/devop/1.sh 20 100
#????? ??
$DIALOG --title 'nice'  --textbox      <file> <height> <width>
#$DIALOG --title 'textbox'  --textbox     /home/devop/1.sh 20 100
# ???
#$DIALOG --title 'nice'  --timebox      <text> <height> <width> <hour> <minute> <second>
#$DIALOG --title  'timebox'  --timebox     wow 20 100 15 30 30 
# yes/no ???
#$DIALOG --title 'nice'  --yesno        <text> <height> <width>
#$DIALOG --title 'yesno'  --yesno        wow 20 100 
