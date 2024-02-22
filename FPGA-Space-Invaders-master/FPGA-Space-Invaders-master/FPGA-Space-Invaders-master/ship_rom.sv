module ship_rom
(
	input 	[7:0] addr,
	output 	[15:0] data
);

	parameter[0:7][15:0] ROM = {
	
		16'b0000000000000000,	//0 
		16'b0000000110000000,	//1        ██       
		16'b0000001111000000,	//2       ████      
		16'b0000111001110000,	//3     ███  ███
		16'b0011111111111100,	//4   ████████████
		16'b0111110110111110,	//5  █████ ██ █████
		16'b0111000110001110,	//6  ███   ██   ███
		16'b0010001111000100	   //7   █   ████   █
	
	};
	
	assign data = ROM[addr];

endmodule 