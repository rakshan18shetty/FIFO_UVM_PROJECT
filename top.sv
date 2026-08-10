`include "package.sv"
`include "DUT.sv"
`include "interface.sv"
module top;
	import uvm_pkg::*;
	import pkg::*;
	
	bit clk,rst;
	always #5 clk=~clk;

	initial begin
		rst=0;
		#2 rst=1;
		repeat(5) @ (posedge clk);
		#1 rst=0;
		/*repeat(100) begin
			repeat(150) @(posedge clk);
			#1 rst=1;
			repeat(3) @(posedge clk);
			#1 rst=0;
		end*/
	end

	my_if vif(.clk(clk),.rst(rst));
	syn_fifo m1(.clk(clk),.rst(rst),.wr_cs(vif.wr_cs),.rd_cs(vif.rd_cs),.rd_en(vif.rd_en),.wr_en(vif.wr_en),.data_out(vif.data_out),.data_in(vif.data_in),.empty(vif.empty),.full(vif.full));
	
	initial begin
		uvm_config_db#(virtual my_if)::set(null,"*","vif",vif);
		run_test("test");
	end
endmodule
