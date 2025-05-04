function [LArm, RArm] = Animate(decision,LeftArm,RightArm)
switch(decision)
    case 0
        %show thumb up
        LeftArm.upperArmAngles = zeros(1,7);
        LeftArm.fingerAngles = zeros(1,20);
        sendArmPositions(LeftArm.minivie,LeftArm.upperArmAngles, LeftArm.fingerAngles);
        thumbsUp(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
    case 1
        %Show more wrist and elbow
        ElbownWrist(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
    case 2
        %Show elbow in
        ElbowInAnimation(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
    case 3
        %Show more wrist
        moreWristAnimation(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
    case 4
        %show higher arch
        higherArchAnimation(RightArm.minivie,RightArm.upperArmAngles,RightArm.fingerAngles);
    case 5
        %show lower arch
        lowerArchAnimation(RightArm.minivie,RightArm.upperArmAngles,RightArm.fingerAngles);
    case 6
        %Default Position
        [RightArm.upperArmAngles, RightArm.fingerAngles] = setGoodPosition("right");
        sendArmPositions(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
        [LeftArm.upperArmAngles, LeftArm.fingerAngles] = setGoodPosition("left");
        sendArmPositions(LeftArm.minivie,LeftArm.upperArmAngles, LeftArm.fingerAngles)
    otherwise
        %Show good position
        [RightArm.upperArmAngles, RightArm.fingerAngles] = setGoodPosition("right");
        sendArmPositions(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
        [LeftArm.upperArmAngles, LeftArm.fingerAngles] = setGoodPosition("left");
        sendArmPositions(LeftArm.minivie,LeftArm.upperArmAngles, LeftArm.fingerAngles);
end
LArm = LeftArm;
RArm = RightArm;
end