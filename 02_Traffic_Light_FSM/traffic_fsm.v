module traffic_fsm (
    input clk,
    input reset,
    input vehicle_detected,   // Side street sensor
    input crosswalk_request,  // Pedestrian button
    input emergency_override, // Ambulance/Fire override
    
    output reg [2:0] main_light, // {Red, Yellow, Green}
    output reg [2:0] side_light,
    output reg walk_signal       // 1 = Walk, 0 = Don't Walk
);

    // State Encodings (Binary)
    localparam MAIN_GREEN   = 3'b000;
    localparam MAIN_YELLOW  = 3'b001;
    localparam SIDE_GREEN   = 3'b010;
    localparam SIDE_YELLOW  = 3'b011;
    localparam CROSSWALK    = 3'b100;
    localparam EMERGENCY    = 3'b101;

    reg [2:0] current_state, next_state;

    // Block 1: State Register (Sequential - updates on clock edge)
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= MAIN_GREEN;
        else
            current_state <= next_state;
    end

    // Block 2: Next State Logic (Combinational - decides where to go next)
    always @(*) begin
        // Default assignment to prevent latches
        next_state = current_state;

        if (emergency_override) begin
            next_state = EMERGENCY;
        end else begin
            case (current_state)
                MAIN_GREEN: begin
                    if (crosswalk_request) next_state = MAIN_YELLOW;
                    else if (vehicle_detected) next_state = MAIN_YELLOW;
                end
                MAIN_YELLOW: begin
                    if (crosswalk_request) next_state = CROSSWALK;
                    else next_state = SIDE_GREEN;
                end
                SIDE_GREEN: begin
                    if (!vehicle_detected || crosswalk_request) next_state = SIDE_YELLOW;
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

    // Block 3: Output Logic (Combinational - drives the actual lights)
    always @(*) begin
        // Default all to Red/Stop to prevent latches and accidents
        main_light = 3'b100; 
        side_light = 3'b100; 
        walk_signal = 1'b0;

        case (current_state)
            MAIN_GREEN:  begin main_light = 3'b001; end // Main Green
            MAIN_YELLOW: begin main_light = 3'b010; end // Main Yellow
            SIDE_GREEN:  begin side_light = 3'b001; end // Side Green
            SIDE_YELLOW: begin side_light = 3'b010; end // Side Yellow
            CROSSWALK:   begin walk_signal = 1'b1;  end // Pedestrian Walk
            EMERGENCY:   begin 
                main_light = 3'b100; // Force Red
                side_light = 3'b100; // Force Red
            end
        endcase
    end
endmodule
