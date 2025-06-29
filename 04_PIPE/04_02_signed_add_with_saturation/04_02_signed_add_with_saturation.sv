//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module add
(
  input  [3:0] a, b,
  output [3:0] sum
);

  assign sum = a + b;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module signed_add_with_saturation
(
  input  [3:0] a, b,
  output [3:0] sum
);

  // Task:
  //
  // Implement a module that adds two signed numbers with saturation.
  //
  // "Adding with saturation" means:
  //
  // When the result does not fit into 4 bits,
  // and the arguments are positive,
  // the sum should be set to the maximum positive number.
  //
  // When the result does not fit into 4 bits,
  // and the arguments are negative,
  // the sum should be set to the minimum negative number.

    wire [3:0]  sum_simple;
    wire        overflow;
    wire        sign_eq_ab;
    wire        sign_eq_asum;

    
    assign sum_simple   = a + b;
    assign sign_eq_ab   = (a[3] == b  [3]);
    assign sign_eq_asum = (a[3] == sum_simple[3]);
    
    assign overflow = ( sign_eq_ab & ~sign_eq_asum );
    
    assign sum = overflow ? { ~sum_simple[3], {3{sum_simple[3]}} } : sum_simple;
    
    

endmodule
