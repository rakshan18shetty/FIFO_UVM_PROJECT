class my_transaction extends uvm_sequence_item;
	rand logic wr_cs, rd_cs, wr_en, rd_en;
	rand logic [`DW-1:0] data_in;	
	logic full, empty;
	logic [`DW-1:0] data_out;	

	bit rst;

	function new (string name="my_trans");
		super.new(name);
	endfunction

	constraint wr_c{ soft wr_cs inside {0,1};}
	constraint rd_c{ soft rd_cs inside {0,1};}
	constraint wr_e{ soft wr_en inside {0,1};}
	constraint rd_e{ soft rd_en inside {0,1};}
	constraint data_i{ soft data_in dist { 0:=100, [1:(2**`DW)-2]:=1, (2**`DW)-1:=100};}

	`uvm_object_utils_begin(my_transaction)
		`uvm_field_int(rst, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(wr_cs, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(rd_cs, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(wr_en, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(rd_en, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(data_in, UVM_ALL_ON | UVM_NOCOMPARE)
		`uvm_field_int(full, UVM_ALL_ON)
		`uvm_field_int(empty, UVM_ALL_ON)
		`uvm_field_int(data_out, UVM_ALL_ON)
	`uvm_object_utils_end
endclass

