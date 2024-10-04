import shared_pkg::*;

module top();
    // Clock Generation
        bit clk;
        localparam CLK_PERIOD = 2;
        initial begin
            clk = 1'b0;
            forever begin
                #(CLK_PERIOD/2)clk = ~clk;
            end
        end

    // Interface
        FIFO_if if_handle (clk);

    // Instantiation
        FIFO DUT (if_handle);

    // Testbench
        FIFO_tb Testbench (if_handle);

    // Monitor
        FIFO_MONITOR Monitor (if_handle);
endmodule

