module claa(clk,x,y,ci,s,cj,gj,pj);
input [3:0] x;
input [3:0] y;
input wire clk; 
input  ci;  
output reg [3:0] s; 
output reg cj;
output reg gj;
output reg pj; 
reg [3:0] c; reg [3:0] g; reg [3:0] p; 
initial
	begin
	  cj=0;	  gj=0;	  pj=0;
	  c=4'b0000;	  g=4'b0000;
	  p=4'b0000;	  s=4'b0000;
	end
always @(posedge clk)
	begin 
		//Full Adder 0
		s[0]<=x[0]^y[0]^ci;
		//Generador y Propagación 0
		p[0]=x[0]||y[0];
		g[0]=x[0]&&y[0];
		//Carry interno C1
		c[1]<=g[0]||(p[0]&&ci);
		//Full Adder 1
		s[1]<=x[1]^y[1]^c[1];
		//Generador y Propagación 1
		p[1]=x[1]||y[1];
		g[1]=x[1]&&y[1];
		//Carry interno C2
		c[2]<=g[1]||(p[1]&&c[1]);		
		//Full Adder 2
		s[2]<=x[2]^y[2]^c[2];
		//Generador y Propagación 2
		p[2]=x[2]||y[2];
		g[2]=x[2]&&y[2];
		//Carry interno C3
		c[3]<=g[2]||(p[2]&&c[2]);
		//Full Adder 3
		s[3]<=x[3]^y[3]^c[3];
		//Generador y Propagación 3
		p[3]=x[3]||y[3];
		g[3]=x[3]&&y[3];
		//Carry de Salida
		cj<=g[3]||(p[3]&&c[3]);
		//Generación y propagación para el grupo. 
		gj=g[3]||(p[3] && g[2])||(p[3] && p[2] && g[1])||(p[3] && p[2] && p[1] && g[0]);
		pj=p[3] && p[2] && p[1] && p[0];
	end
endmodule

module sumador(x,y,clk,s);
input [7:0] x;
input [7:0] y;
input clk;
output [7:0] s;
reg ci=1'b0;
wire cj;
wire gj1;
wire pj1;
wire gj2;
wire pj2;
wire cj2;

claa claa1(clk,x[3:0],y[3:0],ci,s[3:0],cj,gj1,pj1);
claa claa2(clk,x[7:4],y[7:4],cj,s[7:4],cj2,gj2,pj2);

endmodule 

module multiplicador(x,y,suma,A,B,MQ,clk);
input [7:0] x;
input [7:0] y;
input [7:0] suma;
input clk;
output reg [7:0] A;
output reg [7:0] B;
output reg [7:0] MQ;
integer cont;
integer cont_final;
 
initial
	begin
		cont=0;
		cont_final=0;
		A=8'b00000000;
		MQ=y;
		if(MQ[0]==1)begin
			B=x;
		end
		else begin
			B=0;
		end
	end
always @(posedge clk)
	begin
		if (cont_final<8) begin
		
			if(cont==0)
				begin
					if (MQ[0] == 1) begin
						B=x; 
					end
					else begin
						B=0;
					end
				end
			cont=cont+1;
			if (cont == 8) begin
				A=suma;
				MQ=MQ >>> 1;
				MQ[7]=A[0];
				A=A >>> 1;
				cont=0;
				cont_final=cont_final+1;
			end
		end
	end
always @(x,y)
	begin
		cont=0;
		cont_final=0;
		A=8'b00000000;
		if(MQ[0]==1)begin
			B=x;
		end
		else begin
			B=0;
		end
		MQ=y;
	end
endmodule // 


module tester(clk,x,y);     
output reg [7:0] x;
output reg [7:0] y;
output reg clk;
    initial    
	begin        
		$dumpfile("Multiplicador.vcd");  
        	$dumpvars;
		x=8'b00000110;
		y=8'b00001101;
        clk=0;  #150 $finish;
    	end
    always
    begin
        #1 clk = !clk;
    end
endmodule

module testbench;
    wire clk;
    wire [7:0]x;
    wire [7:0]y;
    wire [7:0]s;
	wire [7:0] A;
    wire [7:0] B;
	wire [7:0] MQ;
	sumador Suma(A,B,clk,s);
	multiplicador Mult (x,y,s,A,B,MQ,clk);
    tester t(clk,x,y);
endmodule
