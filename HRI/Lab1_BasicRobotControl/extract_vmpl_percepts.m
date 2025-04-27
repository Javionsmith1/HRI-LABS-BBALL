% adapted from MiniVIE\+Mpl\MplUnitySink
% Matt Fifer 2019/01/27

 function perceptData = extract_vmpl_percepts(data)
            
    % Outputs:
    %   perceptData -  
    %         perceptData.jointPercepts
    % 
    %             position: [1x27 single]
    %             velocity: [1x27 single]
    %         (TODO) segmentPercepts
    
    % avoid error if the percepts are empty
    nJoints = 27;
    nBytesPerFloat = 4;
    if isempty(data) || length(data) < nJoints*nBytesPerFloat*3
        perceptData = [];
        return;
    end

    % convert packets to percept struct
    floatData = typecast(data(1:nJoints*nBytesPerFloat*3),'single');
    % reshape to position velocity accel and convert to double
    % precision floating point
    floatData = double(reshape(floatData,3,nJoints));

    %data = extract_mpl_percepts_v2(packets);
    perceptData.jointPercepts.position = floatData(1,:);
    perceptData.jointPercepts.velocity = floatData(2,:);

end