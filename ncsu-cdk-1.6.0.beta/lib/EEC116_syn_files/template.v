// EEC116 - Fall 2011
//
// Pattern detector that detects the 5 bit pattern, 01101
// 
// This design will detect if a given 5-bit pattern is detected at the 1-bit input 'din'
// 
// The design will continuously store new input bit ('din') into a 5-bit buffer, and check to see if the buffered data matches the pattern.
//
// 
//

module detect (
din, // 1-bit input
clk, // clock
reset, // active high reset signal
detect // 1-bit output that signals if pattern is detected
);

// Define signals:
// - All signals with prefix "c_" are combinational signals
// - All other signals are sequential

input din;
input clk;
input reset;
output detect;

reg detect;
reg c_detect;

reg [4:0] buffer;
reg [4:0] c_buffer;


// Combinational logic circuit -- sensitive on all sequential signals
always @ (  )
begin

// Task 1: set all combinational signals
//    - if you do not set all combinational signals every cycle, the simulator will automatically assign the value from the previous cycle. 
//	This is undesirable when you are writing code for synthesis, the synthesizer will automatically put in a latch and create potential for timing problems.



// Task 2: Write the logic to check 'count' and see if the 5-bit data in the buffer matches the pattern. If it match, set c_detect HIGH.


		
		
// Reset logic	
// - Task 3: Reset all combinational signals to zero


end



// Sequential logic circuit -- sensitive on positive edge of clock
always @ ( )
begin
// Task 4: Assign all combinational signals to the sequential signals through non-blocking assignments
// Task 5: Insert the newly arrived data sample into the buffer



end
	
endmodule