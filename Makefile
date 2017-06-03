all: yacc lex list.c
	cc lex.yy.c y.tab.c list.c file.c -o Proje -lfl

yacc: yac.y
	yacc -d yac.y

lex: lex.l
	lex lex.l
	
clear:
	rm lex.yy.c y.tab.* Proje output.txt

