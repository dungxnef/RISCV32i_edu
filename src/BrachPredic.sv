// Branch predictor module
module BranchPredictor(
  input clk, reset, // clock and reset signals
  input [31:0] pc, // program counter
  input update_en, // enable signal for updating the branch predictor
  input update_val, // actual branch outcome (1 for taken, 0 for not taken)
  output reg prediction // predicted branch outcome
);

  // Parameters for the branch predictor
  parameter NUM_ENTRIES = 1024; // number of entries in the branch history table
  parameter INDEX_BITS = 10; // number of bits to index the table
  parameter TAG_BITS = 22; // number of bits for the tag
  parameter COUNTER_BITS = 2; // number of bits for the saturating counter
  
  // Branch history table entry
  typedef struct packed {
    logic [TAG_BITS-1:0] tag; // tag to identify the branch instruction
    logic [COUNTER_BITS-1:0] counter; // saturating counter to record the branch history
  } bht_entry_t;
  
  // Branch history table
  bht_entry_t bht [NUM_ENTRIES];
  
  // Index and tag for the current branch instruction
  logic [INDEX_BITS-1:0] index;
  logic [TAG_BITS-1:0] tag;
  
  // Counter value for the current branch instruction
  logic [COUNTER_BITS-1:0] counter;
  
  // Flag to indicate a hit or miss in the branch history table
  logic hit;
  
  // Assign the index and tag from the lower bits of the PC
  assign index = pc[INDEX_BITS+1:2];
  assign tag = pc[31:INDEX_BITS+2];
  
  // Read the branch history table at the index
  always @(posedge clk) begin
    if (reset) begin
      // Initialize the table entries to zero
      for (int i = 0; i < NUM_ENTRIES; i++) begin
        bht[i].tag = 0;
        bht[i].counter = 0;
      end
    end
    else begin
      // Read the counter value and the tag at the index
      counter <= bht[index].counter;
      hit <= (bht[index].tag == tag); // check for tag match
    end
  end
  
  // Update the branch history table if enabled
  always @(posedge clk) begin
    if (update_en && hit) begin
      // Update the counter value based on the actual branch outcome
      case (counter)
        2'b00: // strongly not taken
          if (update_val) begin
            // Mispredicted as not taken, increment the counter
            bht[index].counter <= 2'b01; // weakly not taken
          end
          else begin
            // Correctly predicted as not taken, no change
            bht[index].counter <= 2'b00; // strongly not taken
          end
        2'b01: // weakly not taken
          if (update_val) begin
            // Mispredicted as not taken, increment the counter
            bht[index].counter <= 2'b10; // weakly taken
          end
          else begin
            // Correctly predicted as not taken, decrement the counter
            bht[index].counter <= 2'b00; // strongly not taken
          end
        2'b10: // weakly taken
          if (update_val) begin
            // Correctly predicted as taken, increment the counter
            bht[index].counter <= 2'b11; // strongly taken
          end
          else begin
            // Mispredicted as taken, decrement the counter
            bht[index].counter <= 2'b01; // weakly not taken
          end
        2'b11: // strongly taken
          if (update_val) begin
            // Correctly predicted as taken, no change
            bht[index].counter <= 2'b11; // strongly taken
          end
          else begin
            // Mispredicted as taken, decrement the counter
            bht[index].counter <= 2'b10; // weakly taken
          end
      endcase
    end
    else if (update_en && !hit) begin
      // Miss in the branch history table, replace the entry with the new tag and counter value
      bht[index].tag <= tag;
      bht[index].counter <= update_val ? 2'b10 : 2'b01; // weakly taken or not taken
    end
  end
  
  // Predict the branch outcome based on the counter value and the hit flag
  always @(posedge clk) begin
    if (reset) begin
      // Initialize the prediction to not taken
      prediction <= 0;
    end
    else begin
      if (hit) begin
        // Hit in the branch history table, predict based on the counter value
        prediction <= counter[1]; // predict taken if counter is 2 or 3
      end
      else begin
        // Miss in the branch history table, predict not taken
        prediction <= 0;
      end
    end
  end
  
endmodule

