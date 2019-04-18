# libfacedetection

This is an open source library for CNN-based face detection in images. The CNN model has been converted to static variables in C source files. The source code does not depend on any other libraries. What you need is just a C++ compiler. You can compile the source code under Windows, Linux, ARM and any platform with a C++ compiler.

SIMD instructions are used to speed up the detection. You can enable AVX2 if you use Intel CPU or NEON for ARM.

The model file has also been provided in directory ./models/.

examples/libfacedetectcnn-example.cpp shows how to use the library.

![Examples](/images/cnnresult.png "Detection example")

## How to use the code

You can copy the files in directory src/ into your project, and compile them as the other files in your project. The source code is written in standard C/C++. It should be compiled at any platform which support C/C++.

Some tips:
* Please add -O3 to turn on optimizations when you compile the source code using g++.
* Please choose 'Maximize Speed/-O2' when you compile the source code using Microsoft Visual Studio.
* ENABLE_INT8=ON is recommended for ARM, but it is not recommended for Intel CPU since it cannot gain better speed sometime even worse.
* The source code can only run in single thread. If you want to run parally, you can call the face detection function in multiple threads. Yes, multiple-thread is complex in programming.
* If you want to achieve best performance, you can run the model (not the source code) using OpenVINO on Intel CPU or Tengine on ARM CPU.

If you want to compile and run the example, you can create a build folder first, then run the command:

```
mkdir build; cd build; rm -rf *
```

### Use Tengine to Speedup the detection on ARM
The model has been added to [Tengine](https://github.com/OAID/Tengine). Tengine, developed by OPEN AI LAB, is a lite, high-performance, and modular inference engine for embedded device. 

The model in Tengine can run faster than the C++ source code here because Tengine has been optimized according to ARM CPU. There are detailed manual and example at Tengine web site: https://github.com/OAID/Tengine/tree/master/examples/YuFaceDetectNet

### Cross build for aarch64
1. Set cross compiler for aarch64 (please refer to aarch64-toolchain.cmake)
2. Set opencv path since the example code depends on opencv

```
cmake \
    -DENABLE_INT8=ON \
    -DENABLE_NEON=ON \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DCMAKE_TOOLCHAIN_FILE=../aarch64-toolchain.cmake \
     ..

make
```

### Native build for avx2
```
cmake \
    -DENABLE_AVX2=ON \
    -DCMAKE_BUILD_TYPE=RELEASE \
    -DDEMO=ON \
     ..

make
```

## CNN-based Face Detection on Windows

| Method             |Time          | FPS         |Time          | FPS         |
|--------------------|--------------|-------------|--------------|-------------|
|                    |  X64         |X64          |  X64         |X64          |
|                    |Single-thread |Single-thread|Multi-thread  |Multi-thread |
|OpenCV Haar+AdaBoost (640x480)|   --         | --          | 12.33ms      |   81.1      |
|cnn (CPU, 640x480)  |  64.21ms     | 15.57       | 15.59ms      |   64.16     |
|cnn (CPU, 320x240)  |  15.23ms     | 65.68       |  3.99ms      |  250.40     |
|cnn (CPU, 160x120)  |   3.47ms     | 288.08      |  0.95ms      | 1052.20     |
|cnn (CPU, 128x96)   |   2.35ms     | 425.95      |  0.64ms      | 1562.10     |

* OpenCV Haar+AdaBoost runs with minimal face size 48x48
* Face detection only, and no landmark detection included
* Minimal face size ~12x12
* Intel(R) Core(TM) i7-7700 CPU @ 3.6GHz

## CNN-based Face Detection on ARM Linux (Raspberry Pi 3 B+)

| Method             |Time          | FPS         |Time          | FPS         |
|--------------------|--------------|-------------|--------------|-------------|
|                    |Single-thread |Single-thread|Multi-thread  |Multi-thread |
|cnn (CPU, 640x480)  |  512.04ms    |  1.95       |  174.89ms    |   5.72      |
|cnn (CPU, 320x240)  |  123.47ms    |  8.10       |   42.13ms    |  23.74      |
|cnn (CPU, 160x120)  |   27.42ms    | 36.47       |    9.75ms    | 102.58      |
|cnn (CPU, 128x96)   |   17.78ms    | 56.24       |    6.12ms    | 163.50      |

* Face detection only, and no landmark detection included.
* Minimal face size ~12x12
* Raspberry Pi 3 B+, Broadcom BCM2837B0, Cortex-A53 (ARMv8) 64-bit SoC @ 1.4GHz


## Author
* Shiqi Yu, <shiqi.yu@gmail.com>

## Contributors
Some contributors are listed [here](https://github.com/ShiqiYu/libfacedetection/graphs/contributors). 

The contributors who are not listed at GitHub.com:
* Jia Wu (吴佳)
* Dong Xu (徐栋)
* Shengyin Wu (伍圣寅)

## Acknowledgment
The work is partly supported by the Science Foundation of Shenzhen (Grant No. JCYJ20150324141711699 and 20170504160426188).

头文件：facedetect-dll.h
四个API的参数是一致的，下面介绍下函数含义：


unsigned char * result_buffer		// 缓冲区,大小必须为0x20000个字节。buffer memory for storing face detection results, !!its size must be 0x20000 Bytes!!
unsigned char * gray_image_data		// 单通道灰色图像(YUV数据中的Y)
int width				// 单通道灰色图像的宽度
int height				// 单通道灰色图像的高度
int step				// 单通道灰色图像的step参数，同单通道灰色图像的宽度,input image, it must be gray (single-channel) image!
float scale				// 每次缩小图像的比例，不建议修改(default: 1.2f)，scale factor for scan windows
int min_neighbors			// 检测出的人脸框属性,越大表示是人脸可能性越大.小于min_neighbors的人脸框将被过滤掉。
					// how many neighbors each candidate rectangle should have to retain it
int min_object_width			// 数据源中近乎最小的人脸大小,若存在人脸大小比此数据还小的人脸则忽略不检测.
					// Minimum possible face size. Faces smaller than that are ignored.
int max_object_width = 0		// 数据源中近乎最大的人脸大小,若存在人脸大小比此数据还大的则忽略不检测.若此数据被指定为0, 程序会自动确认可能的最大的人脸大小.
					// Maximum possible face size.Faces larger than that are ignored.It is the largest posible when max_object_width = 0.
int doLandmark = 0			// 是否进行人脸特征点检测   0: 不进行人脸特征点检测1: 进行人脸特征点检测         landmark detection

下面介绍一下四个API的不同：

正面人脸检测，无法检测“侧视人脸”和“单面人脸”
int * facedetect_frontal(…)
正面视频监控人脸检测，无法检测“侧视人脸”和“单面人脸”,可以检测光线不好情况下的人脸
int *facedetect_frontal_surveillance(…)
多视图人脸检测，无法检测“单面人脸”，但可以检测“侧视人脸”,可以检测多张人脸,比facedetect_frontal()检测时间长
int *facedetect_multiview(…)
多视图增强人脸检测，无法检测“单面人脸”，但可以检测“侧视人脸”, 可以检测多张人脸;比facedetect_multiview()效果好,但是检测时间长
int *facedetect_multiview_reinforce(…)

pResults为空代表检测失败。如果pResults不为空，*pResults为0，代表检测成功但未检测到人脸；如果pResults不为空，*pResults不为0，*pResults代表检测到的人脸个数。

具体人脸属性参数请看下面代码：


if (NULL == pResults)
{
	//printf("---Detect Failed !\n");
}
else
{
	if (0 == (*pResults))
	{	//No Face
		//printf("---Detect success, but no face here.\n");
	}
	else
	{
		//Got Face,
		//得到每个人脸的位置及宽度高度，眼睛关注角度（左正右负，正脸角度为0），置信度（越大人脸的可能性越大）
		for (int i = 0; i < (pResults ? *pResults : 0); i++)
		{
			short * p = ((short*)(pResults + 1)) + 142 * i;
			FaceFrame stFaceFrame;
			//得到人脸的位置及宽度高度
			stFaceFrame.x = p[0];
			stFaceFrame.y = p[1];
			stFaceFrame.width = p[2];
			stFaceFrame.height = p[3];
 
			//置信度（越大人脸的可能性越大）
			stFaceFrame.neighbors = p[4];
			//眼睛关注角度（左正右负，正脸角度为0）
			stFaceFrame.angle = p[5];
 
			// 得到人脸的特征点
			for (int j = 0; j < 68; j++)
			{
				//printf("FaceID : %d, Point No : %d, x = %d, y = %d\n", i, j, 
				//(int)p[6 + 2 * j], (int)p[6 + 2 * j + 1]);
			}
		}
	}
}



