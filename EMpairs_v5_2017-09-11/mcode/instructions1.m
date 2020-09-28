function instructions1(params)

vbl = Screen('Flip',params.window);
for it = 1:params.Ins.numFrames(1)

    if ~isempty(params.bckimTexture)
        Screen('DrawTexture',  params.window, params.bckimTexture);
    else
        Screen('FillRect',params.window, params.bc_color);
    end
    
    Screen('TextSize',  params.window, 40);
    DrawFormattedText( params.window, params.instructions1.a, 'center',  params.yCenter-100, [.25 .25 .25]);
    DrawFormattedText( params.window, params.instructions1.b, 'center',  params.yCenter-50, [.25 .25 .25]);
    DrawFormattedText( params.window, params.instructions1.c, 'center',  params.yCenter+10, [.25 .25 .25]);
    
    % Flip to the screen
    vbl = Screen('Flip', params.window, vbl + (params.Ins.waitframes - 0.5) * params.ifi);
    
end


if ~isempty(params.bckimTexture)
    Screen('DrawTexture',  params.window, params.bckimTexture);
else
    Screen('FillRect',params.window, params.bc_color);
end

Screen('TextSize',  params.window, 40);
DrawFormattedText( params.window, params.instructions1.a, 'center',  params.yCenter-100, [.25 .25 .25]);
DrawFormattedText( params.window, params.instructions1.b, 'center',  params.yCenter-50, [.25 .25 .25]);
DrawFormattedText( params.window, params.instructions1.c, 'center',  params.yCenter+10, [.25 .25 .25]);

DrawFormattedText( params.window, params.instructions1.d, 'center',  params.yCenter+100, [.25 .25 .25]);
Screen('Flip',  params.window);

f=0;
while f<1
    tStart = GetSecs;
    [response,~] = get_response(1,tStart,params.btns);
    KbReleaseWait;
    GpWait(params.btns);
    if ~isempty(response)
        f=1;
    end
end

return;