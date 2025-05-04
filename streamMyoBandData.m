function [featuredata] = streamMyoBandData(time)
%% Get data   emgData size is [1000 samples x 8 channels]

hMyo = Inputs.MyoUdp.getInstance();
hMyo.initialize();
%emgData = hMyo.getData;
channels = 8;
SAMPLE_RATE = 1000; %200 = hertz
num_sample = time * SAMPLE_RATE;


hMyo.getData(num_sample, 1:channels);

emg = hMyo.getData(num_sample, 1:channels);
pause(4);


%% Extract features from data
%%%%%%%%%%%%%%%%%%%%%%

% setup constants for feature extraction
featureNames = {'MAV' 'LEN' 'ZC' 'SSC'};
num_channels = 8; % 8 channels in myo band
num_features = length(featureNames);
num_emg_samples = size(emg,1);

windowSize = 150; % number of samples to compute features
binSize = 10; % number of sample to advance across samples
zc_thresh = 0.1;  % threshold vaue for zero crossing
ssc_thresh = 0.1; % threshold vaue for slope sign changes
Fs = 1000; % sample rate

% create indices for start and end of sliding data windows
idxStart = 1:binSize:num_emg_samples-windowSize-1;
idxEnd = idxStart+windowSize-1;
num_feature_samples = length(idxStart);

% preallocate feature matrix
features = zeros(num_channels, num_features, num_feature_samples);

% loop through and slide window by increment and perform feature extraction
for b = 1:length(idxStart)
    windowData = emg(idxStart(b):idxEnd(b),:);
    f = feature_extract(windowData',windowSize,zc_thresh,ssc_thresh,Fs);
    features(:,:,b) = f;
end

%figure(4)
allData = reshape(permute(features, [3 1 2]), 285, 32);
featuredata = table(allData);








end