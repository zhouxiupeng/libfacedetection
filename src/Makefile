#./src/Makefile
FLAGS = -fPIC -c -std=c++11 -O3 -mavx -mfma #编译选项，在linux上编译

OBJ = facedetectcnn.o                       #编译的中间文件
OBJ += facedetectcnn-floatdata.o
OBJ += facedetectcnn-int8data.o 
OBJ += facedetectcnn-model.o  

SO = libfacedetectcnn.so                    #编成的so库
 #添加需要的文件就行，类似内核编译那种

%.o:%.cpp
	$(CC)  $(FLAGS) $^

all:$(OBJ)
	@echo "Compile..."
	g++ -shared -fpic -o $(SO) $(OBJ)
	@echo "End"

clean:
	-rm $(OBJ) *.so
