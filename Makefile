NVCC = /usr/local/cuda/bin/nvcc

addUpVector:addUpVector.o
	$(NVCC) addUpVector.o -o addUpVector

addUpVector.o:addUpVector.cu
	$(NVCC) -c addUpVector.cu

clean:
	rm *.o addUpVector
