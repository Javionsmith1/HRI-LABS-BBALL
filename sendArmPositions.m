function [outputArg1,outputArg2] = sendArmPositions(arm,upperArmAngles,fingerAngles)
msg = typecast(single([upperArmAngles,fingerAngles]),'uint8');
arm.putData(msg);
end