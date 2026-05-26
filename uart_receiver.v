module uart_receiver(
    input clk,reset,rx_tick,rx,
    output reg [7:0] data_out,
    output reg rx_done
    );
    
parameter idle=2'b00,
          start=2'b01,
          data=2'b10,
          stop=2'b11;

reg [1:0] state,next_state;
reg [3:0] s_count;
reg [2:0] n_count;
reg [7:0] b_reg;

always @(posedge clk or negedge reset)
    begin
        if(!reset)
            state <= idle;
        else
            state <=next_state;
    end

always @(posedge clk or negedge reset)
    begin
        if(!reset)
                s_count <=0;
        else if(rx_tick)
            begin
                if(state==idle)
                    s_count <=0;
                else if(state==start && s_count==7)
                    s_count <=0;
                else if((state==data  || state==stop) && s_count==15)
                    s_count <=0;
                else
                    s_count <= s_count+1;
            end
    end
always @(posedge clk or negedge reset)
    begin
        if(!reset)
            n_count <=0;
        else if(rx_tick)
            begin
                if(state==idle)
                    n_count <=0;
                else if(state==data && s_count==15)
                    begin
                        if(n_count==7)
                            n_count<=0;
                        else
                            n_count <= n_count+1;
                    end
            end
            
    end

always @(posedge clk or negedge reset)
    begin
        if(!reset)
            b_reg<=0;
        else if(rx_tick)
            begin
                if(state == data && s_count==15)
                    b_reg <= {rx,b_reg[7:1]};
            end
    end
                        
always @(*)
    begin
        case(state)
            idle:
                begin
                    if(rx==1'b0)
                        next_state=start;
                    else
                        next_state=idle;
                end
            start:
                begin
                    if(rx_tick && s_count==7)
                        next_state=data;
                    else
                        next_state=start;
                end
            data:
                begin
                    if(rx_tick && s_count==15 && n_count==7)
                        next_state=stop;
                    else
                        next_state=data;
                end
            stop:
                begin
                    if(rx_tick && s_count==15)
                        next_state=idle;
                    else
                        next_state=stop;
                end
            default:next_state=idle;                   
        endcase
    end
always @(posedge clk or negedge reset)
    begin
        if(!reset)
            begin
                data_out<=0;
                rx_done<=0;
            end
        else 
            begin
                if(rx_tick && state==stop && s_count==15)
                    begin
                        data_out<=b_reg;
                        rx_done<=1'b1;
                    end
                else
                    begin
                        rx_done<=1'b0;
                        data_out <= data_out;
                    end
            end
    end
endmodule

