#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <cuda_runtime.h>

__global__ void addUpVector(int* input, int N) {
	int threadIndex = threadIdx.x + threadIdx.x;

	for (int gait=1; gait<N; gait+=gait) {
		if(threadIndex % (2*gait) == 0)
			input[threadIndex]+= input[threadIndex + gait];
		else
			break;
	}
	__syncthreads();

}

int main(){

	int threads = 501;
	int length = threads * 2;

	int host_v[length];
	for (int i = 0; i < length; i++) {
		host_v[i] = 1;
	}
	
	int* device_v;
	cudaMalloc((void**)&device_v, length*sizeof(int));
	cudaMemcpy(device_v, host_v, length*sizeof(int),cudaMemcpyHostToDevice);

	dim3 blockSize(threads);
	dim3 gridSize(1);

	addUpVector<<<gridSize,blockSize>>>(device_v, length);

	cudaMemcpy(host_v, device_v, length*sizeof(int),cudaMemcpyDeviceToHost);

	printf("%d", host_v[0]);

	cudaFree(device_v);

	return 0;

}

