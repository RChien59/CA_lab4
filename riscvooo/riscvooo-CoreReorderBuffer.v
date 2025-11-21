
//=========================================================================
// 5-Stage RISCV Reorder Buffer
//=========================================================================

`ifndef RISCV_CORE_REORDERBUFFER_V
`define RISCV_CORE_REORDERBUFFER_V

`include "riscvooo-InstMsg.v"

module riscv_CoreReorderBuffer
(
  input               clk,
  input               reset,

  input               rob_alloc_req_val,
  output              rob_alloc_req_rdy,
  input  [ 4:0]       rob_alloc_req_preg,
  output [`LOG_S-1:0] rob_alloc_resp_slot,

  input               rob_fill_val,
  input  [`LOG_S-1:0] rob_fill_slot,

  output              rob_commit_wen,
  output [`LOG_S-1:0] rob_commit_slot,
  output [ 4:0]       rob_commit_rf_waddr
);
  // original
  // assign rob_alloc_req_rdy   = 1'b1;
  // assign rob_alloc_resp_slot = `LOG_S'b0;
  // assign rob_commit_wen      = 1'b0;
  // assign rob_commit_rf_waddr = 5'b0;
  // assign rob_commit_slot     = `LOG_S'b0;

  reg [`LOG_S-1:0] rob_head_ptr;
  reg [`LOG_S-1:0] rob_tail_ptr;
  reg [`LOG_S-1:0] rob_entry_count;

  wire rob_empty = (rob_entry_count == `LOG_S'b0);
  wire rob_full  = (rob_entry_count == `SLOTS - 1);

  reg valid [0:`SLOTS - 1];
  reg pending [0:`SLOTS - 1];
  reg [4:0] preg [0:`SLOTS - 1];

  integer i;

  always @( posedge clk ) begin
    if ( reset ) begin
      rob_head_ptr <= `LOG_S'b0;
      rob_tail_ptr <= `LOG_S'b0;
      for (i = 0; i < 32; i = i + 1) begin
        valid[i]   <= 1'b0;
        pending[i] <= 1'b0;
        preg[i]    <= 5'b0;
      end
    end
    else begin
      for (i = 0; i < 32; i = i + 1) begin
        if (!rob_full && rob_alloc_req_val && (i == rob_tail_ptr)) begin
          valid[i]   <= 1'b1;
          pending[i] <= 1'b1;
          preg[i]    <= rob_alloc_req_preg;
          rob_tail_ptr <= (rob_tail_ptr == (`SLOTS - 1)) ? 4'd0 : (rob_tail_ptr + 1);
        end
        else if (rob_fill_val && (i == rob_fill_slot)) begin
          pending[i] <= 1'b0;
        end
        else if (valid[rob_head_ptr] && !pending[rob_head_ptr] && (i == rob_head_ptr)) begin
          valid[i]   <= 1'b0;
          rob_head_ptr <= (rob_head_ptr == (`SLOTS - 1)) ? 4'd0 : (rob_head_ptr + 1);
        end
      end
    end
  end

  always @( posedge clk ) begin
    if ( reset ) begin
      rob_entry_count <= `LOG_S'b0;
    end
    else begin
      case ({!rob_full && rob_alloc_req_val, valid[rob_head_ptr] && !pending[rob_head_ptr]})
        2'b10: begin
          rob_entry_count <= rob_entry_count + 1;
        end
        2'b01: begin
          rob_entry_count <= rob_entry_count - 1;
        end
        default: rob_entry_count <= rob_entry_count;
      endcase
    end
  end

  assign rob_alloc_req_rdy   = !rob_full;
  assign rob_alloc_resp_slot = rob_tail_ptr;
  assign rob_commit_wen      = valid[rob_head_ptr] && !pending[rob_head_ptr] && !rob_empty;
  assign rob_commit_slot     = rob_head_ptr;
  assign rob_commit_rf_waddr = preg[rob_head_ptr];

  // wire valid0 = valid[0];
  // wire valid1 = valid[1];
  // wire valid2 = valid[2];
  // wire valid3 = valid[3];
  // wire valid4 = valid[4];
  // wire valid5 = valid[5];
  // wire valid6 = valid[6];
  // wire valid7 = valid[7];
  // wire valid8 = valid[8];
  // wire valid9 = valid[9];
  // wire valid10 = valid[10];
  // wire valid11 = valid[11];
  // wire valid12 = valid[12];
  // wire valid13 = valid[13];
  // wire valid14 = valid[14];
  // wire valid15 = valid[15];

  // wire pending0 = pending[0];
  // wire pending1 = pending[1];
  // wire pending2 = pending[2];
  // wire pending3 = pending[3];
  // wire pending4 = pending[4];
  // wire pending5 = pending[5];
  // wire pending6 = pending[6];
  // wire pending7 = pending[7];
  // wire pending8 = pending[8];
  // wire pending9 = pending[9];
  // wire pending10 = pending[10];
  // wire pending11 = pending[11];
  // wire pending12 = pending[12];
  // wire pending13 = pending[13];
  // wire pending14 = pending[14];
  // wire pending15 = pending[15];

endmodule

`endif
