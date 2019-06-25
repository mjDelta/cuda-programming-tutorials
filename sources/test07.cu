
// @Date    : 2019-06-25 09:41:33
// @Author  : Mengji Zhang (zmj_xy@sjtu.edu.cn)

#include "../headers/cuda.h"
#include "../headers/book.h"
#include "../headers/bitmap.h"

#define INF 2e10f
struct Sphere{
	float r,g,b;
	float radius;
	float x,y,z;

	__device__ float hit(float ox,float oy,float *n){
		float dx=ox-x;
		float dy=oy-y;
		if (dx*dx+dy*dy<radius*radius){
			float dz=sqrtf(radius*radius-dx*dx-dy*dy);
			*n=dz/float(radius);
			return dz+z;
		}
		return -INF;
	}
};

#define rnd(x) (x*rand()/float(RAND_MAX))
#define SPHERES 40
#define DIM 1024

__constant__ Sphere s[SPHERES];

__global__ void kernel(char *ptr){
	int x=threadIdx.x+blockIdx.x*blockDim.x;
	int y=threadIdx.y+blockIdx.y*blockDim.y;
	int offset=x+y*blockDim.x*gridDim.x;

	float ox=(x-DIM/2);
	float oy=(y-DIM/2);

	float r=0,g=0,b=0;
	float maxz=-INF;
	for(int i=0;i<SPHERES;i++){
		float n;
		float t=s[i].hit(ox,oy,&n);
		if (t>maxz){
			float fscale=n;
			r=s[i].r*fscale;
			g=s[i].g*fscale;
			b=s[i].b*fscale;
			// maxz=t;
		}
	}
	ptr[offset*3+0]=(int)(r*255);
	ptr[offset*3+1]=(int)(g*255);
	ptr[offset*3+2]=(int)(b*255);
}
int main(){
	cudaEvent_t start,stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start,0);

	CPUBitmap bitmap(DIM,DIM);
	char *savePath="test07.bmp";
	char *dev_bitmap;
	cudaMalloc(&dev_bitmap,bitmap.size);

	Sphere *temp_s=(Sphere*)malloc(sizeof(Sphere)*SPHERES);
	for(int i=0;i<SPHERES;i++){
		temp_s[i].r=rnd(1.f);
		temp_s[i].g=rnd(1.f);
		temp_s[i].b=rnd(1.f);
		temp_s[i].x=rnd(DIM)-DIM/2;
		temp_s[i].y=rnd(DIM)-DIM/2;
		temp_s[i].z=rnd(DIM)-DIM/2;
		temp_s[i].radius=rnd(100.f)+50;
	}
	cudaMemcpyToSymbol(s,temp_s,sizeof(Sphere)*SPHERES);
	free(temp_s);

	dim3 grids(DIM/16,DIM/16);
	dim3 threads(16,16);

	kernel<<<grids,threads>>>(dev_bitmap);

	cudaMemcpy(bitmap.pixels,dev_bitmap,bitmap.size,cudaMemcpyDeviceToHost);

	cudaEventRecord(stop,0);
	cudaEventSynchronize(stop);
	float elapsedTime;
	cudaEventElapsedTime(&elapsedTime,start,stop);
	printf("Time cost:%f",elapsedTime);
	cudaEventDestroy(start);
	cudaEventDestroy(stop);

	bitmap.saveBitmap(savePath);
	cudaFree(dev_bitmap);

	getchar();
	return 0;
}