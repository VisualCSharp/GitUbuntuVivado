module da_wave_send(
    input           sys_clk     ,
    input           sys_rst_n   ,
    input   [7:0]   ad_data     ,
    output  [7:0]   da_out      ,
    output          da_clk   
    );

    assign          da_clk = ~sys_clk;
    assign          da_out = ad_data;
endmodule