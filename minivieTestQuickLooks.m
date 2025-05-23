% Create a variable to store the 7 upper arm angles, in radians. 
% 1: Shoulder Flexion (+) / Shoulder Extension (-)
% 2: Shoulder Adduction (+) / Shoulder Abduction (-)
% 3: Humeral Internal Rotation (+) / Humeral External Rotation  (-) 
% 4: Elbow Flexion (+) / Elbow Extension (-)
% 5: Wrist Pronation (+) / Wrist Supination (-)
% 6: Ulnar Deviation (+) / Radial Deviation (-)
% 7: Wrist Flexion (+) / Wrist Extension (-)

% Create a variable to store the 20 angles of the fingers, in radians
% 1: INDEX abduction/adduction
% 2: INDEX joint closest to the palm (MCP)
% 3: INDEX second joint (PIP)
% 4: INDEX furthest joint from the palm (DIP)
% 5: MIDDLE abduction/adduction
% 6: MIDDLE MCP
% 7: MIDDLE PIP
% 8: MIDDLE DIP
% 9: RING abduction/adduction
% 10: RING MCP
% 11: RING PIP
% 12: RING DIP
% 13: LITTLE abduction/adduction
% 14: LITTLE MCP
% 15: LITTLE PIP
% 16: LITTLE DIP
% 17: THUMB abduction/adduction
% 18: THUMB roll
% 19: THUMB MCP
% 20: THUMB DIP
% Create a variable to store the 7 upper arm angles, in radians. 
% 1: Shoulder Flexion (+) / Shoulder Extension (-)
% 2: Shoulder Adduction (+) / Shoulder Abduction (-)
% 3: Humeral Internal Rotation (+) / Humeral External Rotation  (-) 
% 4: Elbow Flexion (+) / Elbow Extension (-)
% 5: Wrist Pronation (+) / Wrist Supination (-)
% 6: Ulnar Deviation (+) / Radial Deviation (-)
% 7: Wrist Flexion (+) / Wrist Extension (-)
%Initialize Project Configuration
%Proj_Init;
% set the position of the wrist
 %LeftupperArmAngles = zeros(1,7);
 % RightupperArmAngles = zeros(1,7);
% 
% RightupperArmAngles(1) = pi/2
% RightupperArmAngles(2) = -pi/2 % this is the variable we need to vary top get movement
% RightupperArmAngles(4) = pi/2
% RightupperArmAngles(7) = -pi/4


%Show good position
[RightupperArmAngles, RightfingerAngles] = setGoodPosition("right");
sendArmPositions(RightArm.minivie,RightupperArmAngles,RightfingerAngles);
%[LeftupperArmAngles, LeftfingerAngles] = setGoodPosition("left");
%sendArmPositions(LefthArm,LeftupperArmAngles,LeftfingerAngles);

%show more wrist
%moreWristAnimation(RighthArm,RightupperArmAngles,RightfingerAngles);
%ElbowInAnimation(RighthArm, RightupperArmAngles, RightfingerAngles)
%moreWristAnimation(RighthArm, RightupperArmAngles, RightfingerAngles)
%ElbownWrist(RighthArm, RightupperArmAngles, RightfingerAngles)
higherArchAnimation(RightArm.minivie, RightupperArmAngles,RightfingerAngles)
%lowerArchAnimation(RighthArm, RightupperArmAngles,RightfingerAngles)

%show more 