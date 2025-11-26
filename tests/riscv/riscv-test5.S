//=========================================================================
// riscv-test4.S
//=========================================================================

#include "riscv-macros.h"

        TEST_RISCV_BEGIN

        li x1, 0;
        li x2, 0;
        li x4, 0;
        li x5, 0;
        mul x3, x2, x1;
        add x6, x5, x4;
        add x9, x5, x4;
        add x12, x5, x4;
        add x15, x5, x4;
        add x18, x5, x4;
        mul x3, x2, x1;
        add x6, x5, x4;
        add x9, x5, x4;
        add x12, x5, x4;
        add x15, x5, x4;
        add x18, x5, x4;
        
        TEST_RISCV_END