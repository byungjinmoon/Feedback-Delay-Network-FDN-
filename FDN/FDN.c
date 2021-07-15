#define _CRT_SECURE_NO_DEPRECATE
#include <stdio.h>
#include <string.h>
#include <math.h>
#define Len_input 44100
#define mdelay1 222
#define mdelay2 400
#define mdelay3 600
#define mdelay4 2000
#define gain 0.9
#define g 0.707
#define FIR_order 5


//matrix 행렬곱. (4 by 1) (1 by 4) 곱.

double matrix_multiply(double *A, double *B, int n){
	double output = 0;
	for (int i = 0; i < n; i++){
		output = output + A[i] * B[i]; 
	}
	return output;
}





void printArray(double *arr, int n)
{
	
	int i;
	for (i = 0; i < n; i++){
		printf("%f", arr[i]);
		printf("\n");

	}

}



int main()
{
	double x[Len_input] = { 0 };
	x[0] = 1;



	int i, j;
	//lossless matrix
	double a1[4] = { 0, 1, 1, 0 };
	double a2[4] = { -1, 0, 0, -1 };
	double a3[4] = { 1, 0, 0, -1 };
	double a4[4] = { 0, 1, -1, 0 };

	//feedback delay를 위한 배열
	double z1[mdelay4] = { 0 };
	double z2[mdelay4] = { 0 };
	double z3[mdelay4] = { 0 };
	double z4[mdelay4] = { 0 };



	double buffer1[FIR_order] = { 0 };
	double buffer2[FIR_order] = { 0 };
	double buffer3[FIR_order] = { 0 };
	double buffer4[FIR_order] = { 0 };

	double filter1[FIR_order] = { -0.0059, 0.0860, 0.7248, 0.0860, -0.0059 };
	double filter2[FIR_order] = { -0.0045, 0.0877, 0.6776, 0.0877, -0.0045 };
	double filter3[FIR_order] = { -0.0039, 0.0884, 0.6556, 0.0884, -0.0039 };
	double filter4[FIR_order] = { -0.0027, 0.0898, 0.6146, 0.0898, -0.0027 };


	//output
	double y[Len_input] = { 0 };

	//4-channel delay값추출 
	double tmp[4] = { 0 };
	//각 channel의 delay값.
	double tmp1;
	double tmp2;
	double tmp3;
	double tmp4;

	for (i = 0; i < Len_input; i++)
	{


		tmp1 = z1[mdelay1 - 1];
		tmp2 = z2[mdelay2 - 1];
		tmp3 = z3[mdelay3 - 1];
		tmp4 = z4[mdelay4 - 1];


		y[i] = x[i] + tmp1 + tmp2 + tmp3 + tmp4;


		tmp[0] = tmp1;
		tmp[1] = tmp2;
		tmp[2] = tmp3;
		tmp[3] = tmp4;



		for (j = mdelay4 - 1; j > 0; j--)
		{
			z1[j] = z1[j - 1];
		}
		for (j = mdelay4 - 1; j > 0; j--)
		{
			z2[j] = z2[j - 1];
		}
		for (j = mdelay4 - 1; j > 0; j--)
		{
			z3[j] = z3[j - 1];
		}
		for (j = mdelay4 - 1; j > 0; j--)
		{
			z4[j] = z4[j - 1];
		}

		z1[0] = matrix_multiply(tmp, a1, 4)*g*gain + x[i];
		z2[0] = matrix_multiply(tmp, a2, 4)*g*gain + x[i];
		z3[0] = matrix_multiply(tmp, a3, 4)*g*gain + x[i];
		z4[0] = matrix_multiply(tmp, a4, 4)*g*gain + x[i];


	}

	printArray(y, Len_input);

	FILE *file;
	file = fopen("test1.txt", "w");
	for (i = 0; i < 44100;i++)
	fprintf(file, "%f   ", y[i] );
	
		fclose(file);

}

