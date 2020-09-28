function iti_trial(params, params2)

%%
%19/07/2016 - FRO: fixed a bug in the way random numbers were drawn
%26/04/2017 - FRO: introduced params.Yoffs for consistency
%27/04/2017 - FRO: changed initla vbl sample to correct sync issues

%% Blank sceen
if isempty(params.bckimTexture)
    if isfield(params,'vbl')
        vbl = params.vbl;
    else
        vbl = Screen('Flip', params.window);
    end;
    
    for frame = 1:params2.numFrames(1)
        
        Screen('FillRect',params.window, params.bc_color);
        Screen('TextSize', params.window, 120);
        DrawFormattedText( params.window, '.', params.xCenter+1,  params.yCenter+params.Yoffs, [1 0 0]);
        
        %Screen('TextSize', params.window, 40);
        %DrawFormattedText( params.window, params.resp_cat1 ,params.X(2), params.Y(2)+100, [0 0 0]);
        %DrawFormattedText( params.window, params.resp_cat2 ,params.X(3), params.Y(3)+100, [0 0 0]);
        
        % Flip to the screen
        vbl = Screen('Flip', params.window, vbl + (params2.waitframes - 0.5) * params.ifi);
        
    end
else
    if isfield(params,'vbl')
        vbl = params.vbl;
    else
        vbl = Screen('Flip', params.window);
    end
    
    for frame = 1:params2.numFrames(1)
        
        Screen('DrawTexture', params.window,params.bckimTexture);
        Screen('TextSize', params.window, 120);
        DrawFormattedText( params.window, '.', params.xCenter+1, params.yCenter+params.Yoffs, [1 0 0]);
        
        %Screen('TextSize', params.window, 40);
        %DrawFormattedText( params.window, params.resp_cat1 ,params.X(2), params.Y(2)+100, [0 0 0]);
        %DrawFormattedText( params.window, params.resp_cat2 ,params.X(3), params.Y(3)+100, [0 0 0]);
        
        % Flip to the screen
        vbl = Screen('Flip', params.window, vbl + (params2.waitframes - 0.5) * params.ifi);
        
    end;
end;