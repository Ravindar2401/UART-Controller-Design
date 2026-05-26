module uart_top(
    input clk,reset,tx_start,rx,
    input [7:0] data_in,
    output [7:0] data_out,
    output rx_done,tx
    );

wire baud_tick_wire,rx_tick_wire,output_tx_wire;

assign tx = output_tx_wire;

Baude_rate_generator ut1(.clk(clk),.reset(reset),.baud_tick(baud_tick_wire),.rx_tick(rx_tick_wire));

uart_transmitter ut2(.clk(clk),.reset(reset),.baud_tick(baud_tick_wire),.tx_start(tx_start),.data_in(data_in),.dout(output_tx_wire));

uart_receiver ut3(.clk(clk),.reset(reset),.rx_tick(rx_tick_wire),.rx(rx),.data_out(data_out),.rx_done(rx_done));

endmodule
