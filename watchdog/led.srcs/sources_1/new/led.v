`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/10/15 21:06:05
// Design Name: 
// Module Name: led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WatchDog(
        input sys_clk,
        input sys_swtich,
        input feed_btn,
        output reg led
    );
FreqDiv divide_10M(
    .sys_clk(sys_clk),
    .div_clk(div_clk)
    );


FeedDog FeedDog_1(
    .clk(div_clk),
    .feed_btn(feed_btn),
    .DogBark(DogBark)
    );
Timer Timer_1(
    .clk(div_clk),
    .led_status(led_status)
    );

always@(posedge div_clk) begin
    // if (sys_swtich) begin
    //     sys_status <= 1'b1;
    // end
    // else if (!sys_swtich) begin
    //     sys_status <= 1'b0;
    // end
        

    if (sys_swtich) begin
        led <= DogBark;   
    end
    else if (!sys_swtich) begin
        led <= led_status;
    end
    
end


// Timer Timer_Exm(
//     .clk(div_clk),
//     .num_cnt(num_cnt_timer),
//     );

endmodule

module FreqDiv(
            input sys_clk,
            output reg div_clk
        );
        reg[15:0] max_value;


        always@(posedge sys_clk)
        begin
           max_value <= max_value + 16'd5242;
        end 
        always@(posedge sys_clk)
        begin
            if(max_value<16'h7FFF)
            begin
            div_clk <= 1'b0;
            end
        else
        begin
            div_clk <= 1'b1;
        end
    end
endmodule
module FeedDog(
        input clk,
        input feed_btn,
        output reg DogBark
    );
        reg[23:0] num_cnt;
        
        always @(posedge clk) begin  
            if (feed_btn) begin
                num_cnt <= 23'b0;
                DogBark <= 1'b0;
            end
            else if(!feed_btn) begin
                num_cnt <= num_cnt + 16'd1;
            end

            if (num_cnt==23'hFFFFFF) begin
                DogBark <= 1'b1;
            end
            
        end
endmodule

 module Timer(
         input clk,
         output reg led_status
     );
     reg[23:0] num_cnt;
     always @(posedge clk) begin
         num_cnt <= num_cnt + 1'b1;
         if (num_cnt==23'hFFFFFF) begin
             led_status <= ~led_status;
         end
         else begin
             led_status <= led_status;
         end
     end
 endmodule
