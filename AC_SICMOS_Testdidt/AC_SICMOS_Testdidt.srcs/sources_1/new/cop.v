module cop(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    input           [7:0]   ad_data     ,
    output  reg     [7:0]   da_data             
    );

    parameter IDLE = ;

    reg                     state_c;
    reg                     state_n;   

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state_c <= IDLE;
        end
        else begin
            state_c <= state_n;
        end
    end
endmodule
