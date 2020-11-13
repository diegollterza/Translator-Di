mkdir source
cd source
bison -d ../sin.y
flex ../lex.l
gcc lex.yy.c sin.tab.c -o di.exe
copy di.exe ..\codigos\
cd ..
