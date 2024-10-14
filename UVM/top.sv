import test_pkg::*;
import uvm_pkg ::*;
`include "uvm_macros.svh"

module top;
    // Clock Generation
        bit clk;
        initial begin
            clk = 1'b1;
            forever begin
            #(1);  clk =~clk; 
            end
        end

    // Interface
        FIFO_if if_handle(clk);

    // Instatiation
        FIFO DUT (if_handle);

    // UVM Environment
        initial begin
            uvm_config_db #(virtual FIFO_if)::set(null,"uvm_test_top","top_FIFO_if",if_handle); 
            run_test("FIFO_test");
        end            
endmodule