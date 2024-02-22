module HC05(
    input sys_clk,
    input rx,
    output tx,
    output [2:0]led
);                                                                             
    wire[7:0]message;                                                           
    wire sig;                                                                   
   
    uart_r uart_r_1(.clk(sys_clk),.rx(rx),.message(message),.over(sig));      
    uart_t uart_t_1(.clk(sys_clk),.tx(tx),.message(message),.run(sig));         
   
    assign led[0]=message[0];                                                   
    assign led[1]=message[1];
	 assign led[2]=message[2];
endmodule

module uart_r(
    input clk,
    input wire rx,
    output reg [7:0]message,
    output reg over=0
);                                                                                                   
    reg [12:0]cnt_clk=0;                              
    reg [4:0]cnt_message=0;                           
    reg [7:0]message_mid=0;                           
    reg r_start=1;                                       
    always @(posedge clk)
    begin
        if (rx==0&&r_start==1) begin
            cnt_clk<=cnt_clk+1;
            if (cnt_clk==2604&&rx==0) begin
                r_start<=0;
                cnt_clk<=0;
                cnt_message<=0;
                message_mid<=0;
            end
        end                                            
        else if (r_start==0) begin
            cnt_clk<=cnt_clk+1;
            if (cnt_clk==5208) begin                   
                message_mid[cnt_message]<=rx;
                cnt_message<=cnt_message+1;
                cnt_clk<=0;
            end                                            
            else if (cnt_message==8) begin            
                if (cnt_clk==3000) begin                
                    over<=1;
                end
                if (cnt_clk==5000) begin                
                    over<=0;
                    cnt_clk<=0;
                    cnt_message<=0;
                    r_start<=1;
                    message<=message_mid;
                    message_mid<=0;
						  
                end
            end
        end                                          
        else begin
            r_start<=1;
            over<=0;
        end
    end

endmodule

module uart_t(
    input wire [7:0]message,
    input clk,
    output reg tx=1,
    input wire run
    );                                                                

    reg [12:0]cnt_clk=0;
    reg [4:0]cnt_message=0;
    reg t_start=1;
   
    always @(posedge clk) begin
        if (run==1&&t_start==1) begin
            t_start<=0;
            cnt_clk<=0;
        end
        else if (run==0&&t_start==0&&cnt_message==0) begin           
            tx<=0;
            cnt_clk<=cnt_clk+1;
            if (cnt_clk==5208) begin
                tx<=message[cnt_message];
                cnt_clk<=0;
                cnt_message<=1;
                t_start<=0;
            end
        end
        else if (cnt_message>=1) begin
            cnt_clk<=cnt_clk+1;
            if (cnt_clk==5208) begin
                cnt_clk<=0;
                if (cnt_message==8) begin
                    tx<=1;
                    t_start<=1;
                    cnt_message<=0;
                end
                else begin
                    tx<=message[cnt_message];
                    cnt_message<=cnt_message+1;
                end
            end
        end
        else begin
            tx=1;
        end
    end
endmodule
