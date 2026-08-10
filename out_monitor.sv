class out_monitor extends uvm_monitor;
       `uvm_component_utils(out_monitor)
	virtual my_if.OUT_MON vif;	
	uvm_analysis_port #(my_transaction) ap;

	function new(string name,uvm_component parent);
		super.new(name,parent);
		ap=new("ap",this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif))
			`uvm_fatal("NOVIF","vif is not set for monitor");
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.cb_out_mon);
		forever
			collect_output();
	endtask
	task collect_output();
		my_transaction tr;
		begin
			tr=my_transaction::type_id::create("tr");
			@(vif.cb_out_mon);
			tr.data_out=vif.cb_out_mon.data_out; 
			tr.full=vif.cb_out_mon.full; 
			tr.empty=vif.cb_out_mon.empty; 
			//`uvm_info("OUTPUT_MONITOR",$sformatf("Output MONITOR\n%s",tr.sprint()),UVM_NONE)
			`uvm_info("OUTPUT_MONITOR",$sformatf("O_m: data_out=%0h, full=%0b, empty=%0b",vif.cb_out_mon.data_out, vif.cb_out_mon.full, vif.cb_out_mon.empty),UVM_NONE)
			ap.write(tr);
		end
	endtask

endclass

