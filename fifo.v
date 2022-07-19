module fifo(clk,rst,wr_en,rd_en,data_in,data_out,empty,full);

parameter FIFO_WIDTH = 8,
          FIFO_DEPHT = 16,
		  ADDR_SIZE = 4;
		  
input clk,rst,wr_en,rd_en;
input [FIFO_WIDTH-1:0]data_in;
output reg [FIFO_WIDTH-1:0]data_out;
output  empty,full;

//defining the memory size	and counters for read and write
	  
reg [FIFO_WIDTH-1:0]mem[FIFO_DEPHT-1:0];
reg [ADDR_SIZE-1:0]wr_ptr,rd_ptr;
reg [ADDR_SIZE:0]fifo_count;

integer i;

//reset logic

always @(posedge clk)
  begin
    if(rst)
	 begin
	  for(i=0;i<FIFO_DEPHT;i=i+1)
	   mem[i] <= 8'd0;
	   {rd_ptr, wr_ptr} <= 8'd0;
       data_out <= 8'd0;
     end
	 
    else
     begin
	 
	 //performs write operation
	 
       if(wr_en && !full)
	    begin
		  mem[wr_ptr] <= data_in;
		  wr_ptr <= wr_ptr+1'b1;
	    end
	 
	 //performs read operation
	 
	   if(rd_en && !empty) 
		  begin
		  data_out <= mem[rd_ptr];
		  rd_ptr <= rd_ptr+1'b1;
		  end
     end
end

// fifo_count for empty and full

always@ (posedge clk)
 begin
  if(rst)
   fifo_count <= 0;
    else 
	begin
	 case ({wr_en,rd_en})
	  2'b00 : fifo_count <= fifo_count;
	  2'b01 : fifo_count <= (fifo_count==0) ? 0 : fifo_count-1;
	  2'b10 : fifo_count <= (fifo_count==16) ? 16 : fifo_count +1;
	  2'b11 : fifo_count <= fifo_count;
	  default : fifo_count <= fifo_count;
	  endcase
	  end
	  end
	  
//assign output

assign empty =(fifo_count==0);
assign full =(fifo_count==16);
   
endmodule 
   
        	   

