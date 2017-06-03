#include <string.h>
#include <stdlib.h>
#include <stdio.h>
typedef struct tableNode{//Her bir identifier için node tanımı
	char *ident;//ismi
	char *tmpid;//degerin gecici adı 
	struct tableNode *next;//bir sonraki bağlantısı
}tableNode;//typedefle kısaltılmıs isim tanımı

tableNode *tableHEAD;//Sembol tablosunun headeri

void add_to_table(char*,char*,tableNode**);//sembol tablosuna bir identifier ekleme fonksiyonu

tableNode* Finder(char*,tableNode*);//herhangi bir identifieri sembol tablosuna arama fonksiyonu

void printElementsOfTable(tableNode *h);//sembol tablosunu terminale basma fonksiyonu
