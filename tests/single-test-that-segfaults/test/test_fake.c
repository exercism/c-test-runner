#include <stddef.h>
#include "vendor/unity.h"
#include "../src/fake.h"

void setUp(void)
{
}

void tearDown(void)
{
}

static void test_add(void)
{
   TEST_ASSERT_EQUAL_INT(2, add(1, 1));
}

int main(void)
{
   UnityBegin("test/test_fake.c");

   RUN_TEST(test_add);

   return UnityEnd();
}
