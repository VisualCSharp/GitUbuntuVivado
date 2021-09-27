module main(
        input                   clk     ,
        input                   rst_n   ,
        input           [7:0]   ad_data ,
        output          [7:0]   da_out  ,
        output                  da_clk  ,
        output                  ad_clk

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
endmodule
