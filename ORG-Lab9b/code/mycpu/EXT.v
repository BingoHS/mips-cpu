
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:24:29 03/31/2019 
// Design Name: 
// Module Name:    EXT 
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
module EXT(Imm16, EXTOp, Imm32);
    input [15:0]Imm16;
    input [1:0]EXTOp;
    output reg [31:0]Imm32;

    always@(Imm16 or EXTOp)
    begin
        case(EXTOp)
            2'b00: Imm32={16'b0,Imm16}; //¡„Õÿ’π
            2'b01: Imm32=Imm16[15]?{16'hffff,Imm16}:{16'b0,Imm16}; //∑˚∫≈Õÿ’π
            2'b10: Imm32={Imm16,16'b0}; //lui
            default:;
        endcase
    end
endmodule
