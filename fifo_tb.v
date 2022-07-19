module fifo_tb();

reg clk,rst,wr_en,rd_en;
reg [7:0]data_in;
wire [7:0]data_out;
wire empty,full;
integer i;
parameter T = 10;

fifo DUT(clk,rst,wr_en,rd_en,data_in,data_out,empty,full);


initial 
  begin
   clk = 1'b0;  
//initialized clock to 0 at time = 0 
   forever #(T/2) clk = ~clk;
// toggle after time 5 units as T=10
 end

//initialise task for reset

task reset;
  begin
    rst = 1'b1;
	#T;
//10 units delay
    rst = 1'b0;
  end
endtask

//initialise task for write

task write;
  begin
    wr_en = 1'b1;
	rd_en = 1'b0;
	//#T;
//10 units delay
  end
endtask

//initialise task for read

task read;
  begin
    rd_en = 1'b1;
	wr_en = 1'b0;
	//#T;
//10 units delay
  end
endtask

//initialise task for stimulus

task stimulus(input [7:0]p);
  begin
    @(negedge clk);
	data_in = p;
  end
endtask

initial 
  begin
	  reset;
	  write;
	  for(i=0;i<16;i=i+1)
	    begin
		 stimulus({$random}%256);
		 #T;
		end
	repeat(16)   
	read;
	#T;
	rd_en = 1'b1;
	wr_en = 1'b1;
	repeat(16)
	stimulus({$random}%256);
	#T;
 end
 
initial $monitor($time,"rst=%b,wr_en=%b,rd_en=%b,clk=%b,data_in=%b,data_out=%b,empty=%b,full=%b",rst,wr_en,rd_en,clk,data_in,data_out,empty,full); 
initial #1000 $finish;

endmodule 
