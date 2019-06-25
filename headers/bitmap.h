
// @Date    : 2019-06-25 10:55:48
// @Author  : Mengji Zhang (zmj_xy@sjtu.edu.cn)

#ifndef __BITMAP_H__
#define __BITMAP_H__

#include <stdio.h>
#include "stdlib.h"
#include <string.h>
#include <math.h>
// #include "bitmap_headers.h"

struct CPUBitmap{
	char *pixels;
	int height,width,size;

	CPUBitmap(int h,int w){
		pixels=new char[w*h*3];
		height=h;
		width=w;
		size=h*w*3;
	}

	~CPUBitmap(){
		delete [] pixels;
	}
	void saveBitmap(char *savePath)
	{
		// Part.1 Create Bitmap File Header
		BITMAPFILEHEADER fileHeader;

		fileHeader.bfType = 0x4D42;
		fileHeader.bfReserved1 = 0;
		fileHeader.bfReserved2 = 0;
		fileHeader.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + size;
		fileHeader.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);

		// Part.2 Create Bitmap Info Header
		BITMAPINFOHEADER bitmapHeader = { 0 };

		bitmapHeader.biSize = sizeof(BITMAPINFOHEADER);
		bitmapHeader.biHeight = height;
		bitmapHeader.biWidth = width;
		bitmapHeader.biPlanes = 3;
		bitmapHeader.biBitCount = 24;
		bitmapHeader.biSizeImage = size;
		bitmapHeader.biCompression = 0; //BI_RGB


		printf("Created file headers.\n");
		// Write to file
		FILE *output = fopen(savePath, "wb");

		if (output == NULL)
		{
			printf("Cannot open file!\n");
		}
		else
		{
			fwrite(&fileHeader, sizeof(BITMAPFILEHEADER), 1, output);
			fwrite(&bitmapHeader, sizeof(BITMAPINFOHEADER), 1, output);
			fwrite(pixels, size, 1, output);
			fclose(output);
		}
	}
};

#endif
