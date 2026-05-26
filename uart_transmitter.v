module uart_transmitter(
    input clk, reset, baud_tick, tx_start,
    input [7:0] data_in,
    output wire dout
    );

parameter idle  = 2'b00,
          start = 2'b01,
          data  = 2'b10,
          stop  = 2'b11;

reg [1:0] state, next_state;
reg [3:0] count;
reg [7:0] shift_reg;

always @(posedge clk or negedge reset) begin
    if(!reset) 
        state <= idle;
    else       
        state <= next_state;
end

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        count <= 0;
    end
    else if(state == idle || state==start) begin
        count <= 0;
    end
    else if(state == data && baud_tick) begin
        count <= count + 1;
    end
end
   
wire bit_count = (count == 4'd7 && baud_tick); 

always @(posedge clk or negedge reset) begin
    if(!reset) begin
        shift_reg <= 0;
    end
    else begin
        if(state == idle && tx_start) begin 
            shift_reg <= data_in;
        end
        else if(state == data && baud_tick) begin
            shift_reg <= {1'b1, shift_reg[7:1]};
        end
    end    
end

always @(*) begin
    next_state = state;
    
    case(state)
        idle: begin
            if(tx_start) 
                next_state = start;
            else         
                next_state = idle;
        end
        
        start: begin
            if(baud_tick) 
                next_state = data;
            else          
                next_state = start;
        end
        
        data: begin
            if (bit_count) 
                next_state = stop;
            else           
                next_state = data;
        end
        
        stop: begin
            if(baud_tick) 
                next_state = idle;
            else          
                next_state = stop;
        end 
        
        default: next_state = idle;
    endcase
end 

assign dout = (state == start) ? 1'b0 :
              (state == data)  ? shift_reg[0] :
              1'b1;

endmodule