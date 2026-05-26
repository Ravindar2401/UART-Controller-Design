module Baude_rate_generator(
    input clk,reset,
    output reg baud_tick,
    output reg rx_tick
    );
reg [9:0]count_rx;
reg [3:0] tick_4bit_count;
parameter clk_freq_rx=5;
          
always @(posedge clk or negedge reset)
    begin
        if(!reset)
            begin
                count_rx <=0;
                rx_tick <=1'b0;
            end
        else
            begin
                if(count_rx==clk_freq_rx-1)
                    begin
                        count_rx <=0;
                        rx_tick <=1'b1;
                    end
                else
                    begin
                        count_rx <= count_rx+1;
                        rx_tick <= 1'b0;
                    end
            end
    end

always @(posedge clk or negedge reset)
    begin
        if(!reset)
            begin
                tick_4bit_count<=0;
                baud_tick<=0;
            end
        else 
            begin
                if(rx_tick)
                    begin
                        if(tick_4bit_count==15)
                            begin
                                tick_4bit_count<=0;
                                baud_tick<=1'b1;
                            end
                        else
                            begin
                                tick_4bit_count<=tick_4bit_count+1;
                                baud_tick<=1'b0;
                            end
                    end
                else
                    baud_tick<=0;
            end
    end
                    
endmodule
