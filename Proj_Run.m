%Initialize Project Configuration
Proj_Init;

Distance = zeros(FramesPerTrigger*binSize,24);
%Main Loop
%while 1
for A=1:1:4 


    % Record video and get video data from the kinect
    start([colorVid depthVid]);
    trigger([colorVid depthVid]);

    % Retrieve the frames and check if any Skeletons are tracked
    [colorFrameData,colorTimeData,colorMetaData] = getdata(colorVid);
    [frameDataDepth, timeDataDepth, metaDataDepth] = getdata(depthVid);
    stop([colorVid depthVid]);

    % Runs through each frame of video map and analyze joint data
    for i=1:1:FramesPerTrigger
        %Validate Frame
        trackedBodies = IsValidFrame(metaDataDepth(i).IsBodyTracked);
        if trackedBodies == 0
            continue
        end

        nBodies = length(trackedBodies);
        jointCoordinates = metaDataDepth(i).JointPositions(:, :, trackedBodies);
        jointIndices = metaDataDepth(i).ColorJointIndices(:, :, trackedBodies);
        for j = 1:24
            for body = 1:nBodies
                %Distance from spine mid to each joint

                DistanceX(i*A,j,1) = jointCoordinates(j,1);
                DistanceY(i*A,j,1) = jointCoordinates(j,2);
                DistanceZ(i*A,j,1) = jointCoordinates(j,3);
                %X1 = [jointIndices(SkeletonConnectionMap(j,1),1,body) jointIndices(SkeletonConnectionMap(j,2),1,body)];
                %Y1 = [jointIndices(SkeletonConnectionMap(j,1),2,body) jointIndices(SkeletonConnectionMap(j,2),2,body)];
                %line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', colors(body));
           end
           %hold on;
        end
        %hold off;
        %pause(.1);
        clf;
    end
    %GoodBadMatrix(A) = input("Good or Bad (1/0)");
end
%% 
numColumns = 24;
numRows = length(DistanceX);

labels = [ones(180,1); zeros(numRows-180, 1)];
labeledDistanceX = [labels, DistanceX];
labeledDistanceY = [labels, DistanceY];
labeledDistanceZ = [labels, DistanceZ];

for i=length(labeledDistanceX)
for j = 1:24
    %Distance from spine mid to each joint

    x = DistanceX(i,j) 
    y = DistanceY(i,j) 
    z = DistanceZ(i,j)
    if any(DistanceX(1,:)) && any(DistanceX(1,:))
    %X1 = [jointIndices(SkeletonConnectionMap(j,1),1,body) jointIndices(SkeletonConnectionMap(j,2),1,body)];
    %Y1 = [jointIndices(SkeletonConnectionMap(j,1),2,body) jointIndices(SkeletonConnectionMap(j,2),2,body)];
    %line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', colors(body));
end
end

nonZeroFeatureRowsX = any(labeledDistanceX(:, 2:end), 2);
nonZeroFeatureRowsY = any(labeledDistanceY(:, 2:end), 2);
nonZeroFeatureRowsZ = any(labeledDistanceZ(:, 2:end), 2);


filteredDistance = labeledDistance(nonZeroFeatureRows, :);

justDistance = filteredDistance(:,2:end);



% preallocate feature matrix
features = zeros(num_channels, num_features, num_feature_samples);

% good shots without zero rows
goodShots= justDistance(filteredDistance(:,1) == 1, :);
% bad shots without zero rows
badShots = justDistance(filteredDistance(:,1) == 0, :);


% distances between good shots
goodShot = [];
for i = 1:length(goodShots)
for j = 1:24
    for body = 1:nBodies
        %Distance from spine mid to each joint
        goodShot(i,j) = sqrt( (goodShots(j,1)-goodShots(2,1))^2 +  (goodShots(j,2)-goodShots(2,2))^2 + (goodShots(j,3)-goodShots(2,3))^2);
        %X1 = [jointIndices(SkeletonConnectionMap(j,1),1,body) jointIndices(SkeletonConnectionMap(j,2),1,body)];
        %Y1 = [jointIndices(SkeletonConnectionMap(j,1),2,body) jointIndices(SkeletonConnectionMap(j,2),2,body)];
        %line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', colors(body));
   end
%hold on;
end
end

% distances between bad shots
badShot = [];
for i = 1:length(badShots)
for j = 1:24
    for body = 1:nBodies
        %Distance from spine mid to each joint

        badShot(i,j) = sqrt( (badShots(j,1)-badShots(2,1))^2 +  (badShots(j,2)-badShots(2,2))^2 + (badShots(j,3)-badShots(2,3))^2);
        %X1 = [jointIndices(SkeletonConnectionMap(j,1),1,body) jointIndices(SkeletonConnectionMap(j,2),1,body)];
        %Y1 = [jointIndices(SkeletonConnectionMap(j,1),2,body) jointIndices(SkeletonConnectionMap(j,2),2,body)];
        %line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', colors(body));
   end
%hold on;
end
end

num_kinect_samples = size(goodShot,1);

% create indices for start and end of sliding data windows
idxStart = 1:5:num_kinect_samples-windowSize-1;
idxEnd = idxStart+windowSize-1;
num_feature_samples = length(idxStart);

for b = 1:length(idxStart)
    % fix
    windowData = goodShot(idxStart(b):idxEnd(b),:);
    f = feature_extract(windowData',windowSize,zc_thresh,ssc_thresh,Fs);
    features(:,:,b) = f;
end

features_goodShot = features;


num_kinect_samples = size(badShot,1);

% create indices for start and end of sliding data windows
idxStart = 1:5:num_kinect_samples-windowSize-1;
idxEnd = idxStart+windowSize-1;
num_feature_samples = length(idxStart);

for b = 1:length(idxStart)
    % fix
    windowData = badShot(idxStart(b):idxEnd(b),:);
    f = feature_extract(windowData',windowSize,zc_thresh,ssc_thresh,Fs);
    features(:,:,b) = f;
end

features_badShot = features;


num_kinect_samples = size(justDistance,1);

% create indices for start and end of sliding data windows
idxStart = 1:5:num_kinect_samples-windowSize-1;
idxEnd = idxStart+windowSize-1;
num_feature_samples = length(idxStart);

for b = 1:length(idxStart)
    % fix
    windowData = justDistance(idxStart(b):idxEnd(b),:);
    f = feature_extract(windowData',windowSize,zc_thresh,ssc_thresh,Fs);
    features(:,:,b) = f;
end


figure(4)
% Plot results of feature extract:
num_plots = 1 + length(featureNames);
subplot(num_plots,1,1)
plot(Distance)
ylim([-1.5 1.5])
title("Name",'Interpreter','None')
for i = 2:num_plots
    subplot(num_plots,1,i)
    iFeature = i-1;
    plot(squeeze(features(:,iFeature,:))')
    title(featureNames{iFeature})
end

stackedFeatures_good = reshape(features_goodShot,num_channels*num_features,[]);
stackedFeatures_bad = reshape(features_badShot,num_channels*num_features,[]);

stackedFeatures_comb = [stackedFeatures_good; stackedFeatures_bad];
stackedFeatures = reshape(features,num_channels*num_features,[]);


%% Pause and adjust as needed


% goodIds = 
% badIds = filteredDistance(filteredDistance(:,1) == 0, :);

goodFeatures = goodShots;
badFeatures = badShots;

allLabels = [
    repmat({'Good'},size(goodFeatures,1),1);
    repmat({'Bad'},size(badFeatures,1),1);];
allFeatures = [goodFeatures;badFeatures];

% subplot(2,1,2)
% hold on
% plot(goodIds, 0, 'm.')
% plot(badIds, 0, 'g.')


%% Classify
classLabels = {'Good' 'Bad'};

tableData = table(allFeatures,allLabels);

%% Training data saved

testData = tableData;
testFeatures = allFeatures;


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
set(gca,'ytick',1:2,'yticklabel',classLabels)
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
%allFeatures = stackedFeatures';
allFeatures;
tdTest = table(allFeatures);

yfit = trainedModel.predictFcn(tdTest);

% enumerate class id
classId = [];
knownId = [];

for i = 1:length(yfit)
    classId(i) = find(strcmp(yfit(i),classLabels));
    knownId(i) = find(strcmp(allLabels(i),classLabels));
end

clf
subplot(2,1,1)
plot(justDistance)
title("Name",'Interpreter','None')
subplot(2,1,2)
plot(classId)
set(gca,'ytick',1:2,'yticklabel',classLabels)
ylim([0 3])

