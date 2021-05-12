#include "multiple_tests_with_test_output.h"

#include <stdio.h>

int add(int x, int y)
{
   printf("test\n");
   return x + y;
}

int sub(int x, int y)
{
   printf("x: %d, y: %d\n", x, y);
   return x - y;
}

int mul(int x, int y)
{
   return x * y;
}
