%% This script is for live implementation of the basketball coach in work!


% Streams in Myoband Data
time = 3; % amount of seconds for a collect
Data = streamMyoBandData(time); % function made to collect myo data

% Streams in Kinect Data 

pause(4);
% Feeds the model
% The model NEEDS to be aready trained, and in the workspace as
% "trainedModel"
prediction = trainedModel.predictFcn(Data);



% Decide if good shot or bad shot

Decision = mode(prediction);




% Make a suggestion




% Play animation












