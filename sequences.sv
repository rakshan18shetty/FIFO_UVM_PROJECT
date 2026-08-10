class sequences extends uvm_sequence #(my_transaction);
	
	`uvm_object_utils(sequences)

	function new (string name="seq");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<`n;i++) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			if(req.randomize())
				`uvm_info("SEQ",$sformatf("wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h\n",req.wr_cs, req.rd_cs, req.wr_en, req.rd_en, req.data_in),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
			finish_item(req);
		end
	endtask
endclass

class write_seq extends sequences;
	
	`uvm_object_utils(write_seq)

	function new (string name="write_seq");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<`n;i++) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			if(req.randomize() with {wr_cs==1;wr_en==1;rd_cs==0;rd_en==0;data_in==i[`DW-1:0];})
				`uvm_info("SEQ",$sformatf("wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h\n",req.wr_cs, req.rd_cs, req.wr_en, req.rd_en, req.data_in),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
			finish_item(req);
		end
	endtask
endclass

class read_seq extends sequences;
	
	`uvm_object_utils(read_seq)

	function new (string name="read_seq");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<`n;i++) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			if(req.randomize() with {wr_cs==0;wr_en==0;rd_cs==1;rd_en==1;})
				`uvm_info("SEQ",$sformatf("wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h\n",req.wr_cs, req.rd_cs, req.wr_en, req.rd_en, req.data_in),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
			finish_item(req);
		end
	endtask
endclass

class read_write_seq extends sequences;
	
	`uvm_object_utils(read_write_seq)

	function new (string name="read_write_seq");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<`n;i++) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			if(req.randomize() with {wr_cs==1;wr_en==1;rd_cs==1;rd_en==1;data_in==i[`DW-1:0];})
				`uvm_info("SEQ",$sformatf("wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h\n",req.wr_cs, req.rd_cs, req.wr_en, req.rd_en, req.data_in),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
			finish_item(req);
		end
	endtask
endclass

class rand_seq extends sequences;
	
	`uvm_object_utils(rand_seq)

	function new (string name="rand_seq");
		super.new(name);
	endfunction

	task body();
		for(int i=0;i<`n;i++) begin
			req=my_transaction::type_id::create("req");
			start_item(req);
			if(req.randomize() with {!({wr_cs,wr_en,rd_cs,rd_en} inside {4'b1100,4'b0011,4'b1111});})
				`uvm_info("SEQ",$sformatf("wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h\n",req.wr_cs, req.rd_cs, req.wr_en, req.rd_en, req.data_in),UVM_MEDIUM)
			else 
				`uvm_error("SEQ","SEQ failed");
			finish_item(req);
		end
	endtask
endclass
