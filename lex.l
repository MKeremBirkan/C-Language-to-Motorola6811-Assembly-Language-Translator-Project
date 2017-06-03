digit	[0-9]
letter	[a-z]
%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
int linenum;
%}
%%
"stdio.h" return STD;
"main" return MAIN;
"include" return INCRSW; 
"int" return INTRSW;
"return" return RETURNRSW;
"if" return IFRSW;
"else" return ELSERSW;
{digit}+	{yylval.str = strdup(yytext);return INTEGER;}
{letter}({letter}|{digit})*	{yylval.str = strdup(yytext);return IDENTIFIER;}
"#"	return HASH;
"*"	return MULTI;
"="	return EQUAL;
"-"	return MINUS;
"+"	return PLUS;
"("	return OPENPR;
")"	return CLOSEPR;
"{"	return OPENBR;
"}"	return CLOSEBR;
";" 	return SEMICOLON;
"<"	return LESSTHAN;
">"	return GREATHERTHAN;
","	return COMMA;
\/	return DIVIDE;
\n	linenum++;
[ \t]+
%%
