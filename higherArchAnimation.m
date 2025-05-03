function [outputArg1,outputArg2] = higherArchAnimation(Arm,upperArmAngles,fingerAngles)
shoulderflexThreshold = deg2rad(140);
shoulderExtendThreshold = deg2rad(85);
wristFlexThreshold = deg2rad(45);
wristExtendThreshold = deg2rad(-45);
elbowFlexThreshold = deg2rad(90);
elbowExtendThreshold = deg2rad(45);

AnimationTime = 5;
tLast = tic;    % store the current time for real-time control
AnimationTimeRemaining = AnimationTime;
shoulder = upperArmAngles(1); 
elbow = upperArmAngles(4);
wrist = upperArmAngles(7);
d_shoulder = 1;
d_elbow = 1;
d_wrist = 1;% specify a direction variable +/- 1
v_shoulder = .75;
v_wrist = .75;
v_elbow = .75;

while AnimationTimeRemaining > 0
    dt = toc(tLast);
    AnimationTimeRemaining= AnimationTimeRemaining- dt;
    tLast = tic;

    if shoulder > shoulderflexThreshold
        d_shoulder = -1;
    elseif shoulder < shoulderExtendThreshold
        d_shoulder = 1;
    end

    if wrist > wristFlexThreshold
        d_wrist = -1;
    elseif wrist < wristExtendThreshold
        d_wrist = 1;
    end



    shoulder = shoulder + (d_shoulder* v_shoulder * dt);
    wrist = wrist + (d_wrist* v_wrist * dt);
    upperArmAngles(1) = shoulder;
    upperArmAngles(7) = wrist;
    sendArmPositions(Arm,upperArmAngles,fingerAngles);
end

end