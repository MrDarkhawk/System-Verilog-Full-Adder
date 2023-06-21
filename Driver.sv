class driver;
	int no_transactions;
	virtual intf vif;
	mailbox gen2driv;
	function new(virtual intf vif,mailbox gen2driv);
		this.vif = vif;
		this.gen2driv = gen2driv;
	endfunction 
	
	task reset;
		wait(vif.reset);
		$display("[DRIVER]-----RESET STARTED-----");
		vif.a <= 0;
		vif.b <= 0;
		vif.valid <= 0;
		wait(!vif.reset);
		$display("[DRIVER]-----RESET ENDED-------");
	endtask 
	
	task main;
		forever begin 
			transaction trans;
			gen2driv.get(trans);
			@(posedge vif.clk);
			vif.valid <= 1;
			vif.a <= trans.a;
			vif.b <= trans.b;
			@(posedge vif.clk);
			vif.valid <= 0;
			trans.c <= vif.c;
			@(posedge vif.clk);
			trans.display("[DRIVER]");
			no_transactions++;
		end
	endtask 
endclass 
