function [colorVidData,depthVidData] = GetKinectData(colorVid,depthVid)
    %Record Video using Kinect for data
    start([colorVid depthVid]);
    trigger([colorVid depthVid]);

    % Retrieve the frames
    colorVidData = getdata(colorVid);
    depthVidData = getdata(depthVid);
    stop([colorVid depthVid]);
    return

end