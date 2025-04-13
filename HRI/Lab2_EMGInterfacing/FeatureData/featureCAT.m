% Read in the Excel file
excelFile = readmatrix('DataLog.xlsx');
shotNumber = excelFile(:,1);
polarity = excelFile(:,2); % 1 = good, 0 = bad

% Initialize storage for concatenated data
allGoodData = [];
allBadData = [];

% Loop over each shot
for i = 1:length(shotNumber)
    % Build the filename, matching the format "Shot_01", etc.
    fileName = sprintf('myEMGData_Shot_%02d_F.mat', shotNumber(i));

    if isfile(fileName)
        data = load(fileName);
        data = reshape(data.features, 1, []);

        if polarity(i) == 1
            allGoodData = [allGoodData,data];  % concatenate vertically

        elseif polarity(i) == 0
            allBadData = [allBadData, data];
        else
            warning('Invalid polarity at index %d: %d', i, polarity(i));
        end
    else
        warning('File not found: %s', fileName);
    end
end

% Display results
fprintf('Total good samples: %d\n', size(allGoodData, 1));
fprintf('Total bad samples: %d\n', size(allBadData, 1));

% Optional: Save to file for later use
save('StitchedEMGData.mat', 'allGoodData', 'allBadData');
