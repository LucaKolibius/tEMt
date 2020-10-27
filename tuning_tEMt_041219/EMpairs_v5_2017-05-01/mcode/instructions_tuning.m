function instructions_tuning(params,dt)

params = compute_numFrames(params,dt);

vbl = Screen('Flip',params.window);
for it = 1:params.numFrames(1)
    %Screen('DrawTexture',  params.window, params.bckimTexture);
    Screen('FillRect',params.window, params.bc_color);
    
    Screen('TextSize',  params.window, 34);
    DrawFormattedText( params.window, params.tunInstr1, 'center',  params.yCenter-190, [0 0 1]);
    DrawFormattedText( params.window, params.tunInstr2, 'center',  params.yCenter-120, [.25 .25 .25]);
%     DrawFormattedText( params.window, 'Please indicate for each image, if the image belongs to', 'center',  params.yCenter-50, [.25 .25 .25]);
    %DrawFormattedText( params.window, ['the ',params.resp_cat1,' category or to the ',params.resp_cat2,' category.'], 'center',  params.yCenter+5, [.25 .25 .25]);
    DrawFormattedText( params.window, params.tunInstr3, 'center',  params.yCenter-50, [.25 .25 .25]);

%     DrawFormattedText( params.window, ['the ',params.resp_cat1,' category or to another category.'], 'center',  params.yCenter+5, [.25 .25 .25]);
    DrawFormattedText( params.window, params.tunInstr4, 'center',  params.yCenter+50, [.25 .25 .25]);
    DrawFormattedText( params.window, params.tunInstr5, 'center',  params.yCenter+100, [.25 .25 .25]);
    DrawFormattedText( params.window, params.tunInstr6, 'center',  params.yCenter+150, [.25 .25 .25]);
    DrawFormattedText( params.window, params.tunInstr7, 'center',  params.yCenter+225, [.25 .25 .25]);
    
    % Flip to the screen
    vbl = Screen('Flip', params.window, vbl + (params.waitframes - 0.5) * params.ifi);
    
end

%%

%Screen('DrawTexture',  params.window, params.bckimTexture);
Screen('FillRect',params.window, params.bc_color);

Screen('TextSize',  params.window, 34);
DrawFormattedText( params.window, params.tunInstr1, 'center',  params.yCenter-190, [0 0 1]);
DrawFormattedText( params.window, params.tunInstr2, 'center',  params.yCenter-120, [.25 .25 .25]);
DrawFormattedText( params.window, params.tunInstr3, 'center',  params.yCenter-50, [.25 .25 .25]);

DrawFormattedText( params.window, params.tunInstr4, 'center',  params.yCenter+50, [.25 .25 .25]);
DrawFormattedText( params.window, params.tunInstr5, 'center',  params.yCenter+100, [.25 .25 .25]);
DrawFormattedText( params.window, params.tunInstr6, 'center',  params.yCenter+150, [.25 .25 .25]);
DrawFormattedText( params.window, params.tunInstr7, 'center',  params.yCenter+225, [.25 .25 .25]);

DrawFormattedText( params.window, params.tunInstr8, 'center',  params.yCenter+300, [0 1 0]);
Screen('Flip',  params.window);

%%
% if strcmp(params.debugmode,'no') || strcmp(params.debugmode,'mode2')
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
% end
%sca;

return;