utilpath = 'C:\ProgramData\MATLAB\SupportPackages\R2019b\toolbox\imaq\supportpackages\kinectruntime\kinectforwindowsruntimeexamples';
addpath(utilpath);

% The Kinect for Windows Sensor shows up as two separate devices in IMAQHWINFO.
hwInfo = imaqhwinfo('kinect')
hwInfo.DeviceInfo(1)
hwInfo.DeviceInfo(2)

% Create the VIDEOINPUT objects for the two Kinect streams
colorVid = videoinput('kinect',1)
depthVid = videoinput('kinect',2)

% Select Video Source for the Kinect
depthSrc = getselectedsource(depthVid)
depthSrc.EnableBodyTracking = 'on';

% Set the Video Framing Data
FramesPerTrigger = 90
triggerconfig([colorVid depthVid],'manual');
colorVid.FramesPerTrigger = FramesPerTrigger;
depthVid.FramesPerTrigger = FramesPerTrigger; 

% Create skeleton connection map to link the joints.
SkeletonConnectionMap = [ [4 3];  % Neck
                          [3 21]; % Head
                          [21 2]; % Right Leg
                          [2 1];  
                          [21 9];
                          [9 10];  % Hip
                          [10 11];
                          [11 12]; % Left Leg
                          [12 24];
                          [12 25];
                          [21 5];  % Spine
                          [5 6];
                          [6 7];   % Left Hand 
                          [7 8];    
                          [8 22];
                          [8 23];
                          [1 17];
                          [17 18];
                          [18 19];  % Right Hand
                          [19 20];
                          [1 13];
                          [13 14];
                          [14 15];
                          [15 16];                          
                        ];

% Marker colors for up to 6 bodies.
colors = ['b';'r';'g';'c';'y';'m'];