module main(
        input                   clk         ,
        input                   rst_n       ,
        input           [7:0]   ad_data     ,
        output          [7:0]   da_out      ,
        output                  da_clk      ,
        output                  ad_clk      ,
        output          [9:0]   da_out_10b1 ,
        output                  da_clk_10b1 ,
        output          [9:0]   da_out_10b2 ,
        output                  da_clk_10b2


    );
        wire                    clk_100m;
        wire                    clk_25m ;
        wire            [7:0]   da_data ;



        assign  da_data = ad_data;




ip_wiz u_ip_wiz
    (
        .sys_clk  (clk      ),
        .sys_rst_n(rst_n    ),
        .clk_100m (clk_100m ),
        .clk_25m  (clk_25m  )
    );


ad_wave_rec u_ad_wave_rec
    (
        .sys_clk  (clk_25m  ),
        .sys_rst_n(rst_n    ),
        .ad_clk   (ad_clk   )
    );
da_wave_send u_da_wave_send
    (
        .sys_clk  (clk_100m ),
        .sys_rst_n(rst_n    ),
        .da_data  (da_data  ),
        .da_out   (da_out   ),
        .da_clk   (da_clk   )
    );
da_wave_send_10b1 u_da_wave_send_10b1
    (
        .sys_clk    (clk_100m   ),
        .sys_rst_n  (rst_n      ),
        .da_data    (da_data    ),
        .da_clk_10b1(da_clk_10b1),
        .da_out_10b1(da_out_10b1)
    );
da_wave_send_10b2 u_da_wave_send_10b2
    (
        .sys_clk    (clk_100m   ),
        .sys_rst_n  (rst_n      ),
        .da_data    (da_data    ),
        .da_clk_10b2(da_clk_10b2),
        .da_out_10b2(da_out_10b2)
    );
/*
ila_0 u_ila_0 (
	    .clk        (clk_100m), // input wire clk
	    .probe0     (ad_data), // input wire [7:0]  probe0  
	    .probe1     (da_out), // input wire [7:0]  probe1 
	    .probe2     (da_out_10b1), // input wire [9:0]  probe2 
	    .probe3     (da_out_10b2) // input wire [9:0]  probe3
);
*/
endmodule
