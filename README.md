# cuda-programming-tutorials
This repository includes can be served as an introduction to general-purpose GPU programming for beginners.Here are some definitions: 

**device**: GPU and its memory</br>
**host**: CPU and systematic memory
## How to run test cases?
Below steps take ```test01.cu``` for example.

Step 1: In *Visual Studio's developer command prompt*, run command ```nvcc test01.cu -o test01```.

Step 2: In the *sources* folder, double click on ```test01.exe```.
## Case analysis
### Case one: test01.cu
```
__global__ void add(int *a,int *b,int *c){
	int tid=blockIdx.x;
	if(tid<N){
		c[tid]=a[tid]+b[tid];
	}
}
```
```__global__``` tells the compiler that this function should be compiled in device, not in host. ```blockIdx.x``` assigns the index of the block. 

```cudaMalloc``` is similar to ```malloc``` in standard C. And it means allocate memory on device.

```cudaMemcpy``` means copy memory between host and device. ```cudaMemcpyHostToDeivce``` and ```cudaMemcpyDeviceToHost``` decide the copy direction.

```add<<<para1,para2>>>``` assigns the blocks and threads by para1 and para2.

```cudaFree``` is similar to ```free``` in standard C. It means free the cuda memory.

### Case two: test05.cu
```
__global__ void dot(float *a, float *b,float *c){
	__shared__ float cache[threadsPerBlock];
	int tid=threadIdx.x+blockIdx.x*blockDim.x;
	int cacheIdx=threadIdx.x;

	float temp=0.;
	while(tid<N){
		temp+=a[tid]*b[tid];
		tid+=blockDim.x*gridDim.x;
	}
	cache[cacheIdx]=temp;
	__syncthreads();

	int i=blockDim.x/2;
	while(i!=0){
		if (cacheIdx<i){
			cache[cacheIdx]+=cache[cacheIdx+i];
		}
		__syncthreads();
		i/=2;
	}
	if (cacheIdx==0){
		c[blockIdx.x]=cache[0];
	}
}
```

```__shared__``` assigns the variable to be a shared memory. Every block will create a copy of cache, and this cache can be shared among the threads in the block. So, it is helpful in threads communication.

```__syncthreads()``` means after all the threads in the same block have run the above codes, the below codes can be ran by threads respectively.

### Case three: test07.cu
```
__constant__ Sphere s[SPHERES];
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
```
```__constant__``` means constant memory. Due to the high computation power of GPU, the I/O between CPU and GPU influences the computation speed greatly. Make the memory be GPU's memory rather than improve the I/O speed. And constant memory makes 16 threads share a same I/O. So, the memory flow will decrease by 94% (15/16) compared to the global memory.

```cudaMemcpyToSymbol``` is specifically designed for constant memory. It is similar to ```cudaMemcpy```.
