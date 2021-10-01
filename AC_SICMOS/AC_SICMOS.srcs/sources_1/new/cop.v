`timescale 1ns/1ps
module cop(
    input                  sys_clk      ,
    input                  sys_rst_n    ,
    input          [7:0]   cop_data     ,
    output   reg   [7:0]   da_data      

    );



    //电平大小参数
    parameter POS_HIG_LEVEL = 8'd0;
    parameter POS_MED_LEVEL = 8'd43;
    parameter POS_LOW_LEVEL = 8'd86;
    parameter NEG_HIG_LEVEL = 8'd255;
    parameter NEG_MED_LEVEL = 8'd212;
    parameter NEG_LOW_LEVEL = 8'd169;

    //上升下降时间延迟
    parameter POS_DELAY = 17'd99977;
    parameter NEG_DELAY = 17'd99977;
    //正负高中低电平触发时间
    //v1.0电平设计时间
    /*
    parameter POS_HIG_LEVEL_TIME = 8'd20;
    parameter POS_MED_LEVEL_TIME = 8'd60;
    parameter POS_LOW_LEVEL_TIME = 8'd20;
    parameter NEG_HIG_LEVEL_TIME = 8'd20;
    parameter NEG_MED_LEVEL_TIME = 8'd60;
    parameter NEG_LOW_LEVEL_TIME = 8'd20;
    */
    //v1.1电平设计时间
    
    parameter POS_HIG_LEVEL_TIME = 8'd2;
    parameter POS_MED_LEVEL_TIME = 8'd6;
    parameter POS_LOW_LEVEL_TIME = 8'd2;
    parameter NEG_HIG_LEVEL_TIME = 8'd2;
    parameter NEG_MED_LEVEL_TIME = 8'd6;
    parameter NEG_LOW_LEVEL_TIME = 8'd2;
    


    //上升下降时间寄存器
    reg                 pos_delay_flag;   
    reg         [16:0]  pos_delay;
    reg                 neg_delay_flag;   
    reg         [16:0]  neg_delay;
    //正负高中低电平触发时间寄存器
    reg         [7:0]   pos_hig_level_time;
    reg         [7:0]   pos_med_level_time;
    reg         [7:0]   pos_low_level_time;
    reg         [7:0]   neg_hig_level_time;
    reg         [7:0]   neg_med_level_time;
    reg         [7:0]   neg_low_level_time;
    reg        add_pos_hig_level_time_flag;
    reg        add_pos_med_level_time_flag;
    reg        add_pos_low_level_time_flag;
    reg        add_neg_hig_level_time_flag;
    reg        add_neg_med_level_time_flag;
    reg        add_neg_low_level_time_flag;
    //上升下降电平触发标志

    reg                 pos_flag_btn1;
    reg                 pos_flag_btn2;
    reg                 neg_flag_btn1;
    reg                 neg_flag_btn2;



    reg                 pos_flag;
    reg                 neg_flag;
    wire                add_pos_delay;
    wire                end_pos_delay;
    wire                add_neg_delay;
    wire                end_neg_delay;
    wire                add_pos_hig_level_time;
    wire                end_pos_hig_level_time;
    wire                add_pos_med_level_time;
    wire                end_pos_med_level_time;
    wire                add_pos_low_level_time;
    wire                end_pos_low_level_time;
    wire                add_neg_hig_level_time;
    wire                end_neg_hig_level_time;
    wire                add_neg_med_level_time;
    wire                end_neg_med_level_time;
    wire                add_neg_low_level_time;
    wire                end_neg_low_level_time;



    //上升下降沿判断
    parameter POS_FLAG_LEVEL = 8'd235;
    parameter NEG_FLAG_LEVEL = 8'd20;




    //上升时间延迟长度
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pos_delay <= 17'd0;
    end
    else if (add_pos_delay) begin
        if (end_pos_delay) begin
            pos_delay <= 17'd0;
        end
        else begin
            pos_delay <= pos_delay + 17'd1;
        end
    end
    else
    ;
    end
    assign add_pos_delay = pos_delay_flag;
    assign end_pos_delay = add_pos_delay&&pos_delay == POS_DELAY - 1;

    //下降时间延迟长度
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        neg_delay <= 17'd0;
    end
    else if (add_neg_delay) begin
        if (end_neg_delay) begin
            neg_delay <= 17'd0;
        end
        else begin
            neg_delay <= neg_delay + 17'd1;
        end
    end
    else
    ;
    end
    assign add_neg_delay = neg_delay_flag;
    assign end_neg_delay = add_neg_delay&&neg_delay == NEG_DELAY - 1;







    //POS_HIG_LEVEL上升高电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pos_hig_level_time <= 8'd0;
    end
    else if (add_pos_hig_level_time) begin
        if (end_pos_hig_level_time) begin
            pos_hig_level_time <= 8'd0;
        end
        else begin
            pos_hig_level_time <= pos_hig_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_pos_hig_level_time = add_pos_hig_level_time_flag;
    assign end_pos_hig_level_time = add_pos_hig_level_time&&pos_hig_level_time == POS_HIG_LEVEL_TIME - 1;

    //POS_MED_LEVEL上升中电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pos_med_level_time <= 8'd0;
    end
    else if (add_pos_med_level_time) begin
        if (end_pos_med_level_time) begin
            pos_med_level_time <= 8'd0;
        end
        else begin
            pos_med_level_time <= pos_med_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_pos_med_level_time = add_pos_med_level_time_flag;
    assign end_pos_med_level_time = add_pos_med_level_time&&pos_med_level_time == POS_MED_LEVEL_TIME - 1;

    //POS_LOW_LEVEL上升低电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        pos_low_level_time <= 8'd0;
    end
    else if (add_pos_low_level_time) begin
        if (end_pos_low_level_time) begin
            pos_low_level_time <= 8'd0;
        end
        else begin
            pos_low_level_time <= pos_low_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_pos_low_level_time = add_pos_low_level_time_flag;
    assign end_pos_low_level_time = add_pos_low_level_time&&pos_low_level_time == POS_LOW_LEVEL_TIME - 1;









    //NEG_HIG_LEVEL下降高电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        neg_hig_level_time <= 8'd0;
    end
    else if (add_neg_hig_level_time) begin
        if (end_neg_hig_level_time) begin
            neg_hig_level_time <= 8'd0;
        end
        else begin
            neg_hig_level_time <= neg_hig_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_neg_hig_level_time = add_neg_hig_level_time_flag;
    assign end_neg_hig_level_time = add_neg_hig_level_time&&neg_hig_level_time == NEG_HIG_LEVEL_TIME - 1;

    //NEG_MED_LEVEL下降中电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        neg_med_level_time <= 8'd0;
    end
    else if (add_neg_med_level_time) begin
        if (end_neg_med_level_time) begin
            neg_med_level_time <= 8'd0;
        end
        else begin
            neg_med_level_time <= neg_med_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_neg_med_level_time = add_neg_med_level_time_flag;
    assign end_neg_med_level_time = add_neg_med_level_time&&neg_med_level_time == NEG_MED_LEVEL_TIME - 1;

    //NEG_LOW_LEVEL下降低电平触发时间
    always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        neg_low_level_time <= 8'd0;
    end
    else if (add_neg_low_level_time) begin
        if (end_neg_low_level_time) begin
            neg_low_level_time <= 8'd0;
        end
        else begin
            neg_low_level_time <= neg_low_level_time + 8'd1;
        end
    end
    else
    ;
    end
    assign add_neg_low_level_time = add_neg_low_level_time_flag;
    assign end_neg_low_level_time = add_neg_low_level_time&&neg_low_level_time == NEG_LOW_LEVEL_TIME - 1;






    //上升控制电平触发条件
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pos_flag <= 1'b0;
        end
        else if (cop_data < POS_FLAG_LEVEL) begin
            pos_flag <= 1'b1;
        end
        else
            pos_flag <= 1'b0;
    end

    //下降控制电平触发条件
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            neg_flag <= 1'b0;
        end
        else if (cop_data > NEG_FLAG_LEVEL) begin
            neg_flag <= 1'b1;
        end
        else
            neg_flag <= 1'b0;
    end








    // 观测上升过程的上升沿并开启计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pos_flag_btn1 <= 1;
            pos_flag_btn2 <= 1;
        end
        else begin
            pos_flag_btn1 <= pos_flag;
            pos_flag_btn2 <= pos_flag_btn1;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            pos_delay_flag <= 0;
        end
        else if (pos_flag_btn1 && ~pos_flag_btn2) begin
            pos_delay_flag <= 1;
        end
        else if (end_pos_delay) begin
            pos_delay_flag <= 0;
        end
        else
        ;
    end

    // 观测下降过程的上升沿并开启计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            neg_flag_btn1 <= 1;
            neg_flag_btn2 <= 1;
        end
        else begin
            neg_flag_btn1 <= neg_flag;
            neg_flag_btn2 <= neg_flag_btn1;
        end
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            neg_delay_flag <= 0;
        end
        else if (neg_flag_btn1 && ~neg_flag_btn2) begin
            neg_delay_flag <= 1;
        end
        else if (end_neg_delay) begin
            neg_delay_flag <= 0;
        end
        else
        ;
    end


/*
    //test1
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            da_data <= 8'd127;
        end
        else if (pos_flag) begin
            da_data <= 8'd127;
        end
        else if (neg_flag) begin
            da_data <= 8'd255;
        end
        else
        ;
    end
*/




    //数据输出
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            da_data <= 8'd127;
            //da_data <= POS_HIG_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        
        else if (end_pos_delay) begin
            da_data <= POS_HIG_LEVEL;
            add_pos_hig_level_time_flag <= 1;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_pos_hig_level_time) begin
            da_data <= POS_MED_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 1;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_pos_med_level_time) begin
            da_data <= POS_LOW_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 1;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_pos_low_level_time) begin
            da_data <= 8'd127;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_neg_delay) begin
            da_data <= NEG_HIG_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 1;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_neg_hig_level_time) begin
            da_data <= NEG_MED_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 1;
            add_neg_low_level_time_flag <= 0;
        end
        else if (end_neg_med_level_time) begin
            da_data <= NEG_LOW_LEVEL;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 1;
        end
        else if (end_neg_low_level_time) begin
            da_data <= 8'd127;
            add_pos_hig_level_time_flag <= 0;
            add_pos_med_level_time_flag <= 0;
            add_pos_low_level_time_flag <= 0;
            add_neg_hig_level_time_flag <= 0;
            add_neg_med_level_time_flag <= 0;
            add_neg_low_level_time_flag <= 0;
        end
        
        else
        ;
    end


    endmodule