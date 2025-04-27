function [outputArg1,outputArg2] = ElbowInAnimation(Arm,upperArmAngles,fingerAngles)
% Create a variable to store the 7 upper arm angles, in radians. 
% 1: Shoulder Flexion (+) / Shoulder Extension (-)
% 2: Shoulder Adduction (+) / Shoulder Abduction (-)
% 3: Humeral Internal Rotation (+) / Humeral External Rotation  (-) 
% 4: Elbow Flexion (+) / Elbow Extension (-)
% 5: Wrist Pronation (+) / Wrist Supination (-)
% 6: Ulnar Deviation (+) / Radial Deviation (-)
% 7: Wrist Flexion (+) / Wrist Extension (-)
tLast = tic;    % store the current time for real-time control

p = upperArmAngles(2);          % store current position
direction = 1;  % specify a direction variable +/- 1
v = 1.2;

shoulderFlexThreshold = 0;
shoulderExtendThreshold = -pi/2;
stopTime = 3; % time in seconds which I need this to stop
while stopTime > 0
    dt = toc(tLast);
    stopTime = stopTime - dt;
    tLast = tic;

    if p >= shoulderFlexThreshold
        direction = -1;
    elseif p < shoulderExtendThreshold
        direction = 1;
    end

    p = p + (direction* v * dt);
    upperArmAngles(2) = p;
    disp(p);
    sendArmPositions(Arm,upperArmAngles,fingerAngles);
end