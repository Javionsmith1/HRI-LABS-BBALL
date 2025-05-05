function NUMBER_VIE  = get_kinect(colorVid, depthVid, FramesPerTrigger, labeledDistanceX_GoodLabels_mean, trainedModel_kinect)
    %Distance = zeros(FramesPerTrigger*binSize,24);
    DistanceX = zeros(90,24);
    DistanceY = zeros(90,24);
    DistanceZ = zeros(90,24);
    %Main Loop
    %while 1
    NumShots = 1;
    for A=1:1:NumShots
    
    
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
            disp(trackedBodies);
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

        end
        %GoodBadMatrix(A) = input("Good or Bad (1/0)");
    end

        NumShots = 1;
    numColumns = 24;
    numRows = length(DistanceX);
    labels =[];
    
    % FIXME
    % CHANGE TO ONE IF GOOD SHOT
    good_shot = 0;
    
    if (good_shot == 1)
        labels = [ones(FramesPerTrigger,1)]; 
    else
        labels = [zeros(FramesPerTrigger, 1)];
    end
    
    labeledDistanceX = [labels, DistanceX];
    labeledDistanceY = [labels, DistanceY];
    labeledDistanceZ = [labels, DistanceZ];
    
    
    zero_rows = all(DistanceX == 0, 2) & all(DistanceY == 0, 2) & all(DistanceZ == 0, 2);
    
    DistanceX_new = DistanceX;
    DistanceY_new = DistanceY;
    DistanceZ_new = DistanceZ;
    
    DistanceX_new(zero_rows,:) = [];
    DistanceY_new(zero_rows,:) = []; 
    DistanceZ_new(zero_rows,:) = []; 
    
    labeledDistanceX(zero_rows,:) = [];
    labeledDistanceY(zero_rows,:) = []; 
    labeledDistanceZ(zero_rows,:) = []; 
    
    Distance_midline = [];
    for i = 1:24
    Distance_midline(:,i) = sqrt((DistanceX_new(:,i)- DistanceX_new(:,2)).^2 + (DistanceY_new(:,i)- DistanceY_new(:,2)).^2 + (DistanceZ_new(:,i)- DistanceZ_new(:,2)).^2);
    end
    
    classLabels = {'Good' 'Bad'};

    allFeatures = Distance_midline;
    allLabels = labeledDistanceX(:,1);
    
    
    tableData_test = table(allFeatures,allLabels);
    
    yfit_test = trainedModel_kinect.predictFcn(tableData_test);

    Decision = mode(yfit_test);

    good_shot = Decision;
    
    
    labeledDistanceX_BadLabels = Distance_midline(labeledDistanceX(:,1) == 0,:);
    cols_important = [10,11,12,24];
    labeledDistanceX_BadLabels_means = mean(labeledDistanceX_BadLabels(:, cols_important),1);
    
    
    
    labeledDistanceX_BadLabels_maxs = max(labeledDistanceX_BadLabels(:, cols_important),[],1);
    labeledDistanceX_BadLabels_mins = min(labeledDistanceX_BadLabels(:, cols_important),[],1);
    
    [suggest, suggest_idx] = max(labeledDistanceX_GoodLabels_mean - labeledDistanceX_BadLabels_maxs);

    if good_shot == 1  
        NUMBER_VIE = 0;
    else
        %VIEList = [];
        %[~, col_idx] = find(suggest_idx);
        %unique_cols = unique(col_idx);
        %for i = 1:length(unique_cols)
           % col = unique_cols(i);

            switch suggest_idx
                case 1
                    NUMBER_VIE = 2;
                    disp('Adjust Right Elbow')
                    %VIEList = [VIEList, NUMBER_VIE];
                    % if suggest >= 0
                    %     disp('Move Elbow Out')
                    % else
                    %     disp('Move Elbow In')
                    % end
                case 2
                    NUMBER_VIE = 3;
                    disp('Adjust Right Wrist')
                    %VIEList = [VIEList, NUMBER_VIE];
                    % if suggest >= 0
                    %     disp('Move Wrist Forward/Up')
                    % else
                    %     disp('Move Wrist In/Down')
                    % end
                case 3
                    NUMBER_VIE = 4;
                    disp('Adjust Right Hand')
                    %VIEList = [VIEList, NUMBER_VIE];
                    % if suggest >= 0
                    %     disp('Move Hand Forward/Up')
                    %     NUMBER_VIE = 4;
                    % else
                    %     disp('Move Hand In/Down')
                    %     NUMBER_VIE = 5;
                    % end
                case 4
                    NUMBER_VIE = 5;
                    disp('Adjust Right Hand Height')
                    %VIEList = [VIEList, NUMBER_VIE];
                    % if suggest >= 0
                    %     disp('Move Hand up')
                    %     NUMBER_VIE = 4;
                    % else
                    %     disp('Move Hand Down')
                    %     NUMBER_VIE = 5;
                    % end
            end
        % end
    end
end