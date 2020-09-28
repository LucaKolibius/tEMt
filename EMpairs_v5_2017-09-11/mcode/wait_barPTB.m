function wait_barPTB(params,wt,dtxt)
x = [params.centeredRect1(1) params.centeredRect1(3)];
y = [params.yCenter-12.5 params.yCenter+12.5];

d = (x(2)-x(1))/100;

for it = 1:100
    %% Draw the background image
    if ~isfield(params,'bckimTexture')
        Screen('FillRect',params.window, params.bc_color);
    else        
        Screen('DrawTexture', params.window,params.bckimTexture);
    end;
    
    Screen('TextSize',  params.window, 40);
    
    Screen('FrameRect', params.window ,params.black,[x(1) y(1) x(2) y(2)], 5);
    Screen('FillRect', params.window ,params.black,[x(1) y(1) x(1)+(d.*it) y(2)], 5);
    DrawFormattedText( params.window, dtxt,'center',  params.yCenter-100, [.25 .25 .25]);
    
    % Flip to the screen
    Screen('Flip', params.window);
    WaitSecs(wt/100);
    
end;

%sca;
return;