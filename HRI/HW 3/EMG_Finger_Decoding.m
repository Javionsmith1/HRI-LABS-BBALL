%% Overview
% In this homework you will evaluate various classifiers for decoding
% finger movements.  The recorded activity is an individual pressing each
% finger twice in sequence: 
% Index, Middle, Ring, Little, Rest, Index, Middle, Ring, Little, Rest,
% 
% We will be training our classifier on the first set of movements and
% testing its performance on the second repetition

clf


%% Load Data and Preview
%%%%%%%%%%%%%%%%%%%%%%

filename = 'EMG_play_1.mat';
%filename = 'myEMGData_Shot_01.mat';
% Load EMG data and plot
load(filename);

%emg = emg.emgDataRight;

plot(emg)
title(filename,'Interpreter','None')
xlabel('EMG Sample Number')
ylabel('EMG Scaled Voltage, unitless')



%% Extract features from data
%%%%%%%%%%%%%%%%%%%%%%

% setup constants for feature extraction
featureNames = {'MAV' 'LEN' 'ZC' 'SSC'};
num_channels = 8; % 8 channels in myo band
num_features = length(featureNames);
num_emg_samples = size(emg,1);

windowSize = 150; % number of samples to compute features
binSize = 10; % number of sample to advance across samples
zc_thresh = 0.1;  % threshold vaue for zero crossing
ssc_thresh = 0.1; % threshold vaue for slope sign changes
Fs = 1000; % sample rate

% create indices for start and end of sliding data windows
idxStart = 1:binSize:num_emg_samples-windowSize-1;
idxEnd = idxStart+windowSize-1;
num_feature_samples = length(idxStart);

% preallocate feature matrix
features = zeros(num_channels, num_features, num_feature_samples);

% loop through and slide window by increment and perform feature extraction
for b = 1:length(idxStart)
    windowData = emg(idxStart(b):idxEnd(b),:);
    f = feature_extract(windowData',windowSize,zc_thresh,ssc_thresh,Fs);
    features(:,:,b) = f;
end

figure(4)
% Plot results of feature extract:
num_plots = 1 + length(featureNames);
subplot(num_plots,1,1)
plot(emg)
ylim([-1.5 1.5])
title(filename,'Interpreter','None')
for i = 2:num_plots
    subplot(num_plots,1,i)
    iFeature = i-1;
    plot(squeeze(features(:,iFeature,:))')
    title(featureNames{iFeature})
end


%% Label the features:
%%%%%%%%%%%%%%%%%%%%%%

% stack features as f1, all channels, f2, all channels, etc
stackedFeatures = reshape(features,32,[]);

% These array indices determined empirically given the recorded activity
indexIds = 50:75;
middleIds = 100:139;
ringIds = 150:175;
littleIds = 200:250;
restIds = [1:49 185:200];

indexFeatures = stackedFeatures(:,indexIds);
middleFeatures = stackedFeatures(:,middleIds);
ringFeatures = stackedFeatures(:,ringIds);
littleFeatures = stackedFeatures(:,littleIds);
restFeatures = stackedFeatures(:,restIds);

allLabels = [
    repmat({'Rest'},size(restFeatures,2),1);
    repmat({'Index'},size(indexFeatures,2),1);
    repmat({'Middle'},size(middleFeatures,2),1);
    repmat({'Ring'},size(ringFeatures,2),1);
    repmat({'Little'},size(littleFeatures,2),1);];
allFeatures = [restFeatures,indexFeatures,middleFeatures,ringFeatures,littleFeatures]';

subplot(5,1,2)
hold on
plot(indexIds, 0, 'm.')
plot(middleIds, 0, 'g.')
plot(ringIds, 0, 'b.')
plot(littleIds, 0, 'c.')
plot(restIds, 0, 'k.')


%% Preview training Data
%%%%%%%%%%%%%%%%%%%%%%
classLabels = {'Rest' 'Index' 'Middle' 'Ring' 'Little'};

% enumerate class id
classId = [];
for i = 1:length(allLabels)
    classId(i) = find(strcmp(allLabels{i},classLabels));
end
figure(3)
clf
subplot(2,1,1)
plot(classId)
% ylabel(classLabels,'Interpreter','None')
set(gca,'ytick',[1:5],'yticklabel',classLabels)
title('Training Data Labels')
ylim([0,6])
subplot(2,1,2)
% iFeature = 31;
plot(allFeatures)
title('Feature Data')

%% Format for Classification Learner
%%%%%%%%%%%%%%%%%%%%%%
tableData = table(allFeatures,allLabels);

%% Now with the table data created, Open the 'Classification Learner App'
%%%%%%%%%%%%%%%%%%%%%%
% Select the data (tableData)
% Train the model
% Export the model to the workspace as 'trainedModel'
%%%%%%%%%%%%%%%%%%%%%%

%trainedModel = weighted_KNN(tableData)

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%


%% AFTER model is trained in the Classification Learner App, re-predict outputs

% Re-predict the outputs using the training data as input
yfit = trainedModel.predictFcn(tableData);


%% Check training accuracy
figure(1);
knownId = [];
classId = [];
for i = 1:length(yfit)
    classId(i) = find(strcmp(yfit(i),classLabels));
    knownId(i) = find(strcmp(allLabels(i),classLabels));
end

clf
plot(classId, 'ro')
hold on; plot(knownId,'k.')
set(gca,'ytick',1:5,'yticklabel',classLabels)
ylim([0 6])

%% Extract all features and predict 'test' data
%
% These array indices determined empirically given the recorded activity
% Fix for the training data
%tdindexIds = 50:75;
%tdmiddleIds = 100:139;
%tdringIds = 150:175;
%tdlittleIds = 200:250;
%tdrestIds = [1:49 185:200];
figure(2);
allFeatures = stackedFeatures';
tdTest = table(allFeatures);

yfit = trainedModel.predictFcn(tdTest);

% enumerate class id
classId = [];
for i = 1:length(yfit)
    classId(i) = find(strcmp(yfit(i),classLabels));
end

clf
subplot(2,1,1)
plot(emg)
title(filename,'Interpreter','None')
subplot(2,1,2)
plot(classId)
set(gca,'ytick',1:5,'yticklabel',classLabels)
ylim([0 6])
