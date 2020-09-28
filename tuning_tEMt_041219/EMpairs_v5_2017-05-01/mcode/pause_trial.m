function pause_trial(btns)
conti = 1;
while conti == 1
    % Check the keyboard.
    [~,~, keyCode,~] = KbCheck;
    
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
        elseif keyCode(btns.resume)
            conti = 0;
        end       
    end
end