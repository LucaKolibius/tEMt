function wait_barEM(params,dtxt)

%x = [params.centeredRect1(1) params.centeredRect1(3)];
x = [params.xCenter-150 params.xCenter+150];
y = [params.yCenter-12.5 params.yCenter+12.5];

d = (x(2)-x(1))/100;

%%
vbl = Screen('Flip',params.window);

for it = 1:100
    %% Draw the background image
    for frame = 1:params.numFrames(1)
        
%         if ~isfield(params,'bckimTexture') || isempty(params.bckimTexture)
%             Screen('FillRect',params.window, params.bc_color);
%             Screen('DrawTexture', params.window, params.bckimTexture2,[],[940 250 1040 350],0);
%         else
%             Screen('DrawTexture', params.window,params.bckimTexture);
%             Screen('DrawTexture', params.window, params.bckimTexture2,[],[940 250 1040 350],0);
%         end;
        
        Screen('TextSize',  params.window, 40);
        
        Screen('FrameRect', params.window ,params.black,[x(1) y(1) x(2) y(2)], 5);
        Screen('FillRect', params.window ,params.black,[x(1) y(1) x(1)+(d.*it) y(2)], 5);
        %         DrawFormattedText( params.window, dtxt,'center',
        %         params.yCenter-params.yoff, [.25 .25 .25]); % previous line
        DrawFormattedText( params.window, dtxt,'center',params.yCenter-params.Yoffs-50, [.25 .25 .25]); % if I set Yoffs to 50 then the stimuli are moved as well
        
        % Flip to the screen
        vbl = Screen('Flip', params.window, vbl + (params.waitframes - 0.5) * params.ifi);
    end
    
end

% if ~isfield(params,'bckimTexture') || isempty(params.bckimTexture)
%     Screen('FillRect',params.window, params.bc_color);
%     Screen('DrawTexture', params.window, params.bckimTexture2,[],[940 250 1040 350],0);
% else
%     Screen('DrawTexture', params.window,params.bckimTexture);
%     Screen('DrawTexture', params.window, params.bckimTexture2,[],[940 250 1040 350],0);
% end;

Screen('TextSize',  params.window, 40);
Screen('FrameRect', params.window ,params.black,[x(1) y(1) x(2) y(2)], 5);
Screen('FillRect', params.window ,params.black,[x(1) y(1) x(1)+(d.*it) y(2)], 5);
% DrawFormattedText( params.window, dtxt,'center',  params.yCenter-params.yoff, [.25 .25 .25]);
DrawFormattedText( params.window, dtxt,'center',  params.yCenter-params.Yoffs-50, [.25 .25 .25]);

DrawFormattedText( params.window, params.tunInstrBreak2, 'center',  params.yCenter+100, [.25 .25 .25]);
Screen('Flip',  params.window);

%%
% if strcmp(params.debugmode,'no') || strcmp(params.debugmode,'mode2')
f=0;
while f<1
    tStart = GetSecs;
    [response,rt] = get_response(1,tStart,params.btns);
    KbReleaseWait;
    GpWait(params.btns);
    if ~isempty(response)
        f=1;
    end
end
end
