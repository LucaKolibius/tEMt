function end_of_task(params)

%% 27/04/2017 by FRO, adapted for background compatibility and fixed vbl-sync

vbl = Screen('Flip',params.window);%fix added
for it = 1:params.numFrames(1)
    
    if ~isfield(params,'bckimTexture') || isempty(params.bckimTexture)
        Screen('FillRect',params.window, params.bc_color);
    else
        Screen('DrawTexture', params.window,params.bckimTexture);
    end;
    
    Screen('TextSize',  params.window, 40);
    DrawFormattedText( params.window, 'Task completed. Thank you!', 'center',  params.yCenter-100, [.25 .25 .25]);
    
    % Flip to the screen
    vbl = Screen('Flip', params.window, vbl + (params.waitframes - 0.5) * params.ifi);
    
end;
%%
return;