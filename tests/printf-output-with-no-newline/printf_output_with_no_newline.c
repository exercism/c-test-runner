#include <stdio.h>
#include "printf_output_with_no_newline.h"

int add(int x, int y)
{
   printf("no newline");
   return x + y;
}

int sub(int x, int y)
{
   return x - y;
}

int mul(int x, int y)
{
   return x * y;
}
