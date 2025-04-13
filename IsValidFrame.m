%Determine if a recorded frame is valid
function trackedBodies = IsValidFrame(Bodies)
    anyBodiesTracked = any(Bodies ~= 0);
    if anyBodiesTracked < 1
        trackedBodies = 0;
        return
    end
    trackedBodies = find(Bodies);
    return
end