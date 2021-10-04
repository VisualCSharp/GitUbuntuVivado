module cop(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    input           [7:0]   ad_data     ,
    output  reg     [7:0]   da_data     ,
    output  reg     [7:0]   cop_data       
    );

    //状态机架构编码
    parameter IDLE = 5'b00001;
    parameter S01  = 5'b00010;
    parameter S02  = 5'b00100;
    parameter S03  = 5'b01000;
    parameter S04  = 5'b10000;



    //计数器总计数器取值
    parameter S1_CNT = 6'd1;
    parameter S2_CNT = 6'd3;
    parameter S3_CNT = 6'd5;



    //过零值检测寄存器
    reg                     ad_data_r1;
    reg                     ad_data_r2;
    reg                     ad_data_f1;
    reg                     ad_data_f2;
    wire                    rise_cross_zero_flag;
    wire                    fall_cross_zero_flag;
    wire                    cross_zero_flag;  



    //过零点计数器寄存器
    reg             [5:0]   s1_cnt;
    wire                    add_s1_cnt;
    wire                    end_s1_cnt;
    reg             [5:0]   s2_cnt;
    wire                    add_s2_cnt;
    wire                    end_s2_cnt;
    reg             [5:0]   s3_cnt;
    wire                    add_s3_cnt;
    wire                    end_s3_cnt;  



    //状态机架构模态转换寄存器
    reg             [4:0]   state_c;
    reg             [4:0]   state_n;



    //模态转换条件声明
    wire                    idle2s01_start;
    wire                    s012s02_start;
    wire                    s022s03_start;
    wire                    s032s04_start;
    wire                    s042idle_start; 


    
    //第四阶段延迟计数器定义
    reg             [17:0]  delay_cnt;
    wire                    add_delay_cnt;
    wire                    end_delay_cnt;



    //延迟计数器延迟计数值
    parameter DELAY_CNT = 18'd66666;



    //同步时序的always模块用来格式化描述次态迁移至现态寄存器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state_c <= IDLE;
        end
        else begin
            state_c <= state_n;
        end
    end



    //组合逻辑always模块，用来描述状态转移条件判断。转移条件由信号名命名
    always @(*) begin
        case (state_c)
            IDLE: begin
                if (idle2s01_start) begin
                    state_n = S01;
                end
                else begin
                    state_n = state_c;
                end
            end

            S01 : begin
                if (s012s02_start) begin
                    state_n = S02;
                end
                else begin
                    state_n = state_c;
                end
            end

            S02 : begin
                if (s022s03_start) begin
                    state_n = S03;
                end
                else begin
                    state_n = state_c;
                end
            end

            S03 : begin
                if (s032s04_start) begin
                    state_n = S04;
                end
                else begin
                    state_n = state_c;
                end
            end

            S04: begin
                if (s042idle_start) begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end

            default: begin
                state_n = IDLE;
            end
        endcase
    end



    //用assign定义转移条件
    assign idle2s01_start = state_c == IDLE && cross_zero_flag;
    assign s012s02_start  = state_c == S01  && end_s1_cnt;
    assign s022s03_start  = state_c == S02  && end_s2_cnt;
    assign s032s04_start  = state_c == S03  && end_s3_cnt;
    assign s042idle_start = state_c == S04  && end_delay_cnt;



    //s1计数器计数上升过零点个数
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s1_cnt <= 6'd0;            
        end
        else if (add_s1_cnt) begin
            if (end_s1_cnt) begin
                s1_cnt <= 6'd0;
            end
            else begin
                s1_cnt <= s1_cnt + 6'd1;
            end
        end
        else
        ;
    end

    assign add_s1_cnt = cross_zero_flag && state_c == S01;
    assign end_s1_cnt = add_s1_cnt && s1_cnt == S1_CNT - 1;

    //s2计数器计数上升过零点个数
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s2_cnt <= 6'd0;            
        end
        else if (add_s2_cnt) begin
            if (end_s2_cnt) begin
                s2_cnt <= 6'd0;
            end
            else begin
                s2_cnt <= s2_cnt + 6'd1;
            end
        end
        else
        ;
    end

    assign add_s2_cnt = cross_zero_flag && state_c == S02;
    assign end_s2_cnt = add_s2_cnt && s2_cnt == S2_CNT - 1;

    //s3计数器计数上升过零点个数
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s3_cnt <= 6'd0;            
        end
        else if (add_s3_cnt) begin
            if (end_s3_cnt) begin
                s3_cnt <= 6'd0;
            end
            else begin
                s3_cnt <= s3_cnt + 6'd1;
            end
        end
        else
        ;
    end

    assign add_s3_cnt = cross_zero_flag && state_c == S03;
    assign end_s3_cnt = add_s3_cnt && s3_cnt == S3_CNT - 1;



    //过零值检测代码
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            ad_data_r1 <= 1'b1;
            ad_data_r2 <= 1'b1;
        end
        else begin
            ad_data_r1 <= ad_data[7];
            ad_data_r2 <= ad_data_r1;
        end
    end
    assign rise_cross_zero_flag = ad_data_r1 && ~ad_data_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            ad_data_f1 <= 1'b0;
            ad_data_f2 <= 1'b0;
        end
        else begin
            ad_data_f1 <= ad_data[7];
            ad_data_f2 <= ad_data_f1;
        end
    end
    assign fall_cross_zero_flag = ~ad_data_f1 && ad_data_f2;

    assign cross_zero_flag = rise_cross_zero_flag||fall_cross_zero_flag;
    //第四阶段延时S04
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            delay_cnt <= 18'd0;
        end
        else if (add_delay_cnt) begin
            if (end_delay_cnt) begin
                delay_cnt <= 18'd0;
            end
            else begin
                delay_cnt <= delay_cnt + 18'd1;
            end
        end
    end

    assign add_delay_cnt = state_c == S04;
    assign end_delay_cnt = add_delay_cnt && delay_cnt == DELAY_CNT - 1;
    
    

///////////////////////////////////////////////////////////////////////////////////////////////////////



    //输出数据延时处理寄存器
    parameter CYCLE_DELAY_CNT = 18'd133314;



    //输出状态机参数及对应变量定义
    parameter IDLE_OUT = 5'b00001;
    parameter OUT01    = 5'b00010;
    parameter OUT02    = 5'b00100;
    parameter OUT03    = 5'b01000;
    parameter OUT04    = 5'b10000;

    reg             [4:0]   state_out_n;
    reg             [4:0]   state_out_c;

    wire                    idle2out01_start;
    wire                    out012out02_start;
    wire                    out022out03_start;
    wire                    out032out04_start;
    wire                    out042idle_start;



    //同步时序的always模块用来格式化描述次态迁移至现态寄存器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state_out_c <= IDLE_OUT;
        end
        else begin
            state_out_c <= state_out_n;
        end
    end



    //组合逻辑always模块，用来描述状态转移条件判断。转移条件由信号名命名
    always @(*) begin
        case (state_out_c)
            IDLE_OUT: begin
                if (idle2out01_start) begin
                    state_out_n = OUT01;
                end
                else begin
                    state_out_n = state_out_c;
                end
            end

            OUT01 : begin
                if (out012out02_start) begin
                    state_out_n = OUT02;
                end
                else begin
                    state_out_n = state_out_c;
                end
            end

            OUT02 : begin
                if (out022out03_start) begin
                    state_out_n = OUT03;
                end
                else begin
                    state_out_n = state_out_c;
                end
            end

            OUT03 : begin
                if (out032out04_start) begin
                    state_out_n = OUT04;
                end
                else begin
                    state_out_n = state_out_c;
                end
            end

            OUT04 : begin
                if (out042idle_start) begin
                    state_out_n = IDLE_OUT;
                end
                else begin
                    state_out_n = state_out_c;
                end
            end

            default: begin
                state_out_n = IDLE_OUT;
            end
        endcase
    end



    //用assign定义转移条件
    assign idle2out01_start   = state_out_c == IDLE_OUT && end_idle2s01_cycle_delay_cnt;
    assign out012out02_start  = state_out_c == OUT01    && end_s012s02_cycle_delay_cnt;
    assign out022out03_start  = state_out_c == OUT02    && end_s022s03_cycle_delay_cnt;
    assign out032out04_start  = state_out_c == OUT03    && end_s032s04_cycle_delay_cnt;
    assign out042idle_start   = state_out_c == OUT04    && end_s042idle_cycle_delay_cnt;



    //状态捕获寄存器+输出延时计数器寄存器
    reg                     idle2s01_start_r1;
    reg                     idle2s01_start_r2;
    wire                    rise_idle2s01_start;
    reg                     add_idle2s01_cycle_delay_cnt_flag;
    reg             [17:0]  idle2s01_cycle_delay_cnt;
    wire                    add_idle2s01_cycle_delay_cnt;
    wire                    end_idle2s01_cycle_delay_cnt;

    reg                     s012s02_start_r1;
    reg                     s012s02_start_r2;
    wire                    rise_s012s02_start;
    reg                     add_s012s02_cycle_delay_cnt_flag;
    reg             [17:0]  s012s02_cycle_delay_cnt;
    wire                    add_s012s02_cycle_delay_cnt;
    wire                    end_s012s02_cycle_delay_cnt;

    reg                     s022s03_start_r1;
    reg                     s022s03_start_r2;
    wire                    rise_s022s03_start;
    reg                     add_s022s03_cycle_delay_cnt_flag;
    reg             [17:0]  s022s03_cycle_delay_cnt;
    wire                    add_s022s03_cycle_delay_cnt;
    wire                    end_s022s03_cycle_delay_cnt;

    reg                     s032s04_start_r1;
    reg                     s032s04_start_r2;
    wire                    rise_s032s04_start;
    reg                     add_s032s04_cycle_delay_cnt_flag;
    reg             [17:0]  s032s04_cycle_delay_cnt;
    wire                    add_s032s04_cycle_delay_cnt;
    wire                    end_s032s04_cycle_delay_cnt;

    reg                     s042idle_start_r1;
    reg                     s042idle_start_r2;
    wire                    rise_s042idle_start;
    reg                     add_s042idle_cycle_delay_cnt_flag;
    reg             [17:0]  s042idle_cycle_delay_cnt;
    wire                    add_s042idle_cycle_delay_cnt;
    wire                    end_s042idle_cycle_delay_cnt;

    //idle2s01状态转换捕获+输出延时计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            idle2s01_start_r1 <= 1'b1;
            idle2s01_start_r2 <= 1'b1;
        end
        else begin
            idle2s01_start_r1 <= idle2s01_start;
            idle2s01_start_r2 <= idle2s01_start_r1;
        end
    end
    assign rise_idle2s01_start = idle2s01_start_r1 && ~idle2s01_start_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            add_idle2s01_cycle_delay_cnt_flag <= 0;
        end
        else if (rise_idle2s01_start) begin
            add_idle2s01_cycle_delay_cnt_flag <= 1;
        end
        else if (end_idle2s01_cycle_delay_cnt) begin
            add_idle2s01_cycle_delay_cnt_flag <= 0;
        end
        else
        ;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            idle2s01_cycle_delay_cnt <= 18'd0;
        end
        else if (add_idle2s01_cycle_delay_cnt) begin
            if (end_idle2s01_cycle_delay_cnt) begin
                idle2s01_cycle_delay_cnt <= 18'd0;
            end
            else begin
                idle2s01_cycle_delay_cnt <= idle2s01_cycle_delay_cnt + 18'd1;
            end
        end
    end

    assign add_idle2s01_cycle_delay_cnt = add_idle2s01_cycle_delay_cnt_flag;
    assign end_idle2s01_cycle_delay_cnt = add_idle2s01_cycle_delay_cnt && idle2s01_cycle_delay_cnt == CYCLE_DELAY_CNT - 1;

    //s012s02状态转换捕获+输出延时计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s012s02_start_r1 <= 1'b1;
            s012s02_start_r2 <= 1'b1;
        end
        else begin
            s012s02_start_r1 <= s012s02_start;
            s012s02_start_r2 <= s012s02_start_r1;
        end
    end
    assign rise_s012s02_start = s012s02_start_r1 && ~s012s02_start_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            add_s012s02_cycle_delay_cnt_flag <= 0;
        end
        else if (rise_s012s02_start) begin
            add_s012s02_cycle_delay_cnt_flag <= 1;
        end
        else if (end_s012s02_cycle_delay_cnt) begin
            add_s012s02_cycle_delay_cnt_flag <= 0;
        end
        else
        ;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s012s02_cycle_delay_cnt <= 18'd0;
        end
        else if (add_s012s02_cycle_delay_cnt) begin
            if (end_s012s02_cycle_delay_cnt) begin
                s012s02_cycle_delay_cnt <= 18'd0;
            end
            else begin
                s012s02_cycle_delay_cnt <= s012s02_cycle_delay_cnt + 18'd1;
            end
        end
    end

    assign add_s012s02_cycle_delay_cnt = add_s012s02_cycle_delay_cnt_flag;
    assign end_s012s02_cycle_delay_cnt = add_s012s02_cycle_delay_cnt && s012s02_cycle_delay_cnt == CYCLE_DELAY_CNT - 1;

    //s022s03状态转换捕获+输出延时计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s022s03_start_r1 <= 1'b1;
            s022s03_start_r2 <= 1'b1;
        end
        else begin
            s022s03_start_r1 <= s022s03_start;
            s022s03_start_r2 <= s022s03_start_r1;
        end
    end
    assign rise_s022s03_start = s022s03_start_r1 && ~s022s03_start_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            add_s022s03_cycle_delay_cnt_flag <= 0;
        end
        else if (rise_s022s03_start) begin
            add_s022s03_cycle_delay_cnt_flag <= 1;
        end
        else if (end_s022s03_cycle_delay_cnt) begin
            add_s022s03_cycle_delay_cnt_flag <= 0;
        end
        else
        ;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s022s03_cycle_delay_cnt <= 18'd0;
        end
        else if (add_s022s03_cycle_delay_cnt) begin
            if (end_s022s03_cycle_delay_cnt) begin
                s022s03_cycle_delay_cnt <= 18'd0;
            end
            else begin
                s022s03_cycle_delay_cnt <= s022s03_cycle_delay_cnt + 18'd1;
            end
        end
    end

    assign add_s022s03_cycle_delay_cnt = add_s022s03_cycle_delay_cnt_flag;
    assign end_s022s03_cycle_delay_cnt = add_s022s03_cycle_delay_cnt && s022s03_cycle_delay_cnt == CYCLE_DELAY_CNT - 1;

    //s032s04状态转换捕获+输出延时计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s032s04_start_r1 <= 1'b1;
            s032s04_start_r2 <= 1'b1;
        end
        else begin
            s032s04_start_r1 <= s032s04_start;
            s032s04_start_r2 <= s032s04_start_r1;
        end
    end
    assign rise_s032s04_start = s032s04_start_r1 && ~s032s04_start_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            add_s032s04_cycle_delay_cnt_flag <= 0;
        end
        else if (rise_s032s04_start) begin
            add_s032s04_cycle_delay_cnt_flag <= 1;
        end
        else if (end_s032s04_cycle_delay_cnt) begin
            add_s032s04_cycle_delay_cnt_flag <= 0;
        end
        else
        ;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s032s04_cycle_delay_cnt <= 18'd0;
        end
        else if (add_s032s04_cycle_delay_cnt) begin
            if (end_s032s04_cycle_delay_cnt) begin
                s032s04_cycle_delay_cnt <= 18'd0;
            end
            else begin
                s032s04_cycle_delay_cnt <= s032s04_cycle_delay_cnt + 18'd1;
            end
        end
    end

    assign add_s032s04_cycle_delay_cnt = add_s032s04_cycle_delay_cnt_flag;
    assign end_s032s04_cycle_delay_cnt = add_s032s04_cycle_delay_cnt && s032s04_cycle_delay_cnt == CYCLE_DELAY_CNT - 1;

    //s042idle状态转换捕获+输出延时计数器
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s042idle_start_r1 <= 1'b1;
            s042idle_start_r2 <= 1'b1;
        end
        else begin
            s042idle_start_r1 <= s042idle_start;
            s042idle_start_r2 <= s042idle_start_r1;
        end
    end
    assign rise_s042idle_start = s042idle_start_r1 && ~s042idle_start_r2;

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            add_s042idle_cycle_delay_cnt_flag <= 0;
        end
        else if (rise_s042idle_start) begin
            add_s042idle_cycle_delay_cnt_flag <= 1;
        end
        else if (end_s042idle_cycle_delay_cnt) begin
            add_s042idle_cycle_delay_cnt_flag <= 0;
        end
        else
        ;
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            s042idle_cycle_delay_cnt <= 18'd0;
        end
        else if (add_s042idle_cycle_delay_cnt) begin
            if (end_s042idle_cycle_delay_cnt) begin
                s042idle_cycle_delay_cnt <= 18'd0;
            end
            else begin
                s042idle_cycle_delay_cnt <= s042idle_cycle_delay_cnt + 18'd1;
            end
        end
    end

    assign add_s042idle_cycle_delay_cnt = add_s042idle_cycle_delay_cnt_flag;
    assign end_s042idle_cycle_delay_cnt = add_s042idle_cycle_delay_cnt && s042idle_cycle_delay_cnt == CYCLE_DELAY_CNT - 1;






    //输出
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            da_data <= 8'd255;
        end
        else if (state_out_c == S01) begin
            da_data <= 8'd0;
        end
        else if (state_out_c == S02) begin
            da_data <= 8'd0;
        end
        else if (state_out_c == S03) begin
            da_data <= 8'd0;
        end
        else if (state_out_c == S04) begin
            da_data <= 8'd0;
        end
        else
            da_data <= 8'd255; 
    end

    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            cop_data <= 8'd127;
        end
        else if (state_out_c == S01) begin
            cop_data <= 8'd0;
        end
        else if (state_out_c == S02) begin
            cop_data <= 8'd64;
        end
        else if (state_out_c == S03) begin
            cop_data <= 8'd96;
        end
        else if (state_out_c == S04) begin
            cop_data <= 8'd127;
        end
        else
            cop_data <= 8'd127; 
    end
endmodule
