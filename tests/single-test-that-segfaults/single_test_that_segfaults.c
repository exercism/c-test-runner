#include "single_test_that_segfaults.h"

int add(int x, int y)
{
   char *p = 0;

   *p = 123;

   return x + y;
}
