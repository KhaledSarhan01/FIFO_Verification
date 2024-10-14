package test_pkg;
    //import env_pkg::*;
    //import config_pkg::*;
    //import test_sequence_pkg::*;
    import uvm_pkg ::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)
    /*
        alsu_env env;
        alsu_config_obj alsu_config_obj_test;
        reset_sequence rst_seq; 
        sequence_0 seq_0;
        sequence_1 seq_1;
    */
        function new(string name = "FIFO_test",uvm_component parent = null);
            super.new(name,parent);
        endfunction
    /*
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            // Building the Environment
            env = alsu_env :: type_id :: create("env",this);
            rst_seq = reset_sequence :: type_id :: create("rst_seq");
            seq_0   = sequence_0     :: type_id :: create("seq_0");
            seq_1   = sequence_1     :: type_id :: create("seq_1");

            // Passing the Configuraitons
            alsu_config_obj_test = alsu_config_obj::type_id::create("alsu_config_obj_test");
            if(!(uvm_config_db #(virtual alsu_if)::get(this,"","top_alsu_if",alsu_config_obj_test.alsu_config_vif)))
            `uvm_fatal("Test","Unable to get the virtual handle");
            uvm_config_db #(alsu_config_obj)::set(this,"*","test_alsu_obj",alsu_config_obj_test);
        endfunction
        
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            phase.raise_objection(this);
                `uvm_info("TEST RUN","Reset Assert",UVM_LOW);
                rst_seq.start(env.agent.sequencer);
                `uvm_info("TEST RUN","Reset Deassert",UVM_LOW);

                `uvm_info("TEST RUN","Test 1 Sequence begin",UVM_LOW);
                seq_0.start(env.agent.sequencer);
                `uvm_info("TEST RUN","Test 1 Sequence end",UVM_LOW);

                `uvm_info("TEST RUN","Test 2 Sequence begin",UVM_LOW);
                seq_1.start(env.agent.sequencer);
                `uvm_info("TEST RUN","Test 2 Sequence end",UVM_LOW);
            phase.drop_objection(this);
        endtask 
    */    
    endclass
endpackage

