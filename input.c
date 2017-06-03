#include<stdio.h>

int var0=8;
int var1=var0+15,var2;
int main(){
	
	if(var0<var1){
		var2=var2-10;
	}else if(var1>var0){
		var2=var1*8;
	}else
		var1=12*8;
	if(var1>var0)
		var2=var1+14;
	else if(var1<var0){
		var2=(12-24)*2;
	}else{
		var2=(15+25)*8;
	}
	return 0;
}
