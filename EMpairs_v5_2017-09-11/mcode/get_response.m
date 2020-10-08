function [response,rt] = get_response(respToBeMade,tStart,btns)
if nargin ==0
    tStart = GetSecs;
    % Cue to determine whether a response has been made
    respToBeMade = true;
end;

while respToBeMade == true
    
    %     if isfield(btns,'gamepadName')
    %         % Check the gamepad.
    %         [buttonState,axisState] = poll_response_game_pad(btns);
    %         [~,~, keyCode] = KbCheck;
    %
    %         if keyCode(btns.escapeKey)
    %             ShowCursor;
    %             sca;
    %             return
    %         elseif axisState(1) == -1
    %             response = 0;
    %             respToBeMade = false;
    %         elseif axisState(2) == 1
    %             response = 1;
    %             respToBeMade = false;
    %         elseif axisState(1) == 1
    %             response = 2;
    %             respToBeMade = false;
    %         elseif axisState(2) == -1
    %             response = 3;
    %             respToBeMade = false;
    %         elseif any(buttonState(1:4))
    %             response = find(buttonState(1:4)~=0)+3;
    %             respToBeMade = false;
    %         end
    %
    %     else
    % Check the keyboard.
    [~,tEnd, keyCode] = KbCheck;
    if keyCode(btns.escapeKey)
        ShowCursor;
        sca;
        return
    elseif keyCode(btns.leftKey)
        response = 0;
        respToBeMade = false;
    elseif keyCode(btns.downKey)
        response = 1;
        respToBeMade = false;
    elseif keyCode(btns.rightKey)
        response = 2;
        respToBeMade = false;
    elseif keyCode(btns.upKey)
        response = 3;
        respToBeMade = false;
        %         elseif keyCode(btns.spaceKey)
        %             response = 4;
        %             respToBeMade = false;
        %         elseif keyCode(btns.enter)
        %             response = 4;
        %             respToBeMade = false;
    elseif keyCode(btns.end)
        response = 4;
        respToBeMade = false;
    elseif keyCode(btns.minus)
        response = 4;
        respToBeMade = false;
    end
end
% end
% tEnd = GetSecs;
rt = tEnd - tStart;

end % END OF FUNCTION

