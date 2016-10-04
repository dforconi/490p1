`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 			Darryl Forconi darrylfo
// 
// Create Date:    20:30:58 06/14/2016 
// Design Name: 
// Module Name:    project1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module project1(clk, cathodes, anodes, switchA, ledA, btn, switchB);

	input [3:0] btn; // buttons 3-0
	input clk;
	input [3:0] switchA; // switches 3-0 for LEDs
	input [3:0] switchB; // switches 7-4 for display
	output [7:0] cathodes;
	output [3:0] anodes;
	output [3:0] ledA;  // leds for switches 3-0
	reg [7:0] cathodes;
	reg [3:0] anodes;
	reg [4:0] dig; // change to cstate?
	reg [3:0] ledA; //reg for leds for switches 3-0
	reg [3:0] display; // for switches and display
	reg slow_clock;
	integer count;
	reg [4:0] cstate3; // current 4 bit value assigned to button 3
	reg [4:0] cstate2;
	reg [4:0] cstate1;
	reg [4:0] cstate0;
	
always @(posedge clk)
	create_slow_clock(clk, slow_clock);

		
always @(posedge slow_clock)
	begin
		case (anodes)	// looks at which display currently enabled, assigns enable to next display
			4'b 1110: anodes=4'b 1101; // 0 enabled, send to 1
			4'b 1101: anodes=4'b 1011;	// 1 enabled, send to 2
			4'b 1011: anodes=4'b 0111;	// 2 enabled, send to 3
			4'b 0111: anodes=4'b 1110;	// 3 enabled, send to 0
			4'b 1111: anodes=4'b 1110;	// none enabled, send to 0
			default: anodes=1111;	// default none enabled
		endcase
		case (anodes)	// what each segment should display when it's enabled
			4'b 0111: 	begin
								dig[4] = cstate3[4];	// used for enable after 1st press
								dig[3] = cstate3[3];	//	sec 3 enabled, far left  (should be cstate3)
								dig[2] = cstate3[2];
								dig[1] = cstate3[1];
								dig[0] = cstate3[0];
							end
			4'b 1011: 	begin
								dig[4] = cstate2[4];
								dig[3] = cstate2[3];	// seg 2 enabled so displays from calc_cathode_value with dig=1 passed in
								dig[2] = cstate2[2];
								dig[1] = cstate2[1];
								dig[0] = cstate2[0];
							end
			4'b 1101: 	begin
								dig[4] = cstate1[4];
								dig[3] = cstate1[3];	// seg 1 engabled  (should display cstate1)
								dig[2] = cstate1[2];
								dig[1] = cstate1[1];
								dig[0] = cstate1[0];
							end
			4'b 1110: 	begin
								dig[4] = cstate0[4];
								dig[3] = cstate0[3];	// seg 0 engabled (should display cstate0)
								dig[2] = cstate0[2];
								dig[1] = cstate0[1];
								dig[0] = cstate0[0];
							end
		endcase
		cathodes=calc_cathode_value(dig);	// assigns values to cathodes to output from task
	end
	
always @(btn)
	case (btn) // determine which button pressed and which cstate to update with switch info
		4'b 1000: 	begin
							cstate3[4] = 1'b 0;		// enable display 3
							cstate3[3] = switchB[3];// button 3 pressed, update cstate3 with value from switchs
							cstate3[2] = switchB[2];
							cstate3[1] = switchB[1];
							cstate3[0] = switchB[0];
						end
		4'b 0100:	begin 
							cstate2[4] = 1'b 0;
							cstate2[3] = switchB[3];	// button 2 pressed, update w/ value from switches
							cstate2[2] = switchB[2];
							cstate2[1] = switchB[1];
							cstate2[0] = switchB[0];
						end
		4'b 0010: 	begin
							cstate1[4] = 1'b 0;
							cstate1[3] = switchB[3];	// button 1
							cstate1[2] = switchB[2];
							cstate1[1] = switchB[1];
							cstate1[0] = switchB[0];
						end
		4'b 0001: 	begin
							cstate0[4] = 1'b 0;
							cstate0[3] = switchB[3];	// button 0
							cstate0[2] = switchB[2];
							cstate0[1] = switchB[1];
							cstate0[0] = switchB[0];
						end
	endcase
			
		
	function [7:0] calc_cathode_value;
		input [4:0] dig;	// input position of switches 7-4 as 4 binary bits plus enable bit
		begin
			case (dig)	
			5'b00000: calc_cathode_value = 8'b 11000000; // 1st bit for decimal, output 0 to cathodes 
			5'b00001: calc_cathode_value = 8'b 11111001;	// 1
			5'b00010: calc_cathode_value = 8'b 10100100;	// 2
			5'b00011: calc_cathode_value = 8'b 10110000;
			5'b00100: calc_cathode_value = 8'b 10011001;
			5'b00101: calc_cathode_value = 8'b 10010010;
			5'b00110: calc_cathode_value = 8'b 10000010;
			5'b00111: calc_cathode_value = 8'b 11111000;
			5'b01000: calc_cathode_value = 8'b 10000000;
			5'b01001: calc_cathode_value = 8'b 10010000;
			5'b01010: calc_cathode_value = 8'b 10001000;
			5'b01011: calc_cathode_value = 8'b 10000011;
			5'b01100: calc_cathode_value = 8'b 11000110;
			5'b01101: calc_cathode_value = 8'b 10100001;
			5'b01110: calc_cathode_value = 8'b 10000110;
			5'b01111: calc_cathode_value = 8'b 10001110;
			
			5'b10000: calc_cathode_value = 8'b 11111111; // display off when 1st bit of display is 1
			5'b10001: calc_cathode_value = 8'b 11111111;
			5'b10010: calc_cathode_value = 8'b 11111111;
			5'b10011: calc_cathode_value = 8'b 11111111;
			5'b10100: calc_cathode_value = 8'b 11111111;
			5'b10101: calc_cathode_value = 8'b 11111111;
			5'b10110: calc_cathode_value = 8'b 11111111;
			5'b10111: calc_cathode_value = 8'b 11111111;
			5'b11000: calc_cathode_value = 8'b 11111111;
			5'b11001: calc_cathode_value = 8'b 11111111;
			5'b11010: calc_cathode_value = 8'b 11111111;
			5'b11011: calc_cathode_value = 8'b 11111111;
			5'b11100: calc_cathode_value = 8'b 11111111;
			5'b11101: calc_cathode_value = 8'b 11111111;
			5'b11110: calc_cathode_value = 8'b 11111111;
			5'b11111: calc_cathode_value = 8'b 11111111;
			endcase
		end
	endfunction
	
task create_slow_clock;
	
	input clock;
	inout slow_clock;
	integer count;
	
		begin
			if (count > 100000)
			begin
				count = 0;
				slow_clock = ~slow_clock;
			end
			count = count + 1;
		end
endtask

always @(switchA) 	// control LEDs
	begin
		ledA[0]=switchA[0];
		ledA[1]=switchA[1];
		ledA[2]=switchA[2];
		ledA[3]=switchA[3];
	end
	
initial			// initialize with all displays off until corresponding button pressed
		begin
			cstate3 = 5'b 11111;
			cstate2 = 5'b 11111;
			cstate1 = 5'b 11111;
			cstate0 = 5'b 11111;
		end
		
endmodule
