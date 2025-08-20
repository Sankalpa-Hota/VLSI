module FSM(
  input In1,
  input RST,
  input CLK, 
  output reg Out1
);
reg cstate,nstate;
parameter A=2'b00,
		  B=2'b01,
		  C=2'b10;
always @(posedge CLK or negedge RST)
begin:state_memory
		if(!RST)
			cstate<=cstate;
		else
		    cstate<=nstate;
end
always@(cstate or In1)
begin :Nextstate_logic
		case(cstate)
			A : if(In1==1'b1) nstate= B;else nstate = A;
			B : if(In1==1'b1) nstate= C;else nstate = C;
			C : if(In1==1'b1) nstate= A;else nstate = C;
		endcase
end
always@(cstate)
begin
	case(cstate)
		A : Out1= 1'b0;
		B : Out1= 1'b0;
		C : Out1= 1'b1;
	endcase
end
endmodule