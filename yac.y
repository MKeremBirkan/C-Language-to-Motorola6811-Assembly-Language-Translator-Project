%{
	#include <stdio.h>
	#include "list.h"
	#include "file.h"
	void yyerror(char *);//yyerror fonksiyon protitipi
	int yylex(void);//yylex fonksiyon protitipi
	extern FILE *yyin;//
	extern int linenum;//lexten gelen satır numarası
	char writeArray[100];//dosyaya yazılacak string için kullanılan karakter arrayi
	char tmpCharBuf[50];//gecici string arrayi
	int variableNum=100;//variable indexleri
	int tempNum=200;//temp indexleri
	char ifelse = 'A';	
%}
%union
{
	int nbr;//her bir integer veya expressionun pars tree deki $$ türü
	char *str;//her bir varaible in tree deki $$ türü
}
%token <str> INTEGER //parse treedeki INTEGER in $$ ı int olması 
%token <str> IDENTIFIER //parse treedeki IDENTIFIER in $$ ı string olması 
%token MINUS PLUS DIVIDE MULTI OPENPR CLOSEPR EQUAL SEMICOLON STD MAIN INCRSW INTRSW RETURNRSW IFRSW ELSERSW HASH OPENBR CLOSEBR LESSTHAN GREATHERTHAN COMMA//lexten gelen tokenlar
%type <str> expr//parse treedeki expr in $$ ı int olması
%type <str> ops// string type
%left PLUS MINUS//toplamanın çıkarmadan önceliği
%left MULTI DIVIDE//çarpmanında bölmeden aynı zamanda toplama ve çıkarmadan önceliği
%%

program:
	statements//tanımlamalar
	;
statements:
	statement statements//birden fazla tanımlamalar
	|
	statement//tek bir tanımlama
	;
include_part:
	HASH INCRSW LESSTHAN STD GREATHERTHAN//#inlude <stdio.h> tanımı
	;
main_decleration:
	INTRSW MAIN OPENPR CLOSEPR OPENBR statements CLOSEBR//main fonksiyon tanımı
	;
statement:
	if_statement//if blogu tanımı
	|
	include_part//#inlude <stdio.h> blogu
	|
	main_decleration//int main() { ... } tanımı
	| 
	single_assigment_block//tek işlem a= expr
	| 
	integer_assignment_block//int a,b,c=5 tanımı
	| 
	return_assignment_block//return 0; tanımı
	;
if_statement:  
	if_block//if block tanımı
	|
	if_block elseif_blocks	// if + else if blogu
	|
	if_block else_block // if + else blogu
	;
elseif_blocks: 
	elseif_block elseif_blocks// elif + elif blogu
	|
	elseif_block// elif blogu
	|
	elseif_block else_block// elif + else blogu
	;
if_block:	
	IFRSW OPENPR compare CLOSEPR statement// if (..comparison..) 
	| 
	IFRSW OPENPR compare CLOSEPR OPENBR statements CLOSEBR// if (..comparison..) {....}
	;
elseif_block: 
	ELSERSW OPENPR compare CLOSEPR statement//else if (..comparison..) 
	|
	ELSERSW OPENPR compare CLOSEPR OPENBR statements CLOSEBR // else if (..comparison..) {....}
	;
else_block: 
	ELSERSW prog statement//else 
	|
	ELSERSW prog OPENBR statements CLOSEBR// else {....}
	;
prog:
	{
		sprintf(tmpCharBuf,"prog%c",ifelse);// if ve elseler icin prog tanımı
		Writer(tmpCharBuf);
		ifelse++;//her blog icin harf attırımı
	}
	;		
compare:
	expr LESSTHAN expr//(... < ...)
	{
		sprintf(writeArray,"\tLDAA %s\n\tSUBA %s\n\tBGT prog%c\n",$1,$3,ifelse);
		Writer(writeArray);
	}
	|
	expr GREATHERTHAN expr//(... > ...)
	{
		sprintf(writeArray,"\tLDAA %s\n\tSUBA %s\n\tBLT prog%c\n",$1,$3,ifelse);
		Writer(writeArray);
	}
	;				
return_assignment_block:
	RETURNRSW INTEGER SEMICOLON// return tanımı
	{
		Writer("\t.end");//asambly son kodu
	}
	;
integer_assignment_block:
	INTRSW assigments SEMICOLON// int c=3; yada birden fazla integer (int k=2,a,b=6;)
	;
single_assigment_block:
	single_assigment  SEMICOLON//c=12 veya birden fazla expression hali
	;
assigments:
	assignment COMMA assigments//a,b,c,d yada a=5,b=5+(34*2)
	|
	assignment//a=5 veya b=5+(34*2) veya a
	;
single_assigment:
	IDENTIFIER EQUAL expr
	{ 
		tableNode *x;//idenditifier ekleme yada değiştirmek icin boş bir node
		x=Finder($1,tableHEAD);//identifierin sembol tablosunda aranması
		if(x==NULL){//eger sembol tablosunda degilse syntax hatası
			printf("Error : %s not declared ! ----- Line number : %d\n",$1,linenum+1);
			exit(0);
		}else{//eger sembol tablosundaysa direk load edip
			sprintf(writeArray,"\tLDAA %s\n\tSTAA $%s\n",$3,x->tmpid);
			Writer(writeArray);
		}	
	}
	;
assignment:
	IDENTIFIER EQUAL expr
	{
		sprintf(tmpCharBuf,"%d",variableNum);//varaiblar icin address ekleme
		sprintf(writeArray,"\tLDAA %s\n\tSTAA $%s\n",$3,tmpCharBuf);//sayısal degerleri eşitleme
		Writer(writeArray);
		add_to_table($1,strdup(tmpCharBuf),&tableHEAD);//sembol tablosunu her varaible icin adress ekleme	
		variableNum++;//bir sonraki varaible icin deger arttırma
	}
	|
	IDENTIFIER
	{//varaibların sembol tablosuna eklenip asablye cevrilmesi
		sprintf(tmpCharBuf,"%d",variableNum);
		sprintf(writeArray,"\tLDAA #%d\n\tSTAA $%s\n",0,tmpCharBuf);//asamblyde görmek icin eklendi
		Writer(writeArray);
		add_to_table($1,strdup(tmpCharBuf),&tableHEAD);	
		variableNum++;	
	}
	;
expr:
	INTEGER	{sprintf(tmpCharBuf,"%s",$1);sprintf($$,"#%s",tmpCharBuf);}//sayıların asambly icin deger alınması
	|
	IDENTIFIER                      
	{ 
		tableNode *a;
		a=Finder($1,tableHEAD);//lexten gelen identifier isminin sembol tablosunda aranması
		if(a==NULL){//tabloda degilse hic bir sey yapmaya gerek yok cunki herhangi bir value su yok
			printf("Error : %s not declared ! ----- Line number : %d\n",$1,linenum+1);
			exit(0);
		}else{
			sprintf($$,"$%s",a->tmpid);//varaiblin asambly icin adressinin alınması		
		}
	}
	|
	expr ops expr  { 
				sprintf(tmpCharBuf,"$%d",tempNum);
				if (strcmp($2,"+") == 0){
					sprintf(writeArray,"\tLDAA %s\n\tADDA %s\n\tSTAA %s\n",$1,$3,tmpCharBuf);
				}else if(strcmp($2,"-") == 0){
					sprintf(writeArray,"\tLDAA %s\n\tSUBA %s\n\tSTAA %s\n",$1,$3,tmpCharBuf);
				}else if(strcmp($2,"*") == 0){
					sprintf(writeArray,"\tLDAA %s\n\tLDAB %s\n\tMUL\n\tSTAB %s\n",$1,$3,tmpCharBuf);
				}else
					printf("Error : %s can't operate ! ----- Line number : %d\n",$2,linenum+1);
				Writer(writeArray);
				tempNum++;
				$$=strdup(tmpCharBuf);
			}
	| 
	OPENPR expr CLOSEPR  { $$ = strdup($2); }// ( ..expression.. )
	;
ops:
	PLUS{$$="+";}
	|
	MINUS{$$="-";}
	|
	MULTI{$$="*";}
	;
%%



void yyerror(char *s) {
    fprintf(stderr, "Error : %s ----- Line number : %d\n",s,linenum);//sytax hatası varsa ekranda satır numarasını gösterimi
}
int yywrap(){
	return 1;//sytax hatası yoksa yaccin sonlandırılması
}
int main(int argc, char *argv[])
{
    tableHEAD=NULL;//sembol tablosunun ilk nodunun içinin boş tanımlanması
    OpFile("output.txt");//output dosya açılması
    yyin=fopen(argv[1],"r");//dısarıdan alının input dosyasının girdisi
    yyparse();//parse treenin oluşumu
    fclose(yyin);//input dosyasının kapatılması
    CLFile();//output dosyasının kapatılması
    return 0;
}
