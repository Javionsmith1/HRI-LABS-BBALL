%% read data

allFeatures = tableData_train{:,1};
allLabels = tableData_train{:,2};

allFeatures_test = tableData_test{:,1};
allLabels_test = tableData_test{:,2};


% allFeatures = Distance_midline;
% allLabels = labeledDistanceX(:,1);


%% map feature names to what is known for Kinect V2

% Replace 1s with 'Good' and 0s with 'Bad'
allLabels_string = cell(size(allLabels));
allLabels_string(allLabels == 1) = {'Good Shot'};
allLabels_string(allLabels == 0) = {'Bad Shot'};

%kinect v2:
%https://lisajamhoury.medium.com/understanding-kinect-v2-joints-and-coordinate-system-4f4b90b9df16

FeatureNames = {'SpineBase', 'SpineMid', 'Neck', 'Head', ...
    'Shoulder Left', 'Elbow Left', 'Wrist Left', 'Hand Left', ...
    'Shoulder Right', 'Elbow Right', 'Wrist Right', 'Hand Right', ...
    'Hip Left', 'Knee Left', 'Ankle Left', 'Foot Left', ...
    'Hip Right', 'Knee Right', 'Ankle Right', 'Foot Right', ...
    'Spine Shoulder', 'Hand Tip Left', 'Thumb Left', 'Hand Tip Right', ...
    }; %'Thumb Right'};
FeatureNames{end+1} = 'ClassLabel';

% allFeatures = Distance_midline;
% allLabels = labeledDistanceX(:,1);

% T = array2table(allFeatures, 'VariableNames', FeatureNames);
% L = array2table(allLabels_string);
% tableData_train_FeatNames = table(T,L);

tableData_train_FeatNames = table(allFeatures(:,1),allFeatures(:,2),allFeatures(:,3),allFeatures(:,4),allFeatures(:,5), ...
                                    allFeatures(:,6),allFeatures(:,7),allFeatures(:,8),allFeatures(:,9),allFeatures(:,10), ...
                                    allFeatures(:,11),allFeatures(:,12),allFeatures(:,13),allFeatures(:,14),allFeatures(:,15), ...
                                    allFeatures(:,16),allFeatures(:,17),allFeatures(:,18),allFeatures(:,19),allFeatures(:,20), ...
                                    allFeatures(:,21),allFeatures(:,22),allFeatures(:,23),allFeatures(:,24), ...
                                    allLabels_string, 'VariableNames', FeatureNames);


%% Visualize Tree Model

% use fine tree model
view(trainedModel.ClassificationTree,"Mode","graph")

% Display tree information (useful for interpreting nodeID)
disp('Cut Predictors (features) at each split:');
disp(trainedModel.ClassificationTree.CutPredictor);

disp('Split Thresholds (Cut Points) at each node:');
disp(trainedModel.ClassificationTree.CutPoint);

disp('Children of each node (if any):');
disp(trainedModel.ClassificationTree.Children);

%% See Test Point Path

testDataPoint = allFeatures_test(120, :); 

% Predict the class for this data point
[predictedClass, ProbScore, nodeID] = predict(trainedModel.ClassificationTree, testDataPoint);
disp(['Predicted Class: ', predictedClass{1}, ',  ProbScore: ', num2str(ProbScore)]);


disp(['node ID: ', num2str(nodeID)])
disp('Cut Predictor for node n:');
disp(trainedModel.ClassificationTree.CutPredictor{nodeID});  % Feature used for split
disp('Cut Point for node n:');
disp(trainedModel.ClassificationTree.CutPoint(nodeID));  % Split threshold


%%
[coeff,score,latent,tsquared,explained,mu] = pca(allFeatures);

% Matlab document:
%[coeff,score,latent,tsquared,explained,mu] = pca(X); 
% The rows of X correspond to observations, and the columns correspond to variables. 
% Each column of the coefficient matrix coeff contains the coefficients for one principal component. 
% The columns are sorted in descending order by principal component variance. 
% By default, pca centers the data and uses the singular value decomposition (SVD) algorithm. 

% Principal component scores are the representations of X in the principal component space. 
% Rows of score correspond to observations, and columns correspond to components.
% The principal component variances are the eigenvalues of the covariance matrix of X.

% explained, the percentage of the total variance explained by each principal component 
% and mu, the estimated mean of each variable in X.

figure(1)
sgtitle('Percentage of the total variance explained by each principal component')
bar(explained)
title('Training Data')
xlabel('PC #')
ylabel('% of total variance')


figure(2)
gscatter(score(:,1),score(:,2),allLabels)
xlabel('PC 1')
ylabel('PC 2')
title('Training Data')
figure(3)
gscatter(score(:,1),score(:,3),allLabels)
xlabel('PC 1')
ylabel('PC 3')
title('Training Data')
figure(4)
gscatter(score(:,2),score(:,3),allLabels)
xlabel('PC 2')
ylabel('PC 3')
title('Training Data')