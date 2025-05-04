%init minivie then return 
cd('C:\GitHub\MiniVIE');
MiniVIE.configurePath;
cd('C:\Users\student\Documents\GitHub\HRI-LABS-BBALL');
UdpAddress = '127.0.0.1';
AnimationTime = 3;

%MiniVie Left arm configuration
LeftUdpLocalPort = 25101; % 25101 = left arm, 25001 = right arm
LeftUdpDestinationPort = 25100; % 25100 = Left arm; 25000 = Right arm; 
LefthArmNet = PnetClass(LeftUdpLocalPort,LeftUdpDestinationPort,UdpAddress);
LefthArmNet.initialize()

%MiniVie Right arm configuration
RightUdpLocalPort = 25001; % 25101 = left arm, 25001 = right arm
RightUdpDestinationPort = 25000; % 25100 = Left arm; 25000 = Right arm; 
RighthArmNet = PnetClass(RightUdpLocalPort,RightUdpDestinationPort,UdpAddress);
RighthArmNet.initialize()

%Set All values to 0
LeftupperArmAngles = zeros(1,7);
LeftfingerAngles = zeros(1,20);
RightupperArmAngles = zeros(1,7);
RightfingerAngles = zeros(1,20);

%create struct for Left Arm
LeftArm.minivie = LefthArmNet;
LeftArm.upperArmAngles = LeftupperArmAngles;
LeftArm.fingerAngles = LeftfingerAngles;

%create struct for Right Arm
RightArm.minivie = RighthArmNet;
RightArm.upperArmAngles = RightupperArmAngles;
RightArm.fingerAngles = RightfingerAngles;

%Initialize to good form position
[RightArm.upperArmAngles, RightArm.fingerAngles] = setGoodPosition("right");
sendArmPositions(RightArm.minivie,RightArm.upperArmAngles, RightArm.fingerAngles);
[LeftArm.upperArmAngles, LeftArm.fingerAngles] = setGoodPosition("left");
sendArmPositions(LeftArm.minivie,LeftArm.upperArmAngles, LeftArm.fingerAngles);

%MyoBand Init
%hMyo = Inputs.MyoUdp.getInstance();
%hMyo.initialize();
%pause(3);

%Kinect initilization
utilpath = 'C:\ProgramData\MATLAB\SupportPackages\R2019b\toolbox\imaq\supportpackages\kinectruntime\kinectforwindowsruntimeexamples';
addpath(utilpath);

% The Kinect for Windows Sensor shows up as two separate devices in IMAQHWINFO.
hwInfo = imaqhwinfo('kinect');
hwInfo.DeviceInfo(1)
hwInfo.DeviceInfo(2)

% Create the VIDEOINPUT objects for the two Kinect streams
colorVid = videoinput('kinect',1);
depthVid = videoinput('kinect',2);

% Select Video Source for the Kinect
depthSrc = getselectedsource(depthVid)
depthSrc.EnableBodyTracking = 'on';

% Set the Video Framing Data
FramesPerTrigger = 90;
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

%Feature Data Init
featureNames = {'MAV' 'LEN' 'ZC' 'SSC'};
num_channels = 24; % 8 channels in myo band
num_features = length(featureNames);
%num_emg_samples = size(emg,1);

windowSize = FramesPerTrigger; % number of samples to compute features
binSize = 10; % number of sample to advance across samples
zc_thresh = 0.2;  % threshold vaue for zero crossing
ssc_thresh = 0.2; % threshold vaue for slope sign changes
Fs = 1000; % sample rate