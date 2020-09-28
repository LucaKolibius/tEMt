function [response,rt] = get_response_tuning(tStart,btns)
error('You are on the wrong path, padawan');
%% default settings
if nargin ==0
    tStart = GetSecs;
end;

%% response polling
if isfield(btns,'gamepadName') % check the gamepad
        
    [buttonState,axisState] = poll_response_game_pad(btns);
    [~,~, keyCode] = KbCheck;
    
    if keyCode(btns.escapeKey)
        ShowCursor;
        Screen('CloseAll');
        close all;
        fclose(params.fid);
        sca;
        return
    elseif axisState(1) == -1
        response = 0;
    elseif axisState(2) == 1
        response = 1;
    elseif axisState(1) == 1
        response = 2;
    elseif axisState(2) == -1
        response = 3;
    elseif any(buttonState(1:4))
        response = find(buttonState(1:4)~=0)+3;
    else
        response = [];
    end
    
else % Check the keyboard.
    [~,~, keyCode] = KbCheck;
    
    if ~any(keyCode)
        response = [];
        rt = [];
    else        
        if keyCode(btns.escapeKey)
            ShowCursor;
            Screen('CloseAll');
            close all;
            fclose(params.fid);
            sca;
            return
        elseif keyCode(btns.leftKey)
            response = 0;
        elseif keyCode(btns.downKey)
            response = 1;
        elseif keyCode(btns.rightKey)
            response = 2;
        elseif keyCode(btns.upKey)
            response = 3;
        elseif keyCode(btns.end)
            response = 4;
        else
            response = NaN;
        end
        tEnd = GetSecs;
        rt = tEnd - tStart;        
    end
end


