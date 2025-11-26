#include "riscv-macros.h"

TEST_RISCV_BEGIN

li x1, 1;
li x2, 2;
mul x3, x2, x1;
add x5, x2, x1;
add x4, x5, x5;
TEST_CHECK_EQ( x4, 6 );

TEST_RISCV_END