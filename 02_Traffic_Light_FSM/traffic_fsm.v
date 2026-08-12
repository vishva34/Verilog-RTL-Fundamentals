module traffic_fsm (
    input clk,
    input reset,
    input vehicle_detected,
    input crosswalk_request,
    input emergency_override,
    output reg [2:0] main_light,
    output reg [2:0] side_light,
    output reg walk_signal
);

    localparam MAIN_GREEN   = 3'b000;
    localparam MAIN_YELLOW  = 3'b001;
    localparam SIDE_GREEN   = 3'b010;
    localparam SIDE_YELLOW  = 3'b011;
    localparam CROSSWALK    = 3'b100;
    localparam EMERGENCY    = 3'b101;

    reg [2:0] current_state, next_state;
    reg crosswalk_latched; 

    // Block 1: Sequential Logic & Hardware Latch
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= MAIN_GREEN;
            crosswalk_latched <= 1'b0;
        end else begin
            current_state <= next_state;
            if (crosswalk_request) 
                crosswalk_latched <= 1'b1;
            else if (current_state == CROSSWALK) 
                crosswalk_latched <= 1'b0;
        end
    end

    // Block 2: Next State Combinational Logic
    always @(*) begin
        next_state = current_state;
        if (emergency_override) begin
            next_state = EMERGENCY;
        end else begin
            case (current_state)
                MAIN_GREEN: begin
                    if (crosswalk_latched) next_state = MAIN_YELLOW;
                    else if (vehicle_detected) next_state = MAIN_YELLOW;
                end
                MAIN_YELLOW: begin
                    if (crosswalk_latched) next_state = CROSSWALK;
                    else next_state = SIDE_GREEN;
                end
                SIDE_GREEN: begin
                    if (!vehicle_detected || crosswalk_latched) next_state = SIDE_YELLOW;
                end
                SIDE_YELLOW: begin
                    next_state = MAIN_GREEN;
                end
                CROSSWALK: begin
                    next_state = MAIN_GREEN;
                end
                EMERGENCY: begin
                    if (!emergency_override) next_state = MAIN_GREEN;
                end
                default: next_state = MAIN_GREEN;
            endcase
        end
    end

    // Block 3: Output Combinational Logic
    always @(*) begin
        main_light = 3'b100; 
        side_light = 3'b100; 
        walk_signal = 1'b0;
        case (current_state)
            MAIN_GREEN:  begin main_light = 3'b001; end 
            MAIN_YELLOW: begin main_light = 3'b010; end 
            SIDE_GREEN:  begin side_light = 3'b001; end 
            SIDE_YELLOW: begin side_light = 3'b010; end 
            CROSSWALK:   begin walk_signal = 1'b1;  end 
            EMERGENCY:   begin main_light = 3'b100; side_light = 3'b100; end
        endcase
    end
endmodule
