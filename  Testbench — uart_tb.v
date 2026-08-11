`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;

    wire [7:0] rx_data;
    wire rx_done;

    // UART Transmitter
    uart_tx #(
        .CLKS_PER_BIT(10)
    ) transmitter (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // UART Receiver
    uart_rx #(
        .CLKS_PER_BIT(10)
    ) receiver (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("uart_simulation.vcd");
        $dumpvars(0, uart_tb);

        clk      = 0;
        reset    = 1;
        tx_start = 0;
        tx_data  = 8'h00;

        #20;
        reset = 0;

        // Transmit 8-bit data
        #20;
        tx_data  = 8'hA5;
        tx_start = 1;

        #10;
        tx_start = 0;

        // Wait for reception
        wait(rx_done);

        #10;

        $display("Transmitted Data = %h", tx_data);
        $display("Received Data    = %h", rx_data);

        if (tx_data == rx_data)
            $display("UART TEST PASSED");
        else
            $display("UART TEST FAILED");

        #20;
        $finish;
    end

endmodule