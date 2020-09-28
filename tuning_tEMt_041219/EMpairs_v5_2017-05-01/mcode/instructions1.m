function instructions1(params)

vbl = Screen('Flip',params.window);
for it = 1:params.numFrames(1)

    if ~isempty(params.bckimTexture)
        Screen('DrawTexture',  params.window, params.bckimTexture);
    else
        Screen('FillRect',params.window, params.bc_color);
    end;
    
    Screen('TextSize',  params.window, 40);
    DrawFormattedText( params.window, 'Please imagine a story for each one of the following scenes.', 'center',  params.yCenter-params.yoff, [.25 .25 .25]);
    DrawFormattedText( params.window, 'After you have memorized each scene, you will be asked', 'center',  params.yCenter-params.yoff/2, [.25 .25 .25]);
    DrawFormattedText( params.window, 'to rate how plausible it is.', 'center',  params.yCenter+params.yoff/10, [.25 .25 .25]);
    
    % Flip to the screen
    vbl = Screen('Flip', params.window, vbl + (params.waitframes - 0.5) * params.ifi);
    
end;


if ~isempty(params.bckimTexture)
    Screen('DrawTexture',  params.window, params.bckimTexture);
else
    Screen('FillRect',params.window, params.bc_color);
end;

Screen('TextSize',  params.window, 40);
DrawFormattedText( params.window, 'Please imagine a story for each one of the following scenes.', 'center',  params.yCenter-params.yoff, [.25 .25 .25]);
DrawFormattedText( params.window, 'After you have memorized each scene, you will be asked', 'center',  params.yCenter-params.yoff/2, [.25 .25 .25]);
DrawFormattedText( params.window, 'to rate how plausible it is.', 'center',  params.yCenter+params.yoff/10, [.25 .25 .25]);

DrawFormattedText( params.window, 'Press button to start.', 'center',  params.yCenter+params.yoff, [.25 .25 .25]);
Screen('Flip',  params.window);

f=0;
while f<1
    tStart = GetSecs;
    [response,~] = get_response(1,tStart,params.btns);
    KbReleaseWait;
    GpWait(params.btns);
    if ~isempty(response)
        f=1;
    end;
end;

return;