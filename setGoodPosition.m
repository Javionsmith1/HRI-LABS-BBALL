function [upperArmAngles,fingerAngles] = setGoodPosition(arm)
if arm == 'left'
    upperArmAngles(1) = deg2rad(90);
    upperArmAngles(2) = deg2rad(20);
    upperArmAngles(3) = deg2rad(20);
    upperArmAngles(4) = deg2rad(90);
    upperArmAngles(7) = deg2rad(-10);
    fingerAngles = zeros(1,20);
else
    upperArmAngles(1) = deg2rad(90);
    upperArmAngles(4) = deg2rad(90);
    upperArmAngles(5) = deg2rad(90);
    upperArmAngles(7) = deg2rad(-45);
    fingerAngles(18) = deg2rad(90);
    fingerAngles(19) = deg2rad(24.5);
end
end