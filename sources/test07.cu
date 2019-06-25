
// @Date    : 2019-06-25 09:41:33
// @Author  : Mengji Zhang (zmj_xy@sjtu.edu.cn)

#include "cuda.h"
#include "book.h"
#include "../common/cpu_bitmap.h"

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
#define SPHERES 20
#define DIM 1024

int main(){
	for(int i=0;i<10;i++)
		printf("%f\n",rnd(255));
	CPUBitmap bitmap(DIM,DIM);
	// bitmap.display_and_exit();
	getchar();
	return 0;
}