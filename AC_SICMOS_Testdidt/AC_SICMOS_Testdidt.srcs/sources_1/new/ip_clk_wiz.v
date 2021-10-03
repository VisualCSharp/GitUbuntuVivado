module ip_clk_wiz(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    output                  clk_100m    ,
    output                  clk_25m
    );
    wire                    locked      ;
clk_wiz_0 u_clk_wiz_0
    (
        // Clock out ports
        .clk_25m(clk_25m),     // output clk_25m
        .clk_100m(clk_100m),   // output clk_100m
        // Status and control signals
        .reset(~sys_rst_n),         // input reset
        .locked(locked),       // output locked
        // Clock in ports
        .clk_in1(sys_clk)      // input clk_in1
    );      
endmodule
