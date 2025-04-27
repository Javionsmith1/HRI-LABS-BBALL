
tableDataTrain_col1 = tableDataTrain(:,1);
tableDataTrain_col2 = tableDataTrain(:,2);

% Assume you have already trained the model:
Mdl = fitcdiscr(tableDataTrain(:,1), tableDataTrain(:,2));

% Get linear coefficients for binary classification
coef = Mdl.Coeffs(1,2);
w = coef.Linear;

% Rank features by absolute coefficient value
[~, featureRank] = sort(abs(w), 'descend');

% If X is a table, get variable names; else generate default names
if istable(X)
    featureNames = X.Properties.VariableNames;
else
    featureNames = strcat("Feature", string(1:size(X,2)));
end

% Reorder names and coefficients for plotting
rankedNames = featureNames(featureRank);
rankedWeights = w(featureRank);

% Plot bar chart
figure;
bar(abs(rankedWeights));
xticks(1:length(rankedNames));
xticklabels(rankedNames);
xtickangle(45);
ylabel('Absolute Coefficient');
title('Feature Importance from LDA Coefficients');
grid on;