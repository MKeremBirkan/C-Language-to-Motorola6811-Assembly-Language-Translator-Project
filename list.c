#include "list.h"

void add_to_table(char *id,char *tmpid,tableNode **head){
    tableNode *new_node;//yeni eklenecek identifier için boş node oluşturma
    tableNode *tmp;//ekleme headi kaybetmemek icin oluşturulmus boş node
    new_node=(tableNode*)malloc(sizeof(tableNode));//memoryden yer alma
    new_node->ident=id;//yeni gelen değerin isminin eşitlenmesi
    new_node->tmpid=tmpid;//yeni gelen değerin geçici adı
    new_node->next=NULL;
    if(*head==NULL){//eger herhangi bir eleman yoksa ilk gelen identifier nodunu head yapma
    	*head=new_node;
    }else{//eger listede eleman varsa listenin sonuna kadar gidip yeni nodu sona ekleme
    	tmp=*head;
    	while(tmp->next!=NULL){
    		tmp=tmp->next;
    	}
    	tmp->next=new_node;
    }
    
} 

tableNode* Finder(char* id,tableNode *s){//listenin sonuna kadar aranan identifierin olup olmadıgını bulma, eger varsa valuesunda değişiklik yapma ,yoksada zaten null gelecek.
	while(s!=NULL && (strcmp(id,s->ident))){
		s=s->next;
	}
	return s;
}

void printElementsOfTable(tableNode *h){//ilk eleman null degilse yani link liste herhangi bir identifier tanÄ±mlÄ±ysa sonuna kadar gidip tÃ¼m elemanlarÄ± ekrana basma
    while(h!=NULL){
    	printf("%s -> %s\n",h->ident,h->tmpid);
    	h=h->next;
    }
}

