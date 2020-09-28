function [gp]= setup_gamepad(gp_name)
if nargin ==0
    gp_name = 'Logitech Logitech(R) Precision(TM) Gamepad';
end;
%% Get information on gamepad availability.
try
    numGamepads = Gamepad('GetNumGamepads');
    gamepadName = Gamepad('GetGamepadNamesFromIndices', 1:numGamepads);
    
    idx = [];
    idx = find(strcmp(gp_name,gamepadName));
    
    gamepadIndex = zeros(length(idx),1);
    for it = 1:length(idx)
        gamepadIndex(it) = Gamepad('GetGamepadIndicesFromNames',gamepadName{idx(it)});
    end;
    
    gamepadName = Gamepad('GetGamepadNamesFromIndices', gamepadIndex);
    %% Get information on gamepad configuration.
    numButtons = Gamepad('GetNumButtons', gamepadIndex);
    numAxes = Gamepad('GetNumAxes', gamepadIndex);
    numBalls = Gamepad('GetNumBalls', gamepadIndex);
    numHats = Gamepad('GetNumHats', gamepadIndex);
    %% Read gamepad states.
    k = 0;
    while k <1
        fprintf('Reading default parameters of gamepad - please ensure that all buttons are released\n');
        buttonState = Gamepad('GetButton', gamepadIndex, 1:numButtons);
        axisState = Gamepad('GetAxis', gamepadIndex, 1:numAxes);
        
        ref_aS = axisState;
        ref_bS = buttonState;
        if sum(ref_bS) ==0 && sum(ref_aS(3:5) ==  1.0e+04 .*[-3.2768   -3.2768   -3.2768])/3
            k = 1;
        else
            fprintf('Wrong default parameters detected - please ensure that all buttons are released\n');
        end;
        fprintf('Default parameters sucessfully acquired\n');
    end;
    %%
    gp.gamepadName = gamepadName;
    gp.gamepadIndex = gamepadIndex;
    gp.numButtons = numButtons;
    gp.numAxes = numAxes;
    gp.numBalls = numBalls;
    gp.numHats = numHats;
    gp.ref_aS = ref_aS;
    gp.ref_bS = ref_bS;
catch
    gp =[];
end;
return;