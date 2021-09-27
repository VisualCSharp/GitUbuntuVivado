module ad_wave_rec(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    output                  ad_clk      
    );
    
    assign ad_clk = sys_clk;
endmodule
