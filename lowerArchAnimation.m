function [outputArg1,outputArg2] = lowerArchAnimation(Arm, upperArmAngles, fingerAngles)
% higherArchAnimation - Animate shoulder, elbow, and wrist motion simultaneously.

% Define motion thresholds (in radians)
shoulderflexThreshold = deg2rad(100);
shoulderExtendThreshold = deg2rad(30);
elbowFlexThreshold = deg2rad(45);
elbowExtendThreshold = deg2rad(45);
wristFlexThreshold = deg2rad(45);
wristExtendThreshold = deg2rad(-45);

% Motion parameters
AnimationTime = 5;  % seconds
tLast = tic;
AnimationTimeRemaining = AnimationTime;

% Initialize joint positions
shoulder = upperArmAngles(1); 
elbow = upperArmAngles(4);
wrist = upperArmAngles(7);

% Initialize direction variables
d_shoulder = 1;
d_elbow = 1;
d_wrist = 1;

% Velocity values
v_shoulder = 0.5;
v_elbow = 1.2;
v_wrist = 3;

while AnimationTimeRemaining > 0
    dt = toc(tLast);
    AnimationTimeRemaining = AnimationTimeRemaining - dt;
    tLast = tic;

    % Shoulder direction control
    if shoulder >= shoulderflexThreshold
        d_shoulder = -1;
    elseif shoulder <= shoulderExtendThreshold
        d_shoulder = 1;
    end

    % Elbow direction control
    if elbow >= elbowFlexThreshold
        d_elbow = -1;
    elseif elbow <= elbowExtendThreshold
        d_elbow = 1;
    end

    % Wrist direction control
    if wrist >= wristFlexThreshold
        d_wrist = -1;
    elseif wrist <= wristExtendThreshold
        d_wrist = 1;
    end

    % Update joint angles
    shoulder = shoulder + d_shoulder * v_shoulder * dt;
    elbow = elbow + d_elbow * v_elbow * dt;
    wrist = wrist + d_wrist * v_wrist * dt;

    % Apply updates to upperArmAngles
    upperArmAngles(1) = shoulder;
    upperArmAngles(4) = elbow;
    upperArmAngles(7) = wrist;

    % Send updated positions to arm
    sendArmPositions(Arm, upperArmAngles, fingerAngles);
end

end
