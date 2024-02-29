#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void addUpVector(int* input, int N) {
	int threadIndex = threadIdx.x;
	for (int gait=1; gait<N; gait*=2) {
		if(threadIndex % (2*gait) == 0 && gait < N)
			input[threadIndex]+= input[threadIndex + gait];
		__syncthreads();
	}
}

int main(){

	int length = 1000;

	int host_v[length];
	for (int i = 0; i < length; i++) {
		host_v[i] = 1;
	}
	
	int* device_v;
	cudaMalloc((void**)&device_v, length*sizeof(int));
	cudaMemcpy(device_v, host_v, length*sizeof(int),cudaMemcpyHostToDevice);

	dim3 blockSize(length);
	dim3 gridSize(1);

	addUpVector<<<gridSize,blockSize>>>(device_v, length);

	cudaMemcpy(host_v, device_v, length*sizeof(int),cudaMemcpyDeviceToHost);

	printf("%d \n\n\n", host_v[0]);

	cudaFree(device_v);

	return 0;

}
