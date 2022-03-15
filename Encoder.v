

module Encoder_Module (

  input Clock,  //Should be fed with a clock signal that is at least 2x faster than
	              //the encoder quadrature signal is likely to change
	
	input Reset,

  input Encoder_PinA_In, //Quadrature signal from encoder
	input Encoder_PinB_In,

	output [7:0] Counter_Out //Outputs 8bit number of current encoder location
);

  //-------------------------------
  //-------------------------------
  //State Machine - State Selection

  parameter EncoderState_Reset = 0;
	parameter EncoderState_Step1_Inc  = 1;   //A = Low, B = Low
	parameter EncoderState_Step1_Dec  = 2;
	parameter EncoderState_Step1_Idle = 3;
	parameter EncoderState_Step2_Inc  = 4;   //A = High, B = Low
	parameter EncoderState_Step2_Dec  = 5;
	parameter EncoderState_Step2_Idle = 6;
	parameter EncoderState_Step3_Inc  = 7;   //A = High, B = High
	parameter EncoderState_Step3_Dec  = 8;
	parameter EncoderState_Step3_Idle = 9;
	parameter EncoderState_Step4_Inc  = 10;  //A = Low, B = High
	parameter EncoderState_Step4_Dec  = 11;
	parameter EncoderState_Step4_Idle = 12;

  reg [3:0] EncoderStateReg;

	always @ (posedge Clock or posedge Reset)
	begin
	  
		if (Reset)
		begin
		  EncoderStateReg <= EncoderState_Reset;
		end else
		begin
		
		  case (EncoderStateReg)
			
			  //-------------------------
			  //Reset - Set Initial State
			  EncoderState_Reset:
				  if (~Encoder_PinA_In)
					begin
					  
						if (~Encoder_PinB_In)
						  EncoderStateReg	<= EncoderState_Step1_Idle;
						else
						  EncoderStateReg <= EncoderState_Step4_Idle;
						
					end else
					begin
					
					  if (~Encoder_PinB_In)
						  EncoderStateReg <= EncoderState_Step2_Idle;
						else
						  EncoderStateReg <= EncoderState_Step3_Idle;
					
					end
			
			  
				//-------------------------
				//Step 1 - A = Low, B = Low
			
			  //Step 1 - Inc
				Encoder_State_Step1_Inc:
				  EncoderStateReg <= EncoderState_Step1_Idle;
					
				//Step 1 - Dec
				Encoder_State_Step1_Dec:
				  EncoderStateReg <= EncoderState_Step1_Idle;
					
				//Step 1 - Idle
				Encoder_State_Step1_Idle:
				  if (Encoder_PinA_In)
					  EncoderStateReg <= EncoderState_Step2_Inc;
					else if (Encoder_PinB_In)
					  EncoderStateReg <= EncoderState_Step4_Dec;
						
						
				//--------------------------
				//Step 2 - A = High, B = Low
				
				//Step 2 - Inc
				Encoder_State_Step2_Inc:
				  EncoderStateReg <= EncoderState_Step2_Idle;
					
				//Step 2 - Dec
				Encoder_State_Step2_Dec:
				  EncoderStateReg <= EncoderState_Step2_Idle;
					
				//Step 2 - Idle
				Encoder_State_Step2_Idle:
				  if (Encoder_PinB_In)
					  EncoderStateReg <= EncoderState_Step3_Inc;
					else if (~Encoder_PinA_In)
					  EncoderStateReg <= EncoderState_Step1_Dec;
						
						
				//---------------------------
				//Step 3 - A = High, B = High
				
				//Step 3 - Inc
				Encoder_State_Step3_Inc:
				  EncoderStateReg <= EncoderState_Step3_Idle;
					
				//Step 3 - Dec
				Encoder_State_Step3_Dec:
				  EncoderStateReg <= EncoderState_Step3_Idle;
					
				//Step 3 - Idle
				Encoder_State_Step3_Idle:
				  if (~Encoder_PinA_In)
					  EncoderStateReg <= EncoderState_Step4_Inc;
					else if (~Encoder_PinB_In)
					  EncoderStateReg <= EncoderState_Step2_Dec;
						
				
				//--------------------------
				//Step 4 - A = Low, B = High
				
				//Step 4 - Inc
				Encoder_State_Step4_Inc:
				  EncoderStateReg <= EncoderState_Step4_Idle;
					
				//Step 4 - Dec
				Encoder_State_Step4_Dec:
				  EncoderStateReg <= EncoderState_Step4_Idle;
					
				//Step 4 - Idle
				Encoder_State_Step4_Idle:
				  if (~Encoder_PinB_In)
					  EncoderStateReg <= EncoderState_Step1_Inc;
					else if (Encoder_PinA_In)
					  EncoderStateReg <= EncoderState_Step3_Dec;
						
			endcase
		
		end
		
	end
	
	
	//----------------------
	//----------------------
	//State Machine - Output
	
	parameter EncoderStateOut_Idle = 2'b00; 
	parameter EncoderStateOut_Inc  = 2'b01;
	parameter EncoderStateOut_Dec  = 2'b10;
	
	reg [1:0] EncoderStateOutReg;
	
	wire EncoderInc = EncoderStateOutReg[0];
	wire EncoderDec = EncoderStateOutReg[1];
	
	always @ (EncoderStateReg)
	begin
	  
		case (EncoderStateReg)
		
		  EncoderState_Reset:
			  EncoderStateOutReg = EncoderStateOut_Idle;
				
			EncoderState_Step1_Inc:
			  EncoderStateOutReg = EncoderStateOut_Inc;
				
			EncoderState_Step1_Dec:
			  EncoderStateOutReg = EncoderStateOut_Dec;
				
			EncoderState_Step1_Idle:
			  EncoderStateOutReg = EncoderStateOut_Idle;
		
			EncoderState_Step2_Inc:
			  EncoderStateOutReg = EncoderStateOut_Inc;
				
			EncoderState_Step2_Dec:
			  EncoderStateOutReg = EncoderStateOut_Dec;
				
			EncoderState_Step2_Idle:
			  EncoderStateOutReg = EncoderStateOut_Idle;
		
			EncoderState_Step3_Inc:
			  EncoderStateOutReg = EncoderStateOut_Inc;
				
			EncoderState_Step3_Dec:
			  EncoderStateOutReg = EncoderStateOut_Dec;
				
			EncoderState_Step3_Idle:
			  EncoderStateOutReg = EncoderStateOut_Idle;
		
			EncoderState_Step4_Inc:
			  EncoderStateOutReg = EncoderStateOut_Inc;
				
			EncoderState_Step4_Dec:
			  EncoderStateOutReg = EncoderStateOut_Dec;
				
			EncoderState_Step4_Idle:
			  EncoderStateOutReg = EncoderStateOut_Idle;
		
		endcase
		
	end

	
	//-------
	//-------
	//Counter
	
	reg [7:0] CounterReg;
	
	always @ (posedge Clock or posedge Reset)
	begin
	
	  if (Reset)
		  CounterReg <= 8'h00;
		else if (EncoderInc)
		  CounterReg <= CounterReg + 8'h01;
		else if (EncoderDec)
		  CounterReg <= CounterReg - 8'h01;
	
	end
	
endmodule















