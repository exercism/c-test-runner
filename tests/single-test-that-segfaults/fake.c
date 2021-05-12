#include "fake.h"

int add(int x, int y)
{
   char *p = 0;

   *p = 123;

   return x + y;
}
