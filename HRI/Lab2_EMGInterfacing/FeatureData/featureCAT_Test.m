
%Recall Train Data using Class. App


%%

% Read in the Excel file
excelFile = readmatrix('DataLog.xlsx');
shotNumber = excelFile(:,1);
polarity = excelFile(:,2); % 1 = good, 0 = bad

% Initialize storage for concatenated data
allGoodData = [];
allBadData = [];

% Loop over each shot
GoodDataFlag = [];
BadDataFlag = [];
for i = 10:20
    % Build the filename, matching the format "Shot_01", etc.
    fileName = sprintf('myEMGData_Shot_%02d_F.mat', shotNumber(i));

    if isfile(fileName)
        data = load(fileName);

        data = reshape(permute(data.features, [3 1 2]), 285, 32);

        if polarity(i) == 1
            allGoodData = [allGoodData; data];  % concatenate vertically
            GoodDataFlag = [GoodDataFlag; ones(size(data,1),1)];

        elseif polarity(i) == 0
            allBadData = [allBadData; data];
            BadDataFlag = [BadDataFlag; zeros(size(data,1),1)];
        else
            warning('Invalid polarity at index %d: %d', i, polarity(i));
        end
    else
        warning('File not found: %s', fileName);
    end
end

% Display results
fprintf('Total good samples: %d\n', size(allGoodData, 2));
fprintf('Total bad samples: %d\n', size(allBadData, 2));
%fprintf('Total good samples: %d\n', GoodDataFlag);
%fprintf('Total bad samples: %d\n', BadDataFlag);

allData = [allGoodData; allBadData];
allLabels = [GoodDataFlag; BadDataFlag];
tableDataTest = table(allData,allLabels);
% Optional: Save to file for later use
save('StitchedEMGDataTest.mat', 'allGoodData', 'allBadData', 'allData', 'allLabels', 'tableDataTest');

%%
%yfit_train = trainedModel.predictFcn(tableDataTrain);
yfit_test = trainedModel.predictFcn(tableDataTest);

