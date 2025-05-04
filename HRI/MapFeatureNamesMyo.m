%% read data

allFeatures = tableDataTrain{:,1};
allLabels = tableDataTrain{:,2};

allFeatures_test = tableDataTest{:,1};
allLabels_test = tableDataTest{:,2};


% allFeatures = Distance_midline;
% allLabels = labeledDistanceX(:,1);


%% map feature names to what is known for Myoband labs and feature_extract.m

% Replace 1s with 'Good' and 0s with 'Bad'
allLabels_string = cell(size(allLabels));
allLabels_string(allLabels == 1) = {'Good Shot'};
allLabels_string(allLabels == 0) = {'Bad Shot'};


% features = zeros(num_channels, num_features, num_feature_samples);
% 
% figure(4)
% % Plot results of feature extract:
% num_plots = 1 + length(featureNames);
% subplot(num_plots,1,1)
% plot(emg)
% ylim([-1.5 1.5])
% %title(filename,'Interpreter','None')
% for i = 2:num_plots
%     subplot(num_plots,1,i)
%     iFeature = i-1;
%     plot(squeeze(features(:,iFeature,:))')
%     title(featureNames{iFeature})
% end
% 
% data = reshape(permute(data.features, [3 1 2]), 285, 32); %285 is the time samples. size of features = 8 x 4 x 285
% features = [MAV(:) LEN(:) ZC(:) SSC(:)];


%Ch 4 is the logo, Ch8 is opposite of logo, count up counterclockwise from logo
%Ch 4 is the logo, Outer Right side away - (5,6,7), Ch8 is opposite of logo, Inner Left side towards (1,2,3)
FeatureNames = {'Ch1 - MAV', 'Ch2 - MAV', 'Ch3 - MAV', 'Ch4 - MAV','Ch5 - MAV', 'Ch6 - MAV', 'Ch7 - MAV', 'Ch8 - MAV', ...
                'Ch1 - LEN', 'Ch2 - LEN', 'Ch3 - LEN', 'Ch4 - LEN', 'Ch5 - LEN', 'Ch6 - LEN', 'Ch7 - LEN', 'Ch8 - LEN', ...
                'Ch1 - ZC', 'Ch2 - ZC', 'Ch3 - ZC', 'Ch4 - ZC', 'Ch5 - ZC', 'Ch6 - ZC', 'Ch7 - ZC', 'Ch8 - ZC', ...
                'Ch1 - SSC', 'Ch2 - SSC', 'Ch3 - SSC', 'Ch4 - SSC', 'Ch5 - SSC', 'Ch6 - SSC', 'Ch7 - SSC', 'Ch8 - SSC', ...
                };
FeatureNames{end+1} = 'ClassLabel';



tableData_train_FeatNames = table(allFeatures(:,1),allFeatures(:,2),allFeatures(:,3),allFeatures(:,4),allFeatures(:,5), ...
                                    allFeatures(:,6),allFeatures(:,7),allFeatures(:,8),allFeatures(:,9),allFeatures(:,10), ...
                                    allFeatures(:,11),allFeatures(:,12),allFeatures(:,13),allFeatures(:,14),allFeatures(:,15), ...
                                    allFeatures(:,16),allFeatures(:,17),allFeatures(:,18),allFeatures(:,19),allFeatures(:,20), ...
                                    allFeatures(:,21),allFeatures(:,22),allFeatures(:,23),allFeatures(:,24), ...
                                    allFeatures(:,25),allFeatures(:,26),allFeatures(:,27),allFeatures(:,28), ...
                                    allFeatures(:,29),allFeatures(:,30),allFeatures(:,31),allFeatures(:,32), ...
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

testDataPoint = allFeatures_test(1110, :); 

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

%% KNN


X = allFeatures;  
y = allLabels; 

% Train the k-NN classifier
k = 1;  % Number of neighbors
knnModel = fitcknn(X, y, 'NumNeighbors', k);

% Test data point (e.g., a new observation)
testPoint = allFeatures_test(1:285,:);  % A test data point

% Predict the class of the test point
%[predictedLabel, scores] = predict(knnModel, testPoint);
[predictedLabel, scores] = predict(trainedModel.ClassificationKNN, testPoint);

% Find the nearest neighbors of the test point
[nearestIdx, distances] = knnsearch(X, testPoint, 'K', k);

%%
