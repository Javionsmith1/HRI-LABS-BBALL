function [outputArg1,outputArg2] = moreWristAnimation(Arm,upperArmAngles,fingerAngles)
wristFlexThreshold = deg2rad(45);
wristExtendThreshold = deg2rad(-45);
AnimationTime = 5;
tLast = tic;    % store the current time for real-time control
AnimationTimeRemaining = AnimationTime;
p = upperArmAngles(7);          % store current position
direction = 1;  % specify a direction variable +/- 1
v = 1.2;

while AnimationTimeRemaining > 0
    dt = toc(tLast);
    AnimationTimeRemaining= AnimationTimeRemaining- dt;
    tLast = tic;

    if p > wristFlexThreshold
        direction = -1;
    elseif p < wristExtendThreshold
        direction = 1;
    end

    p = p + (direction* v * dt);
    upperArmAngles(7) = p;
    sendArmPositions(Arm,upperArmAngles,fingerAngles);
end

end