
package scoreboard_pkg;
    import seq_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    
    class FIFO_Scoreboard extends uvm_scoreboard;
        `uvm_component_utils(FIFO_Scoreboard);
        uvm_analysis_port #(FIFO_seq_item) sb_aport;
        FIFO_seq_item seq_item;
        uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
        // Counters
            int correct_count = 0;
            int error_count = 0;
        // Outputs
            logic [FIFO_WIDTH-1:0] data_out_ref;
        //---------- Functions ----------//    
        function new(string name = "FIFO_Scoreboard",uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_aport = new("sb_aport",this);
            sb_fifo  = new("sb_fifo",this);
        endfunction
        
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_aport.connect(sb_fifo.analysis_export);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(seq_item);
                if (seq_item.data_out != data_out_ref) begin
                    `uvm_error("Test Fail",$sformatf("DUT Interface: %s , Correct Output: data_out_ref = %0d"
                                    ,seq_item.convert2string(),data_out_ref));    
                    error_count = error_count +1;
                end else begin
                    `uvm_info("Scoreboard",$sformatf("data_out = %d , data_out_ref = %d",seq_item.data_out,data_out_ref),UVM_HIGH);
                    correct_count = correct_count + 1;
                end
            end
        endtask

    //------------------ Tasks ----------------// 
            localparam max_fifo_addr = $clog2(FIFO_DEPTH);
            reg [FIFO_WIDTH-1:0] mem_ref [FIFO_DEPTH-1:0];
            reg [max_fifo_addr-1:0] wr_ptr_ref, rd_ptr_ref;
            reg [max_fifo_addr:0] count_ref;

        task ref_model(FIFO_seq_item seq_item);
            if(!(seq_item.rst_n))begin
                for (int i = 0; i < FIFO_DEPTH; i++ ) begin
                    mem_ref[i] <= 0;
                end
                data_out_ref <= 0;
                rd_ptr_ref <= 0;
                wr_ptr_ref <= 0;
                count_ref <= 0;
            end else begin
                // Input Logic
                    if (seq_item.wr_en && count_ref < FIFO_DEPTH) begin
                        mem_ref[wr_ptr_ref] <= seq_item.data_in;
                        wr_ptr_ref <= wr_ptr_ref +1;
                    end 
                
                // Output Logic    
                    if (seq_item.rd_en && count_ref != 0) begin
                        data_out_ref <= mem_ref[rd_ptr_ref];
                        rd_ptr_ref <= rd_ptr_ref +1;
                    end 

                // Counter Logic    
                    if	( ({seq_item.wr_en, seq_item.rd_en} == 2'b10) && !seq_item.full) 
                        count_ref <= count_ref + 1;
                    else if ( ({seq_item.wr_en, seq_item.rd_en} == 2'b01) && !seq_item.empty)
                        count_ref <= count_ref - 1;
            end
        endtask
    endclass
endpackage