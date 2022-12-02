% Gain
% Inputs: angle --- the relative angle from looking straight ahead in
% degrees
% Outputs: val --- the gain

function val = Gain(angle)
    val = angle - angle + 1;
end