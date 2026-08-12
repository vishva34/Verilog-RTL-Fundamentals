module tb_traffic_fsm;
    reg clk, reset, vehicle_detected, crosswalk_request, emergency_override;
    wire [2:0] main_light, side_light;
    wire walk_signal;

    traffic_fsm uut (
        .clk(clk), .reset(reset), .vehicle_detected(vehicle_detected),
        .crosswalk_request(crosswalk_request), .emergency_override(emergency_override),
        .main_light(main_light), .side_light(side_light), .walk_signal(walk_signal)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic_fsm.vcd");
        $dumpvars(0, tb_traffic_fsm);

        // Initialize
        clk = 0; reset = 1; vehicle_detected = 0; crosswalk_request = 0; emergency_override = 0;
        #10 reset = 0;

        // Test 1: Normal operation, car arrives on side street
        #20 vehicle_detected = 1;
        #40 vehicle_detected = 0;

        // Test 2: Pedestrian wants to cross
        #20 crosswalk_request = 1;
        #10 crosswalk_request = 0;

        // Test 3: Ambulance override
        #40 emergency_override = 1;
        #30 emergency_override = 0;

        #50 $finish;
    end
endmodule
