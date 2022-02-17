`timescale 1ns/100ps
module NFC(clk, rst, done, F_IO_A, F_CLE_A, F_ALE_A, F_REN_A, F_WEN_A, F_RB_A, F_IO_B, F_CLE_B, F_ALE_B, F_REN_B, F_WEN_B, F_RB_B);

input        clk;
input        rst;
output reg      done;
inout  [7:0] F_IO_A;
output reg        F_CLE_A;
output reg      F_ALE_A;
output reg      F_REN_A;
output reg      F_WEN_A;
input        F_RB_A;
inout  [7:0] F_IO_B;
output reg      F_CLE_B;
output reg      F_ALE_B;
output reg      F_REN_B;
output reg      F_WEN_B;
input        F_RB_B;
reg [10:0]cur_a,cur_b,next_a,next_b;
reg w_a,w_b,en_out_a,en_out_b,r_a,r_b,nnn;
reg [7:0] fin_a,fin_b;
reg [20:0] count_data;

assign F_IO_A = (en_out_a)? fin_a:8'hzz;
assign F_IO_B = (en_out_b)? fin_b:8'hzz;
always @(negedge clk or posedge rst) begin
    if (w_a == 1) begin
        F_WEN_A <= 1'd1;//check
    end
    if (w_b == 1'd1) begin
        F_WEN_B <= 1'd1;
    end
    if (r_a == 1) begin
        F_REN_A <= 1'd1;
    end
    if (r_b == 1) begin
        F_REN_B <= 1'd1;
    end
    if (nnn == 1'd1) begin
        fin_b <= F_IO_A;
        count_data <= count_data + 21'd1;
        F_ALE_B <= 1'd0;
        F_CLE_B <= 1'd0;
        if (count_data == 33) begin
            nnn <= 0;
            en_out_b <= 1'd0;
            r_a <= 0;//?
        end
    end
end
always @(posedge clk or posedge rst) begin
    if (rst) begin
        done <= 1'd0;
        w_a <= 1'd1;
        w_b <= 1'd1;
        r_a <= 1'd0;
        r_b <= 1'd0;
        cur_a <= 1'd0;
        cur_b <= 1'd0;
        count_data <= 21'd0;
        nnn <= 1'd0;
        fin_a <= 8'b1111_1111;
        en_out_a <= 1'b1;
        F_CLE_A <= 1'b1;
        F_REN_A <= 1'd1;
        F_WEN_A <= 1'd0;
        F_ALE_A <= 1'd0;//no ale
        F_WEN_B <= 1'd0;//?
        fin_b <= 8'b1111_1111;
        en_out_b <= 1'b1;
        F_CLE_B <= 1'b1;
        F_REN_B <= 1'd1;
        F_WEN_B <= 1'd1;
        F_ALE_B <= 1'd0;//no ale
    end
    else begin
        cur_a <= next_a;
        case (cur_a)
            // 0:begin
            //     fin_a <= 8'b1111_1111;
            //     en_out_a <= 1'b1;
            //     F_CLE_A <= 1'b1;
            //     F_REN_A <= 1'd1;
            //     F_WEN_A <= 1'd0;
            //     F_ALE_A <= 1'd0;
            // end
            1:begin
                F_CLE_A <= 1'd1;
                F_ALE_A <= 1'd0;
                fin_a <= 8'h00;
                F_WEN_A <= 1'd0;
            end
            2:begin
                F_WEN_A <= 1'b0;
                fin_a <= 7'd0;
                F_ALE_A <= 1'b1;
                F_CLE_A <= 1'b0;
            end 
            3:begin
                F_WEN_A <= 1'b0;
                fin_a <= 7'd0;
                F_ALE_A <= 1'b1;
                F_CLE_A <= 1'b0;
            end
            4:begin
                F_WEN_A <= 1'b0;
                fin_a <= 7'd0;
                F_ALE_A <= 1'b1;
                F_CLE_A <= 1'b0;
            end
            5:begin
                F_ALE_A <= 1'd0;
                F_CLE_A <= 1'd0;
                en_out_a <= 0;
                w_a <= 1'd0;
                r_a <= 1'd1;
                F_REN_A <= 1'd0;
            end
            6:begin
                F_ALE_A <= 1'd0;
                F_CLE_A <= 1'd0;
                en_out_a <= 0;
                w_a <= 1'd0;
                //r_a <= 1'd1;
                F_REN_A <= 1'd0;
            end 
        endcase
        cur_b <= next_b;
        case (cur_b)
            // 0:begin
            //     F_WEN_B <= 1'd0;//?
            //     fin_b <= 8'b1111_1111;
            //     en_out_b <= 1'b1;
            //     F_CLE_B <= 1'b1;
            //     F_REN_B <= 1'd1;
            //     F_ALE_B <= 1'd0;
            // end
            1:begin
                fin_b <= 8'h80;
                F_WEN_B <= 1'd0;
                F_CLE_B <= 1'b1;
                F_REN_B <= 1'd1;
            end
            2:begin
                F_WEN_B <= 1'b0;
                fin_b <= 7'd0;
                F_ALE_B <= 1'b1;
                F_CLE_B <= 1'b0;
            end
            3:begin
                F_WEN_B <= 1'b0;
                fin_b <= 7'd0;
                F_ALE_B <= 1'b1;
                F_CLE_B <= 1'b0;
            end
            4:begin
                F_WEN_B <= 1'b0;
                fin_b <= 7'd0;
                F_ALE_B <= 1'b1;
                F_CLE_B <= 1'b0;
            end
            5:begin
                F_WEN_B <= 1'd0; 
                if(count_data == 0)begin
                    w_b <= 1'd0;
                end
                else begin
                    w_b <= 1'd1;
                end
                if(count_data <= 32)begin
                    nnn <= 1;
                end               
            end
            6:begin
                en_out_b <= 1'd1;
                fin_b <= 8'h10;
                F_WEN_B <= 1'd0;
                F_CLE_B <= 1'b1;
                F_ALE_B <= 1'd0;
                F_REN_B <= 1'd1;
            end
            7:begin
                en_out_b <= 0;
            end
            8:begin
                done <= 1;
            end
        endcase
    end
end

always @(*) begin
    if (rst) begin
        
    end
    else begin
        case(cur_a)
        0:begin
            next_a = 1;
        end
        1:begin
            next_a = 2;
        end
        2:begin
            next_a = 3;
        end
        3:begin
            next_a = 4;
        end
        4:begin
            next_a = 5;
        end
        5:begin
        
        end
        6:begin
            
        end
        
        endcase
        case (cur_b)
        0:begin
            next_b = 1;
        end
        1:begin
            next_b = 2;
        end
        2:begin
            next_b = 3;
        end
        3:begin
            next_b = 4;
        end
        4:begin
            next_b = 5;
        end
        5:begin
            if (count_data == 21'd33) begin
                    next_b = 6;
            end
        end
        6:begin
            next_b <= 7;
        end
        7:begin
            if (F_RB_B == 1) begin
                next_b = 8;
            end
            else next_b = 7;
        end
        8:begin

        end
        endcase
    end
end
endmodule
