#include "file.h"
void OpFile(char* name){//sadece yazmak icin girilen dosya ismiyle acılan dosya fonksiyonu
	outFile=fopen(name,"w");
}

void Writer(char* x){//gelen her bir stringi dosyaya yazma fonksiyonu
	fprintf(outFile,"%s",x);
}

void CLFile(){//işlemler bittikten sonra dosyayı kapatma foksiyonu
	fclose(outFile);
}
