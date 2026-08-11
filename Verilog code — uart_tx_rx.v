module uart_tx (
    input        clk,
    input        reset,
    input        tx_start,
    input  [7:0]  tx_data,
    output reg   tx,
    output reg   tx_busy
);

    parameter CLKS_PER_BIT = 10;

    reg [3:0] bit_count;
    reg [15:0] clk_count;
    reg [9:0] tx_shift;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx        <= 1'b1;
            tx_busy   <= 1'b0;
            bit_count <= 0;
            clk_count <= 0;
            tx_shift  <= 10'b1111111111;
        end
        else begin
            if (tx_start && !tx_busy) begin
                // Start bit + 8 data bits + stop bit
                tx_shift  <= {1'b1, tx_data, 1'b0};
                tx_busy   <= 1'b1;
                bit_count <= 0;
                clk_count <= 0;
                tx        <= 1'b0;
            end

            else if (tx_busy) begin
                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;
                    bit_count <= bit_count + 1'b1;

                    if (bit_count == 9) begin
                        tx      <= 1'b1;
                        tx_busy <= 1'b0;
                    end
                    else begin
                        tx <= tx_shift[bit_count + 1];
                    end
                end
                else begin
                    clk_count <= clk_count + 1'b1;
                end
            end
        end
    end

endmodule


module uart_rx (
    input        clk,
    input        reset,
    input        rx,
    output reg [7:0] rx_data,
    output reg   rx_done
);

    parameter CLKS_PER_BIT = 10;

    reg [15:0] clk_count;
    reg [3:0]  bit_count;
    reg [7:0]  rx_shift;
    reg        receiving;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_count <= 0;
            bit_count <= 0;
            rx_shift  <= 0;
            rx_data   <= 0;
            rx_done   <= 0;
            receiving <= 0;
        end
        else begin
            rx_done <= 1'b0;

            if (!receiving) begin
                if (rx == 1'b0) begin
                    receiving <= 1'b1;
                    clk_count <= CLKS_PER_BIT / 2;
                    bit_count <= 0;
                end
            end
            else begin
                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;

                    if (bit_count < 8) begin
                        rx_shift[bit_count] <= rx;
                        bit_count <= bit_count + 1'b1;
                    end
                    else begin
                        rx_data   <= rx_shift;
                        rx_done   <= 1'b1;
                        receiving <= 1'b0;
                    end
                end
                else begin
                    clk_count <= clk_count + 1'b1;
                end
            end
        end
    end

endmodule