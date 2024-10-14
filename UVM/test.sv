package test_pkg;
    import env_pkg::*;
    import config_pkg::*;
    import test_sequence_pkg::*;
    import uvm_pkg ::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
    
        FIFO_env env;
        FIFO_config_obj FIFO_config_obj_test;
        reset_sequence rst_seq; 
        main_sequence main_seq;
        

        function new(string name = "FIFO_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction
    
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Building the Environment
            env = FIFO_env :: type_id :: create("env",this);
            rst_seq  = reset_sequence :: type_id :: create("rst_seq");
            main_seq = main_sequence     :: type_id :: create("main_seq");
           

            // Passing the Configuraitons
            FIFO_config_obj_test = FIFO_config_obj::type_id::create("FIFO_config_obj_test");
            if(!(uvm_config_db #(virtual FIFO_if)::get(this,"","top_FIFO_if",FIFO_config_obj_test.FIFO_config_vif)))
            `uvm_fatal("Test","Unable to get the virtual handle");
            uvm_config_db #(FIFO_config_obj)::set(this,"*","test_FIFO_obj",FIFO_config_obj_test);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                `uvm_info("TEST RUN","Reset Assert",UVM_LOW);
                rst_seq.start(env.agent.sequencer);
                `uvm_info("TEST RUN","Reset Deassert",UVM_LOW);

                `uvm_info("TEST RUN","Main Test Sequence begin",UVM_LOW);
                main_seq.start(env.agent.sequencer);
                `uvm_info("TEST RUN","Main Test Sequence end",UVM_LOW);

                `uvm_info("TEST END",$sformatf("SCOREBOARD: Correct = %0d , Error = %0d",env.scoreboard.correct_count,env.scoreboard.error_count),UVM_LOW);
            phase.drop_objection(this);
        endtask 
    endclass
endpackage

