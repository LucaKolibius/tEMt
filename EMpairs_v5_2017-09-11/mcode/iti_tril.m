function iti_trial(params)    
%% Blank sceen
if ~isfield(params,'bckimTexture')
    Screen('FillRect',params.window, params.bc_color);
else
    Screen('DrawTexture', params.window,params.bckimTexture);
end;
Screen('Flip', params.window);
WaitSecs(params.iti(min(randperm(length(params.iti)))));