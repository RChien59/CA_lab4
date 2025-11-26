//=========================================================================
// riscv-test4.S
//=========================================================================

#include "riscv-macros.h"

        TEST_RISCV_BEGIN

        li x1, 0;
        li x2, 0;
        li x4, 0;
        li x6, 0;
        li x7, 0;
        li x9, 0;
        li x10, 0;
        li x12, 0;
        li x13, 0;
        mul x3, x2, x1;
        lw  x5, 0(x4);
        add x8, x7, x6;
        add x11, x10, x9;
        mul x14, x13, x12;
        mul x3, x2, x1;
        lw  x5, 0(x4);
        add x8, x7, x6;
        add x11, x10, x9;
        mul x14, x13, x12;

        TEST_RISCV_END