#include "test-framework/unity.h"
#include "long_test_case_name.h"

void setUp(void)
{
}

void tearDown(void)
{
}

static void test_with_veeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrry_looooooooooonnnnnnnnnng_name(void)
{
   TEST_ASSERT_EQUAL_INT(2, add(1, 1));
}

int main(void)
{
   UnityBegin("test_long_test_case_name.c");

   RUN_TEST(
       test_with_veeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrry_looooooooooonnnnnnnnnng_name);

   return UnityEnd();
}
