function [outputArg1,outputArg2] = thumbsUp(Arm,upperArmAngles,fingerAngles)
    upperArmAngles(1) = deg2rad(90);
    upperArmAngles(4) = deg2rad(90);
    upperArmAngles(5) = deg2rad(0);
    upperArmAngles(6) = deg2rad(90);
    fingerAngles(2) = deg2rad(90);
    fingerAngles(3) = deg2rad(90);
    fingerAngles(4) = deg2rad(90);
    fingerAngles(6) = deg2rad(90);
    fingerAngles(7) = deg2rad(90);
    fingerAngles(8) = deg2rad(90);
    fingerAngles(10) = deg2rad(90);
    fingerAngles(11) = deg2rad(90);
    fingerAngles(12) = deg2rad(90);
    fingerAngles(14) = deg2rad(90);
    fingerAngles(15) = deg2rad(90);
    fingerAngles(16) = deg2rad(90);
    fingerAngles(18) = deg2rad(0);
    fingerAngles(19) = deg2rad(0);
    sendArmPositions(Arm,upperArmAngles,fingerAngles);
end