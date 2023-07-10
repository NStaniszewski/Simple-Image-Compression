#include <stdio.h>
#include <stdlib.h>
#include <png.h>
#include <math.h>
#include "image.h"

int write_image(void *image, const char *filename)
{
	FILE *fp = NULL;
	png_structp png_ptr = NULL;
	png_infop info_ptr = NULL;
	png_bytep row = NULL;

	int width = get_width(image);
	int height =get_height(image);
	
	fp = fopen(filename, "wb");
	if (fp == NULL) {
		fprintf(stderr, "Could not open file %s for writing\n", filename);
		return 0;
	}
	
	png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
	if (png_ptr == NULL) {
		fprintf(stderr, "Could not allocate write struct\n");
		return 0;
	}

	info_ptr = png_create_info_struct(png_ptr);
	if (info_ptr == NULL) {
		fprintf(stderr, "Could not allocate info struct\n");
		return 0;
	}
                
	png_init_io(png_ptr, fp);

	png_set_IHDR(png_ptr, info_ptr, width, height,
         8, PNG_COLOR_TYPE_RGBA, PNG_INTERLACE_NONE,
         PNG_COMPRESSION_TYPE_DEFAULT, PNG_FILTER_TYPE_DEFAULT);

	png_write_info(png_ptr, info_ptr);
	row = (png_bytep) calloc(4 * width, sizeof(png_byte));
	int r, c;
	for (r=0 ; r<height ; r++) 
	{
		for (c=0 ; c<width ; c++) 
		{
			double value = get_pixel(image, r, c) * 255;
			if(value < 0) 
			{
				value = 0;
			}
			if(value > 255) 
			{
				 value = 255;
			}			 
			png_byte bp = (png_byte)value;
			png_byte *pixel = &row[c*4];
			pixel[0] = bp;
			pixel[1] = bp;
			pixel[2] = bp;
			pixel[3] = 0xff;
		}
		png_write_row(png_ptr, row);
	}
	free(row);
	png_write_end(png_ptr, NULL);
	png_destroy_write_struct(&png_ptr, &info_ptr);
	fclose(fp);
	return 1;
}
