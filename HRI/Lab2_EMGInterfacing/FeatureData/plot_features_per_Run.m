
for i = 10:20
    % Build the filename, matching the format "Shot_01", etc.
    fileName = sprintf('myEMGData_Shot_%02d_F.mat', shotNumber(i));

    if isfile(fileName)
        data = load(fileName);

        data = reshape(permute(data.features, [3 1 2]), 285, 32);

        if polarity(i) == 1
            allGoodData = [allGoodData; data];  % concatenate vertically
            GoodDataFlag = [GoodDataFlag; ones(size(data,1),1)];
            figure
            plot(data)
            title(['Good Shot Number ', num2str(i)])

            xlabel('Sample Number')
            ylabel('Unit Amplitude')
            legend



        elseif polarity(i) == 0
            allBadData = [allBadData; data];
            BadDataFlag = [BadDataFlag; zeros(size(data,1),1)];
            figure
            plot(data)
            title(['Bad Shot Number ', num2str(i)])
            xlabel('Sample Number')
            ylabel('Unit Amplitude')
            legend

        else
            warning('Invalid polarity at index %d: %d', i, polarity(i));
        end
    else
        warning('File not found: %s', fileName);
    end
end

