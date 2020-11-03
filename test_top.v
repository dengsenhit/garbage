module SG_top(
    clk,
    rst_n,
    bps_x,
    bps_y,
	en,
    x_max,
    x_min,
    y_max,
    y_min
   );

input         clk   ;
input         rst_n ;
output        bps_x ;
output        bps_y ;
input		  en;
input  [10:0]	x_max;		//?¹æ?ä½?ç½?
input  [10:0]	x_min;
input  [9:0]	y_max;
input  [9:0]	y_min;


wire   [1:0]   sel_x ;
wire   [1:0]   sel_y ;
wire           en1   ;

reg   [1:0]   sel_x_1 ;
reg   [1:0]   sel_y_1 ;

reg    [31:0]   cnt;

parameter TIME = 75_000_000;
/*key_filter U2 (
    .Clk(clk),
    .Rst_n(rst_n),
    .key_in(en),
    .key_flag(en1),
    .key_state()
);
*/
bps_top u1 (
    .clk(clk),
    .rst_n(rst_n),
    .bps_x(bps_x),
    .bps_y(bps_y),
    .sel_x(sel_x),
    .sel_y(sel_y)
);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)
        cnt<= 0;
    else if(cnt == TIME)
        cnt <= 0;
    else cnt <= cnt +1; 
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
       sel_x_1  <= 2;
       sel_y_1  <= 2;
    end  	
else 
	if ((cnt == TIME)&(~en))
		if(x_max < 448)begin // zuo
            if(y_max > 538)  begin// xia
                sel_x_1  <= 3;
                sel_y_1  <= 3;
                end
            else if(y_min < 268) begin    //shang 
                sel_x_1  <= 3;
                sel_y_1  <= 1;
                end
            else
                sel_x_1 <= 3 ;
end
    else if(x_min > 900)  begin //you
             if(y_max > 538)  begin// xia
                sel_x_1  <= 1;
                sel_y_1  <= 3;
                end
            else if(y_min < 268) begin    //shang 
                sel_x_1  <= 1;
                sel_y_1  <= 1;
                end
            else
                sel_x_1 <= 1 ;
end
    else if(y_max > 538) //xia
          sel_y_1  <= 3;
    else if(y_min < 268)  //shang
          sel_y_1  <= 1;
end

assign  sel_x = sel_x_1;
assign  sel_y = sel_y_1;

endmodule