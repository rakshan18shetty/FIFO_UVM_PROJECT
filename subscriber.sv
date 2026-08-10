class subscriber extends uvm_subscriber#(my_transaction);
  	`uvm_component_utils(subscriber)    
 
  	my_transaction in_mon_xn;   

	covergroup input_cg;  
		wr_cs:coverpoint in_mon_xn.wr_cs;	
		wr_en:coverpoint in_mon_xn.wr_en;	
		rd_cs:coverpoint in_mon_xn.rd_cs;	
		rd_en:coverpoint in_mon_xn.rd_en;	
		data_in:coverpoint in_mon_xn.data_in{bins b1={[0:$]};}
		wr_cs_enxrd_cs_en:cross wr_cs,wr_en,rd_cs,rd_en;
	endgroup:input_cg

	function new(string name, uvm_component parent);
    		super.new(name,parent);
    		input_cg = new();
  	endfunction:new
 
  	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
  	endfunction
 
  	virtual function void write(my_transaction t);     
    		$cast(in_mon_xn,t);
   		input_cg.sample();
    		`uvm_info(get_name,"[SUB]:INPUT RECIEVED",UVM_HIGH)
  	endfunction
 
  	function void report_phase(uvm_phase phase);
    		super.report_phase(phase);
    		`uvm_info(get_name,$sformatf("INPUT COVERAGE = %0f\n",input_cg.get_coverage()),UVM_NONE);
  	endfunction
endclass
