class driver extends uvm_driver#(my_transaction);
	`uvm_component_utils(driver)
	virtual my_if.DRV vif;

	function new(string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif))
			`uvm_fatal("NOVIF", "vif not found in driver")
	endfunction
	
	task run_phase(uvm_phase phase);
		forever begin
			seq_item_port.get_next_item(req);
			drive(req);
			seq_item_port.item_done();
		end
	endtask
	task drive(my_transaction tr);
		begin
			//`uvm_info("DRIVER",$sformatf("DRV:\n%s",tr.sprint()),UVM_NONE)
			@(vif.cb_drv);
			vif.cb_drv.wr_cs<=tr.wr_cs; 
			vif.cb_drv.rd_cs<=tr.rd_cs; 
			vif.cb_drv.wr_en<=tr.wr_en; 
			vif.cb_drv.rd_en<=tr.rd_en; 
			vif.cb_drv.data_in<=tr.data_in; 
			`uvm_info("DRIVER",$sformatf("DRV: wr_cs=%0b, rd_cs=%0b, wr_en=%0b, rd_en=%0b, data_in=%0h ",tr.wr_cs, tr.rd_cs, tr.wr_en, tr.rd_en, tr.data_in),UVM_NONE)
		end
	endtask
endclass

