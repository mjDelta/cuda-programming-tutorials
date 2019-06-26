# cuda-programming-tutorials
This repository includes can be served as an introduction to general-purpose GPU programming for beginners.Here are some definitions: 

**device**: GPU and its memory</br>
**host**: CPU and systematic memory
## How to run test cases?
Below steps take ```test01.cu``` for example.

Step 1: In *Visual Studio's developer command prompt*, run command ```nvcc test01.cu -o test01```.

Step 2: In the *sources* folder, double click on ```test01.exe```.
## Case analysis
### case one: test01.cu
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
