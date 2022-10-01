module final_project (
	input reset,
	input turn_right, 
	input clk, 
	output HS,
	output VS,
	output reg[3:0] VGA_R,
	output reg[3:0] VGA_G,
	output reg[3:0] VGA_B,
	output [6:0] hex0,
	output [6:0] hex1
);
	//Hcnt, Vcnt for vga
	wire[9:0] Hcnt;
	wire[9:0] Vcnt;
	
	//head(left, top, right, bottom) 
	reg[9:0] head_left_init, head_right_init, head_top_init, head_bottom_init; 	  
	reg[9:0] head_left, head_right, head_top, head_bottom; 
	   
	reg[9:0] body_left[20], body_right[20], body_top[20], body_bottom[20]; 
	
	reg[9:0] food_left,food_right,food_top,food_bottom;
	reg[9:0] food_left_init, food_right_init, food_top_init, food_bottom_init; 
	
	initial begin 
		//head
		head_left_init <= 10'd260;
		head_right_init <= 10'd280;
		head_top_init <= 10'd230;
		head_bottom_init <= 10'd250; 
		
		//food
		food_left_init <= 10'd220;
		food_right_init <= 10'd230;
		food_top_init <= 10'd90;
		food_bottom_init <= 10'd100; 
		
		//head
		head_left <= 10'd260;
		head_right <= 10'd280;
		head_top <= 10'd230;
		head_bottom <= 10'd250; 
					 
		//food
		food_left <= 10'd220;
		food_right <= 10'd230;
		food_top <= 10'd90;
		food_bottom <= 10'd100; 
	end

	reg clk_25M;
	//generate a half frequency clock of 25MHz(用來做VGA顯示)
	always@(posedge(clk))
	begin
		clk_25M <= ~clk_25M;
	end
	
	//200ms除頻器
	reg[31:0] counter_200ms;
	reg clk_200ms;
	always@(posedge(clk))
	begin
		if (counter_200ms == 5000000)
		begin
			counter_200ms = 0;
			clk_200ms = ~clk_200ms;
		end
		else
		begin
			counter_200ms = counter_200ms + 1;
		end
	end
	
	//500ms除頻器
	reg[31:0] counter_500ms;
	reg clk_500ms;
	parameter COUNT_500ms = 12500000;
	always@(posedge(clk))
	begin
		if (counter_500ms == COUNT_500ms)
		begin
			counter_500ms = 0;
			clk_500ms = ~clk_500ms;
		end
		else
		begin
			counter_500ms = counter_500ms + 1;
		end
	end
	 
	reg[2:0] move_direction;
	
	//向右轉
	parameter left_distance = 10;
	reg[9:0] left_total;
	parameter right_distance = 10;
	reg[9:0] right_total;
	parameter down_distance = 10;
	reg[9:0] down_total;
	parameter up_distance = 10;
	reg[9:0] up_total;
	
	
	always@(posedge(turn_right) )
	begin 
			move_direction  = move_direction +1;
			if(move_direction == 4)
				move_direction  = 0;
	end 
	
	
	always@(posedge(clk_200ms))
	  begin 
			if(move_direction == 0) 
				left_total = left_total + left_distance ;
			if(move_direction == 2) 
				right_total = right_total + right_distance ;
			if(move_direction == 3)
				up_total = up_total + up_distance  ;
			if(move_direction == 1)
				down_total = down_total + down_distance  ; 
		end
		
	//refresh head pos
   reg [8:0] temp1;  //for循環變量 
	always@(posedge(clk_200ms)) begin
		if(!reset) begin
			//head
			head_left_init <= 10'd260;
			head_right_init <= 10'd280;
			head_top_init <= 10'd230;
			head_bottom_init <= 10'd250; 
			
			//head
			head_left <= 10'd260;
			head_right <= 10'd280;
			head_top <= 10'd230;
			head_bottom <= 10'd250; 
						 
			//food
			food_left <= 10'd220;
			food_right <= 10'd230;
			food_top <= 10'd90;
			food_bottom <= 10'd100; 
		end
		
		//body  
		for( temp1= 0 ; temp1 + 1 < body_num ; temp1=temp1+1'b1 ) begin //循環次數固定  
			body_left[temp1+1'b1] <= body_left[temp1];
			body_right[temp1+1'b1] <= body_right[temp1] ;
			body_bottom[temp1+1'b1] <= body_bottom[temp1];
			body_top[temp1+1'b1] <= body_top[temp1] ;
		end
				
		if(body_num >= 1) begin
			body_left[0]  <=  head_left;
			body_right[0] <=  head_right;
			body_top[0]  <=  head_top;
			body_bottom[0]  <=  head_bottom; 
		end
				
		//head
		head_left <= head_left_init - left_total+ right_total;
		head_right <= head_right_init - left_total + right_total;
		head_top <= head_top_init + up_total - down_total  ;
		head_bottom <= head_bottom_init  + up_total - down_total ;
			
		//food
		food_left <= food_left_init ;
		food_right <= food_right_init ;
		food_top <= food_top_init;
		food_bottom <= food_bottom_init;	
	end
			
	reg[31:0] score;
	reg [3:0] body_num;
	
	//偵測吃果子
	always@(posedge(clk_200ms)) begin
		if(!reset) begin
			body_num = 1;
			score = 0;
		end
		
		//吃到果子
		if(head_left <= food_left && head_top <= food_top  && head_right>=food_right && head_bottom >= food_bottom) begin
			score = score + 1;
				
			//food改變位置
			food_left_init <= (food_left_init + 10'd180) % 10'd640;
			food_right_init <= (food_right_init + 10'd180) % 10'd640;
			food_top_init <= (food_top_init + 10'd80) % 10'd480;
			food_bottom_init <= (food_bottom_init + 10'd80) % 10'd480;
					
			//body變長  
			body_num = body_num+1;
		end
	end
	
	//VGA顯示
	vga_display screen(
	.clk(clk_25M),//50MHz
	.reset(reset),
	.Hcnt(Hcnt),
	.Vcnt(Vcnt),
	.hs(HS),
	.vs(VS),
	);
	
	//七段顯示器 顯示得分
	out_port_seg scoreboard(
	.in(score),
	.out1(hex1),
	.out0(hex0)
	);
	 
	//game over
	reg finish = 1;
	
   reg [8:0] temp2;  //for循環變量
	always@(posedge clk_25M) begin
		if(!reset)
			finish = 0;
		if (finish == 0) begin 
			//head 
		   if (Hcnt >= head_left && Hcnt < head_right 
				&& Vcnt >= head_top && Vcnt < head_bottom) begin
				VGA_R = 4'd10;
				VGA_G = 4'd8;
				VGA_B = 4'd8;
			end 
			//food
			else if (Hcnt >= food_left && Hcnt < food_right 
				&& Vcnt >= food_top && Vcnt < food_bottom) begin
				VGA_R = 4'd10;
				VGA_G = 4'd7;
				VGA_B = 4'd7;
			end  
			else begin
				//sky  
				VGA_R = 4'b0000;
				VGA_G = 4'b0000;
				VGA_B = 4'b0000; 
					
				//body
				if(body_num >= 0)	begin
					for( temp2 = 0 ; temp2< body_num ; temp2=temp2+1'b1 ) begin
						if( Hcnt >= body_left[temp2] && Hcnt <  body_right[temp2] 
							&& Vcnt >= body_top[temp2] && Vcnt <  body_bottom[temp2]) begin 
							VGA_R = 4'd7;
						 	VGA_G = 4'd7;
							VGA_B = 4'd7;
						end
						//check finish			
						if(head_left == 0 || head_right == 640
							|| head_top == 0 || head_bottom == 480) begin
							finish = 1;
						end
					end 	
				end 
			end
		end
		//game over
		else begin
			VGA_R = 4'd15;
			VGA_G = 4'd15;
			VGA_B = 4'd15;
		end
	end
endmodule

//計分
module out_port_seg(in,out1,out0);
	input [31:0] in;
	output [6:0] out1,out0;
	
	reg [3:0] num1,num0;

	sevenseg display_1( num1, out1 );
	sevenseg display_0( num0, out0 );
	
	always @ (in)
	begin
		num1 = ( in / 10 ) % 10;
		num0 = in % 10;
	end
endmodule

//七段顯示器
module sevenseg(data, ledsegments);
	input [3:0] data;
	output ledsegments;
	reg [6:0] ledsegments;
	
	//七段顯示器數字
	always @ (*)
		case(data)
			0: ledsegments = 7'b100_0000;
			1: ledsegments = 7'b111_1001;
			2: ledsegments = 7'b010_0100;
			3: ledsegments = 7'b011_0000;
			4: ledsegments = 7'b001_1001;
			5: ledsegments = 7'b001_0010;
			6: ledsegments = 7'b000_0010;
			7: ledsegments = 7'b111_1000;
			8: ledsegments = 7'b000_0000;
			9: ledsegments = 7'b001_0000;
			default: ledsegments = 7'b111_1111;
		endcase
endmodule

module vga_display(
	input clk,
	input reset,
	output reg[9:0] Hcnt,
	output reg[9:0] Vcnt,
	output hs,
	output vs
);
	assign vs = ~(Vcnt >= visible_area_v + front_porch_v && Vcnt < visible_area_v + front_porch_v + sync_pulse_v);
	assign hs = ~(Hcnt >= visible_area_h + front_porch_h && Hcnt < visible_area_h + front_porch_h + sync_pulse_h);
	
	//640x480 60Hz VGA時序參數
	parameter integer visible_area_h = 640;
	parameter integer front_porch_h = 16;
	parameter integer sync_pulse_h = 96;
	parameter integer back_porch_h = 48;
	parameter integer whole_line_h = 800;

	parameter integer visible_area_v = 480;
	parameter integer front_porch_v = 10;
	parameter integer sync_pulse_v = 2;
	parameter integer back_porch_v = 33;
	parameter integer whole_line_v = 525;
	
	//hs & vs刷新
	always@(posedge(clk)) 
	begin
		if (!reset)
		begin
			Hcnt = 0;
			Vcnt = 0;
		end

		else
		begin
			Hcnt = Hcnt + 1;
			if( Hcnt == whole_line_h)
			begin
				Hcnt = 0;
				Vcnt = Vcnt + 1;
				if( Vcnt == whole_line_v)
					Vcnt = 0;
			end
		end
	end
endmodule
