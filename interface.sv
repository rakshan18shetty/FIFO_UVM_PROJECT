import uvm_pkg::*;
`include "uvm_macros.svh"
interface my_if(input logic clk, input logic rst);
	logic wr_cs, rd_cs, wr_en, rd_en, full, empty;
	logic [`DW-1:0] data_in, data_out;	

	clocking cb_drv@(posedge clk);
		default input #1 output #1;
		output wr_cs, rd_cs, wr_en, rd_en, data_in;
	endclocking
	clocking cb_in_mon@(posedge clk);
		default input #1 output #1;
		input rst, wr_cs, rd_cs, wr_en, rd_en, data_in;
	endclocking
	clocking cb_out_mon@(posedge clk);
		default input #1 output #1;
		input data_out, full, empty;
	endclocking

	modport DRV(clocking cb_drv);
	modport IN_MON(clocking cb_in_mon);
	modport OUT_MON(clocking cb_out_mon);

	checkRST:assert property (@(posedge clk) rst |-> ((full==0)&&(empty==1)&&(data_out==0))) else `uvm_error("ASSERTIONS","RST is not working")
	checkAsyncRST:assert property (@(negedge clk) rst |-> ((full==0)&&(empty==1)&&(data_out==0))) else `uvm_error("ASSERTIONS","RST is not working")
	readEmpty:assert property (@(posedge clk) disable iff(rst) ((rd_cs)&&(rd_en)&&(((!wr_en)&&(!wr_cs))||((wr_en)&&(!wr_cs))||((!wr_en)&&(wr_cs)))&&(!rst)&&(empty))|=>((data_out===$past(data_out))&&(empty==1)&&(full==0))) else `uvm_error("ASSERTIONS","Reading an empty fifo is not working")
	writeFull:assert property (@(posedge clk) disable iff(rst)((wr_cs)&&(wr_en)&&(((!rd_en)&&(!rd_cs))||((rd_en)&&(!rd_cs))||((!rd_en)&&(rd_cs)))&&(!rst)&&(full))|=>((data_out===$past(data_out))&&(empty==0)&&(full==1))) else `uvm_error("ASSERTIONS","Writing a full fifo is not working")
	doNothing:assert property (@(posedge clk) disable iff(rst) (!(wr_en&&wr_cs)&&!(rd_en&&rd_cs)&&(!rst))|=>((data_out===$past(data_out))&&(empty==$past(empty))&&(full==$past(full)))) else `uvm_error("ASSERTIONS","Error when not doing anything")
	simul_rd_wr:assert property (@(posedge clk) disable iff(rst) ((wr_cs)&&(wr_en)&&(rd_en)&&(rd_cs)&&(!full)&&(!empty)&&(!rst))|=>((empty==$past(empty))&&(full==$past(full)))) else `uvm_error("ASSERTIONS","Error during simultaneous read and write on a fifo which is not full or empty")
	simul_rd_wr_empty:assert property (@(posedge clk) disable iff(rst) ((wr_cs)&&(wr_en)&&(rd_en)&&(rd_cs)&&(empty)&&(!rst))|=>((empty==!$past(empty))&&(full==$past(full)))) else `uvm_error("ASSERTIONS","Error during simultaneous read and write on a fifo which is not full and empty")
	simul_rd_wr_full:assert property (@(posedge clk) disable iff(rst) ((wr_cs)&&(wr_en)&&(rd_en)&&(rd_cs)&&(full)&&(!rst))|=>((empty==$past(empty))&&(full==$past(full)))) else `uvm_error("ASSERTIONS","Error during simultaneous read and write on a full fifo")
endinterface
