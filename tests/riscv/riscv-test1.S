#include "riscv-macros.h"

TEST_RISCV_BEGIN

li x1, 1;
li x2, 2;
mul x3, x2, x1;
add x3, x2, x1;
nop
TEST_CHECK_EQ( x3, 3 );

TEST_RISCV_END