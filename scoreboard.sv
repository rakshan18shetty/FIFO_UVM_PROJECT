class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	uvm_tlm_analysis_fifo #(my_transaction)in_fifo;
	uvm_tlm_analysis_fifo #(my_transaction)out_fifo;

	int TOTAL,MISMATCH,MATCH;
	int status_cnt;
	bit f,full,empty=1;
	bit [`DW-1:0] mem[(2**`AW)-1:0];
	bit [`DW-1:0] d_out;
	bit [`AW-1:0] rd_pt,wr_pt;

	function new(string name, uvm_component parent);
		super.new(name,parent);
		in_fifo=new("in_fifo",this);
		out_fifo=new("out_fifo",this);
	endfunction
	
	task run_phase(uvm_phase phase);
		my_transaction inp_mon_xn,inp_mon_hold;
		my_transaction out_mon_xn;
		forever begin
			fork 
				in_fifo.get(inp_mon_xn);
				out_fifo.get(out_mon_xn);
			join
			if (f==0) begin
				f=1;
				inp_mon_hold=inp_mon_xn;
			end else begin
				ref_model(inp_mon_hold);
				validate_outputs(inp_mon_hold,out_mon_xn);
				inp_mon_hold=inp_mon_xn;
			end
		end
	endtask

	task validate_outputs(my_transaction inp, my_transaction out);
		++TOTAL;
		if(inp.compare(out)) begin
			++MATCH;
			`uvm_info("SCOREBOARD",$sformatf("\nDUT: data_out=%0h, full=%0b, empty=%0b\nREF: data_out=%0h, full=%0b, empty=%0b",out.data_out, out.full, out.empty, inp.data_out, inp.full, inp.empty),UVM_NONE)
		end else begin
			++MISMATCH;
			`uvm_info("SCOREBOARD",$sformatf("\nDUT: data_out=%0h, full=%0b, empty=%0b\nREF: data_out=%0h, full=%0b, empty=%0b\n_______________________________________________________________________________________________________________________________________",out.data_out, out.full, out.empty, inp.data_out, inp.full, inp.empty),UVM_NONE)
		end
	endtask

	function void compare_results();
		`uvm_info("SCOREBOARD",$sformatf("Total clock Cycles Checked:%0d\n Total cycles matched:%0d\n Total cycles failed:%0d",TOTAL,MATCH,MISMATCH),UVM_NONE);
	endfunction

	task ref_model(my_transaction inp);
		if(inp.rst) begin
			full=0;
			empty=1;
			wr_pt=0;
			rd_pt=0;
			d_out=0;
			status_cnt=0;
			for(int i=0;i<2**`AW;i++) mem[i]=0;
		end 
		if(!inp.rst) begin
			if((inp.wr_cs)&&(inp.wr_en)&&(inp.rd_en)&&(inp.rd_cs)) begin
				if(!empty) begin d_out=mem[rd_pt]; rd_pt++; status_cnt--; end
				if(!full) begin mem[wr_pt]=inp.data_in; wr_pt++; status_cnt++; end
			end else if((inp.wr_cs)&&(inp.wr_en)) begin
				if(!full) begin mem[wr_pt]=inp.data_in; wr_pt++; status_cnt++; empty=0; end
			end else if((inp.rd_en)&&(inp.rd_cs)) begin
				if(!empty) begin d_out=mem[rd_pt]; rd_pt++; status_cnt--; full=0; end
			end
		end	
		if (status_cnt==2**`AW) begin full=1; end
		else if (status_cnt==0) begin empty=1; end
		else begin full=0;empty=0; end
		inp.full=full;
		inp.empty=empty;
		inp.data_out=d_out;
	endtask
	
endclass
