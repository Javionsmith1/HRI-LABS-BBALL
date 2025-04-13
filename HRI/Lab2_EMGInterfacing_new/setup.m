cd('C:\GitHub\MiniVIE');
MiniVIE.configurePath;

%% Create an object for UDP interface to the Myo Armband
hMyo = Inputs.MyoUdp.getInstance();
hMyo.initialize();
cd('C:\GitHub\hrilabs\Lab2_EMGInterfacing_new');