function [outputArg1,outputArg2] = ElbownWrist(Arm,upperArmAngles,fingerAngles)
% ElbownWrist - Move shoulder and wrist simultaneously within thresholds.

% Extract current shoulder and wrist positions
p = upperArmAngles(2);   % Shoulder Adduction/Abduction
q = upperArmAngles(7);   % Wrist Flexion/Extension

% Direction control variables
direction = 1;
direction2 = 1;

% Velocities
v = 1.2;
v2 = 5;

% Thresholds
shoulderFlexThreshold = pi/4;
shoulderExtendThreshold = -pi/4;
wristFlexThreshold = deg2rad(45);
wristExtendThreshold = deg2rad(-45);

% Timer setup
tLast = tic;
stopTime = 3;

while stopTime > 0
    dt = toc(tLast);
    stopTime = stopTime - dt;
    tLast = tic;

    % Shoulder direction update
    if p >= shoulderFlexThreshold
        direction = -1;
    elseif p <= shoulderExtendThreshold
        direction = 1;
    end

    % Wrist direction update
    if q >= wristFlexThreshold
        direction2 = -1;
    elseif q <= wristExtendThreshold
        direction2 = 1;
    end

    % Update positions
    p = p + direction * v * dt;
    q = q + direction2 * v2 * dt;

    % Assign updated angles
    upperArmAngles(2) = p;
    upperArmAngles(7) = q;

    % Send to hardware
    sendArmPositions(Arm, upperArmAngles, fingerAngles);
end
