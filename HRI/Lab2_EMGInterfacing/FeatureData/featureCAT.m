% Read in DataLog.xlsx
excelFile = readmatrix('DataLog.xlsx');
shotNumber = excelFile(:,1);    % e.g., 1, 2, etc.
polarity = excelFile(:,2);      % 1 = good, 0 = bad

% Initialize accumulators
goodSum = 0;
goodCount = 0;
badSum = 0;
badCount = 0;


% Loop over each entry in the Excel sheet
for i = 1:length(shotNumber)
    % Construct the filename based on shot number
    fileName = sprintf('myEMGData_Shot_%02d_F.mat', shotNumber(i));
    
    % Check if the file exists
    if isfile(fileName)
        data = load(fileName);
        
        % Replace 'features' with the actual variable name in the .mat files
        f = data.features;

        % Sort into good/bad groups
        if polarity(i) == 1
            goodSum = goodSum + f;
            goodCount = goodCount + 1;
        elseif polarity(i) == 0
            badSum = badSum + f;
            badCount = badCount + 1;
        else
            warning('Unexpected polarity value at index %d: %d', i, polarity(i));
        end
    else
        warning('File not found: %s', fileName);
    end
end

% Calculate averages
if goodCount > 0
    avgGood = goodSum / goodCount;
    disp('Average feature vector for GOOD runs:');
    disp(avgGood);
end

if badCount > 0
    avgBad = badSum / badCount;
    disp('Average feature vector for BAD runs:');
    disp(avgBad);
end
