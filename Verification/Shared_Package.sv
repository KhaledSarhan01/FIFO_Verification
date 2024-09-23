/*
    vsim -voptargs=+acc work.top -cover
    coverage save coverage_db.ucdb -onexit
    run -all
*/
package shared_pkg;
    class FIFO_transaction;
        function new();
            
        endfunction 
    endclass 

    class FIFO_scoreboard;
        function new();
            
        endfunction
    endclass

    class FIFO_coverage;
        function new();
            
        endfunction
    endclass
endpackage