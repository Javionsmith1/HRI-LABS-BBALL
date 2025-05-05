%% This script is for live implementation of the basketball coach in work!

% Streams in Myoband Data
time = 3; % amount of seconds for a collect

Data = streamMyoBandData(time); % function made to collect myo data

NUMBER_VIE = get_kinect(colorVid, depthVid, FramesPerTrigger, labeledDistanceX_GoodLabels_mean, trainedModel_kinect);

% Streams in Kinect Data 

% Feeds the model
% The model NEEDS to be aready trained, and in the workspace as
% "trainedModel"

%allData = table(features);
prediction = trainedModel.predictFcn(Data);


% Decide if good shot or bad shot

Decision = mode(prediction);

if Decision == NUMBER_VIE
    disp('Both agree!')
else 
    disp('Defering to MyoBand!')
end

% Make a suggestion


% Play animation
[LeftArm, RightArm] = Animate(Decision,LeftArm,RightArm);
[LeftArm, RightArm] = Animate(9,LeftArm,RightArm);

disp(NUMBER_VIE)









