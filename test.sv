class test extends uvm_test;
	`uvm_component_utils(test);
	environment env;
	write_seq seq1;
	read_seq seq2;
	read_write_seq seq3;
	rand_seq seq4;

	function new (string name,uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env=environment::type_id::create("env",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		begin
			seq1=write_seq::type_id::create("seq");
			seq1.start(env.a_ag.sqr);
		end
		fork
			begin
				seq1=write_seq::type_id::create("seq");
				seq1.start(env.a_ag.sqr);
			end
			begin
				seq2=read_seq::type_id::create("seq");
				seq2.start(env.a_ag.sqr);
			end
			begin
				seq3=read_write_seq::type_id::create("seq");
				seq3.start(env.a_ag.sqr);
			end
			begin
				seq4=rand_seq::type_id::create("seq");
				seq4.start(env.a_ag.sqr);
			end
		join
		phase.phase_done.set_drain_time(this,20);
		phase.drop_objection(this);
	endtask
	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		env.sc.compare_results();
	endfunction
endclass


