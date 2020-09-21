module divisor (x,y,A,MQ,clk);
input [7:0] x;
input [7:0] y;
input clk;
output reg [7:0] A;
output reg [7:0] MQ;
reg [7:0] B;
integer cont;
reg q;

initial
    begin
        A=8'b00000000;
        MQ=x;
        cont=0;
        q=1'b0;
        B=8'b00000000;
    end

always @(posedge clk)
    begin
        if(cont < 9)
        begin
            if(cont!=8) begin
                A=A <<< 1;
		        A[0]=MQ[7];
		        MQ=MQ <<< 1;
                q=A[7];
                if (q==1) begin
                    B=y;
                    MQ[0]=0;
                end
                if(q==0) begin
                    B=-y;
                    MQ[0]=1;
                end
            end
            else 
                if (cont==8) begin
                    MQ=MQ <<< 1;
                    if (q==1) begin
                        MQ[0]=0;
                    end
                    if(q==0) begin
                        MQ[0]=1;
                    end
                end
            cont=cont+1;
        end
    end

always @(negedge clk)
    begin
        if (cont==9) begin
            if(q==1)
                A=A+y;
        end
        else begin
            if(cont!= 0)begin
                A=A+B;
            end
        end
    end 

always @(x,y)
	begin
		A=8'b00000000;
        MQ=x;
        cont=0;
        q=1'b0;
        B=8'b00000000;
	end
endmodule 

module tester(x,y,clk);
output reg [7:0] x;
output reg [7:0] y;
output reg clk;

initial
    begin
        $dumpfile("Divisor.vcd");
        $dumpvars;
        x=8'b01110101;
        y=8'b00001010;
        clk=0;
        #100 $finish;
    end
always
    begin
        #1 clk=!clk;
    end
endmodule

module testbench;
    wire clk;
    wire [7:0] x;
    wire [7:0] y;
    wire [7:0] A;
    wire [7:0] MQ;

    divisor div (x,y,A,MQ,clk);
    tester t(x,y,clk);

endmodule 