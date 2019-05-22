
// @Date    : 2019-05-19 21:26:29
// @Author  : Mengji Zhang (zmj_xy@sjtu.edu.cn)

#include <iostream>
#include <stdio.h>

#include "test.h"
#define N 10
__global__ void add(int *a,int *b,int *c){
	int tid=blockIdx.x;
	if(tid<N){
		c[tid]=a[tid]+b[tid];
	}
}

int main(void){
	int a[N],b[N],c[N];
	int *dev_a,*dev_b,*dev_c;
	
	HANDLE_ERROR(cudaMalloc((void**)&dev_a,N*sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_b,N*sizeof(int)));
	HANDLE_ERROR(cudaMalloc((void**)&dev_c,N*sizeof(int)));

	//assign values for a and b in CPU
	for(int i=0;i<N;i++){
		a[i]=-i;
		b[i]=i*i;
	}

	//copy a and b to GPU
	HANDLE_ERROR(cudaMemcpy(dev_a,a,N*sizeof(int),cudaMemcpyHostToDevice));
	HANDLE_ERROR(cudaMemcpy(dev_b,b,N*sizeof(int),cudaMemcpyHostToDevice));

	//run on GPU
	add<<<N,1>>>(dev_a,dev_b,dev_c);

	//copy result from GPU to CPU
	HANDLE_ERROR(cudaMemcpy(c,dev_c,N*sizeof(int),cudaMemcpyDeviceToHost));

	//result display
	for(int i=0;i<N;i++){
		printf("%d+%d=%d\n",a[i],b[i],c[i]);
	}

	//free cuda memory
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	printf("The program is done. Enter anything to exit.");
	getchar();
	return 0;

}


