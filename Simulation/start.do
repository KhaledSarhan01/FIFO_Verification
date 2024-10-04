vlib work
vlog -f sourcefile.txt +cover -covercells +define+ASSERTIONS
vsim -voptargs=+acc work.top -cover
coverage save coverage_db.ucdb -onexit
add wave /top/if_handle/*
add wave -position insertpoint  \
sim:/top/DUT/wr_ptr \
sim:/top/DUT/rd_ptr \
sim:/top/DUT/count
add wave /top/DUT/RST_COUNT /top/DUT/RST_RDPTR /top/DUT/RST_WRPTR
add wave /top/DUT/ALMOSTEMPTY_ASSERT /top/DUT/ALMOSTFULL_ASSERT /top/DUT/COUNT_DOWN_ASSERT /top/DUT/COUNT_UP_ASSERT /top/DUT/EMPTY_ASSERT /top/DUT/FULL_ASSERT /top/DUT/OVERFLOW_ASSERT /top/DUT/RDPTR_ASSERT /top/DUT/UNDERFLOW_ASSERT /top/DUT/WRACK_ASSERT /top/DUT/WRPTR_ASSERT
run -all
