#include "test-framework/unity.h"
#include "multiple_tests_with_segfault.h"

void setUp(void)
{
}

void tearDown(void)
{
}

static void test_add(void)
{
   TEST_ASSERT_EQUAL_INT(3, add(1, 1));
}

static void test_sub(void)
{
   TEST_ASSERT_EQUAL_INT(1, sub(2, 1));
}

static void test_mul(void)
{
   TEST_ASSERT_EQUAL_INT(7, mul(2, 3));
}

int main(void)
{
   UnityBegin("test_multiple_tests_with_segfault.c");

   RUN_TEST(test_add);
   RUN_TEST(test_sub);
   RUN_TEST(test_mul);

   return UnityEnd();
}
