% Read in the Excel file
excelFile = readmatrix('DataLog.xlsx');
shotNumber = excelFile(:,1);
polarity = excelFile(:,2); % 1 = good, 0 = bad

% Initialize storage for concatenated data
allGoodData = [];
elbowData = [];
moreWristData = [];
higherArchData = [];
lowerArchData = [];


% Loop over each shot
GoodDataFlag = [];
elbowDataFlag = [];
moreWristDataFlag = [];
higherArchDataFlag = [];
lowerArchDataFlag = [];

for i = 1:54
    % Build the filename, matching the format "Shot_01", etc.
    fileName = sprintf('myEMGData_Shot_%02d_F.mat', shotNumber(i));

    if isfile(fileName)
        data = load(fileName);

        data = reshape(permute(data.features, [3 1 2]), 285, 32);

        if polarity(i) == 0
            allGoodData = [allGoodData; data];  % concatenate vertically
            GoodDataFlag = [GoodDataFlag; zeros(size(data,1),1)];

        elseif polarity(i) == 3
            moreWristData = [moreWristData; data];
            moreWristDataFlag = [moreWristDataFlag; 3*ones(size(data,1),1)];

        elseif polarity(i) == 2
            elbowData = [elbowData; data]
            elbowDataFlag = [elbowDataFlag; 2*ones(size(data,1),1)];

        elseif polarity(i) == 4

            higherArchData = [higherArchData; data]
            higherArchDataFlag = [higherArchDataFlag; 4*ones(size(data,1),1)];

        elseif polarity(i) == 5
            lowerArchData = [lowerArchData; data]
            lowerArchDataFlag = [lowerArchDataFlag; 5*ones(size(data,1),1)];
        else
            warning('Invalid polarity at index %d: %d', i, polarity(i));
        end
    else
        warning('File not found: %s', fileName);
    end
end

% Display results
fprintf('Total good samples: %d\n', size(allGoodData, 2));
fprintf('Total bad samples: %d\n', size(moreWristData, 2));
%fprintf('Total good samples: %d\n', GoodDataFlag);
%fprintf('Total bad samples: %d\n', BadDataFlag);

allData = [allGoodData; moreWristData; elbowData; higherArchData; lowerArchData];
allLabels = [GoodDataFlag; moreWristDataFlag; elbowDataFlag; higherArchDataFlag; lowerArchDataFlag];
tableDataTrain = table(allData,allLabels);
% Optional: Save to file for later use
save('StitchedEMGDataTrain.mat', 'allGoodData', 'moreWristData', 'allData', 'allLabels', 'tableDataTrain');
