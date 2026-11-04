module performance_counters(
    input clk, input reset, input retired, input stall, input forwarding_event,
    output reg [31:0] cycles, output reg [31:0] retired_instructions,
    output reg [31:0] stall_cycles, output reg [31:0] forwarding_events
);
always @(posedge clk) begin
    if (reset) begin
        cycles<=0; retired_instructions<=0; stall_cycles<=0; forwarding_events<=0;
    end else begin
        cycles<=cycles+1;
        if (retired) retired_instructions<=retired_instructions+1;
        if (stall) stall_cycles<=stall_cycles+1;
        if (forwarding_event) forwarding_events<=forwarding_events+1;
    end
end
endmodule
