%Initialize Project Configuration
Proj_Init;

%Main Loop
while 1
    % Record video and get video data from the kinect
    start([colorVid depthVid]);
    trigger([colorVid depthVid]);

    % Retrieve the frames and check if any Skeletons are tracked
    [colorFrameData,colorTimeData,colorMetaData] = getdata(colorVid);
    [frameDataDepth, timeDataDepth, metaDataDepth] = getdata(depthVid);
    stop([colorVid depthVid]);

    % Runs through each frame of video map and analyze joint data
    for i=1:1:FramesPerTrigger
        trackedBodies = IsValidFrame(metaDataDepth(i).IsBodyTracked);
        if trackedBodies == 0
            continue
        end
        nBodies = length(trackedBodies);
        jointCoordinates = metaDataDepth(i).JointPositions(:, :, trackedBodies);
        jointIndices = metaDataDepth(i).ColorJointIndices(:, :, trackedBodies);
        for j = 1:24
            for body = 1:nBodies
                X1 = [jointIndices(SkeletonConnectionMap(j,1),1,body) jointIndices(SkeletonConnectionMap(j,2),1,body)];
                Y1 = [jointIndices(SkeletonConnectionMap(j,1),2,body) jointIndices(SkeletonConnectionMap(j,2),2,body)];
                line(X1,Y1, 'LineWidth', 1.5, 'LineStyle', '-', 'Marker', '+', 'Color', colors(body));
           end
           hold on;
        end
        hold off;
        pause(.1);
        clf;
    end
end