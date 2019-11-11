`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2018 14:45:25
// Design Name: 
// Module Name: sev_seg_dis
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


module sev_seg_dis(
    input btnU,
    input btnC,
    input btnD,
    input clk,
    input btnL,
    input btnR,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg [15:0] led
    
    );

    wire [1:0] s;
    wire [3:0] s1;
    wire [3:0] aen;
    reg [4:0]  seg_0=5'b11111;
    reg [4:0]  seg_1=5'b11111;
    reg [4:0]  seg_2=5'b11111;
    reg [4:0]  seg_3=5'b00001;
    reg [4:0]  digit;
    reg [19:0] clkdiv;
    reg [25:0] clkdiv2;
    reg [26:0] move_left;
    reg [4:0]  rand_no;
    reg [12:0] score=0;
    reg [1:0] display_score=0;
    reg [26:0] snr;
    reg prev_btnU;
    reg prev_btnD;
    reg prev_btnL;
    reg prev_btnR;
    reg [4:0]rmd;
    reg [4:0]rmd1;
    reg [4:0]rmd2;
    reg [4:0]rmd3;
    
    initial begin
    snr = 27'b111111111111100000000000000;
    led = 16'b1000000000000001;
    rmd = 5'b01010;
    rmd1 = 5'b10111;
    rmd2 = 5'b10110;
    rmd3 = 5'b00110;
    end
    
    assign s1 = clkdiv2[25:22];
    assign s = clkdiv[19:18];
    assign aen = 4'b1111;   // all turned off initially

    always @(posedge clk)
    begin
   // rmd = move_left[26:22];
   if(clkdiv[17]==1) rmd = rmd+7;
   if(move_left[25]==1) rmd1 = rmd1+3;
   if(move_left[27]==1) rmd2 = rmd2+5;
   if(clkdiv[19]==1) rmd3 = rmd3*s;
        if( btnC == 1 )
        begin
            seg_0=5'b11111;
            seg_1=5'b11111;
            seg_2=5'b11111;
            seg_3=5'b00001;
            move_left=0;
            snr =27'b111111111111100000000000000;
            clkdiv2 <= 0;
            score=0;
            display_score=0;
        end
        move_left = move_left + 1;
        if( prev_btnU==0 && btnU==1 )
        begin
            prev_btnU = 1;
            if(seg_3==5'b00001)
                seg_3 = 5'b00000;
            else if(seg_3==5'b00010)
                seg_3 = 5'b00001;
            else if(seg_3==5'b00100)
                seg_3 = 5'b00011;
            else if(seg_3==5'b00011)
                seg_3 = 5'b00000;
        
        end
        else if( prev_btnD==0 && btnD==1 )
        begin
            prev_btnD = 1;
            if(seg_3==5'b00000)
                seg_3 = 5'b00001;
            else if(seg_3==5'b00001)
                seg_3 = 5'b00010;
            else if(seg_3==5'b00011)
                seg_3 = 5'b00100;
            else if(seg_3==5'b00100)
                seg_3 = 5'b00010;
        end
                else if( prev_btnL==0 && btnL==1 )
        begin
            prev_btnL = 1;
            if(seg_3==5'b00000)
                seg_3 = 5'b00011;
            else if(seg_3==5'b00001)
                seg_3 = 5'b00100;
            else if(seg_3==5'b00010)
                seg_3 = 5'b00100;
        end
                else if( prev_btnR==0 && btnR==1 )
        begin
            prev_btnR = 1;
            if(seg_3==5'b00100)
                seg_3 = 5'b00001;
            else if(seg_3==5'b00011)
                seg_3 = 5'b00001;
        end

        if( seg_3 > 4 && seg_3 < 9 )        // there was some strage error where user input went to state 3, which should never happen
            seg_3 = 5'b00001;
        if(btnU==0)
            prev_btnU = 0;
        if(btnD==0)
            prev_btnD = 0;
        if(btnL==0)
            prev_btnL = 0;
        if(btnR==0)
            prev_btnR = 0;

        rand_no = ( rand_no*rmd + rand_no*s +rmd3+rmd3*seg_0+rmd3*rand_no+rmd2+rmd2*rand_no + clkdiv[19:15] +clkdiv[14:11]+s*clkdiv[2:0]+ seg_0*rmd + rmd*seg_1 + rand_no*rmd1 +  seg_0*rmd1 + rmd1*seg_1+ seg_2 +seg_3 +rmd1+ rmd*btnU + rmd*btnD + rmd*btnL + rmd*btnR + rmd  + 113) % 16 ;
        if(score==7) snr= 27'b110000000000000000000000000;
        else if(score==17) snr= 27'b100000000000000000000000000;
        else if(score==27) snr= 27'b011111111100000000000000000;
        if(move_left==snr)
        begin
                    move_left = 27'b000000000000000000000000000;
            if( ( seg_3 == 0 && ( seg_2 == 0 || seg_2 == 6 || seg_2 == 5 || seg_2 == 6 || seg_2 == 10 || seg_2 == 15) ) || ( seg_3 == 1 && ( seg_2 == 1 || seg_2 == 6 || seg_2 == 7 || seg_2 == 13 || seg_2 == 14 || seg_2 == 15) ) || ( seg_3 == 2 && ( seg_2 == 2 || seg_2 == 7 || seg_2 == 5 || seg_2 == 11 || seg_2 == 12 || seg_2 == 15) ) || (seg_3 == 3  && (seg_2 ==3 || seg_2 == 8 || seg_2 == 9 || seg_2 == 11 || seg_2 == 13)) || (seg_3 == 4 && (seg_2 == 4 || seg_2 == 8 || seg_2 == 10 || seg_2 == 12 || seg_2 == 14)) || display_score == 1 )
            begin
                seg_3 = 16;
                seg_2 = 17;
                seg_1 = 18;
                seg_0 = 19;
                display_score = display_score + 1;
            end
            else if( display_score == 2 )
            begin
                score = score - 3;
                seg_0 = ( score % 10 ) + 20;
                score = score / 10;
                seg_1 = ( score % 10 ) + 20;
                score = score / 10;
                seg_2 = ( score % 10 ) + 20;
                score = score / 10;
                seg_3 = ( score % 10 ) + 20;
                display_score = display_score + 1;      // make it 3 so that it doesn't enter any if condition until reset is pressed
                
            end
            else if( display_score != 3 )
            begin
                seg_2 = seg_1;
                seg_1 = seg_0;
                seg_0 = rand_no;
                score = score + 1;
            end
        end

        case(s)
            0:begin digit = seg_0;end
            1:begin digit = seg_1;end
            2:begin digit = seg_2;end
            3:begin digit = seg_3;end
            default:digit = seg_0;
        endcase
        clkdiv = clkdiv+1;
        if(display_score != 2 && display_score != 3)
        begin
            clkdiv2 = clkdiv2 +1;
        end
        else
        begin
            clkdiv2 = 0;
        end
    end

    // decoder or truth-table for 7 a_to_g display values
    always @(*)
    begin
        case(digit)
            0:  seg = 7'b1111110;
            1:  seg = 7'b0111111;
            2:  seg = 7'b1110111;
            3:  seg = 7'b1011111;
            4:  seg = 7'b1101111;
            5:  seg = 7'b1110110;
            6:  seg = 7'b0111110;
            7:  seg = 7'b0110111;
            8:  seg = 7'b1001111;
            9:  seg = 7'b1011110;
            10: seg = 7'b1001110;
            11: seg = 7'b1000111;
            12: seg = 7'b1100111;
            13: seg = 7'b0011111;
            14: seg = 7'b0101111;
            15: seg = 7'b0110110;
            16:  seg = 7'b1000111;     // alphabet L
            17:  seg = 7'b1000000;     // alphabet O
            18:  seg = 7'b0010010;     // alphabet S
            19:  seg = 7'b0000110;     // alphabet E
            20: seg = 7'b1000000;     // number 0
            21: seg = 7'b1111001;     // number 1
            22: seg = 7'b0100100;     // number 2
            23: seg = 7'b0110000;     // number 3
            24: seg = 7'b0011001;     // number 4
            25: seg = 7'b0010010;     // number 5
            26: seg = 7'b0000010;     // number 6
            27: seg = 7'b1111000;     // number 7
            28: seg = 7'b0000000;     // number 8
            29: seg = 7'b0011000;     // number 9
            default: seg = 7'b1111111;
        endcase
        an=4'b1111;
        if(aen[s] == 1)
            an[s] = 0;
    end
    
    always @(posedge clk)
    begin
        case(s1)
           0: led = 16'b1111111111111111;
           1: led = 16'b0100000000000010;
           2: led = 16'b0010000000000100;
           3: led = 16'b0001000000001000;
           4: led = 16'b0000100000010000;
           5: led = 16'b0000010000100000;
           6: led = 16'b0000001001000000;
           7: led = 16'b0000000110000000;
           8: led = 16'b0000001001000000;
           9: led = 16'b0000010000100000;
           10: led = 16'b0000100000010000;
           11: led = 16'b0001000000001000; 
           12: led = 16'b0010000000000100; 
           13: led = 16'b0100000000000010; 
           14: led = 16'b1000000000000001; 
           15: led = 16'b1000000000000001;
      default: led = 16'b1111111111111111;
          endcase
    end

endmodule