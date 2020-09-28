
function [AC,rt,params1] = distracter_task(params1,params2,ntrl)

%%
AC = zeros(length(ntrl),1);
rt = zeros(length(ntrl),1);

%%
% if ~isfield(params1,'dist_trl_idx')
%     params1.dist_trl_idx = randperm(length(params1.rnum));
%     params1.dist_trl_idx = params1.dist_trl_idx(1:ntrl);
% else
%     params1.dist_trl_idx = params1.dist_trl_idx(end)+1:params1.dist_trl_idx(end)+ntrl;
% end;
rand('state',sum(100*clock));
x = randperm(length(params1.rnum));
params1.dist_trl_idx = x(1:ntrl);

if ~isempty(params1.bckimTexture)
    
    vbl = Screen('Flip',params1.window);
    params2.vbl = vbl;

    iti_trial(params2);
    
    for jt = 1:length(params1.dist_trl_idx)
        
        Screen('DrawTexture',  params1.window, params1.bckimTexture);
        
        Screen('TextSize',  params1.window, 120);
        DrawFormattedText( params1.window, '.',params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
        Screen('TextSize',  params1.window, 40);
        DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Odd',params1.xCenter-params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Even',params1.xCenter+params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
        
        Screen('Flip',  params1.window);
        
        if strcmp(params1.debugmode,'no') ||  strcmp(params1.debugmode,'mode2')
            tStart = GetSecs;
            [response,rt(jt)] = get_response(1,tStart,params1.btns);
            KbReleaseWait;
            GpWait(params1.btns);
            
            %vbl = Screen('Flip',params1.window);
            for frame = 1:params1.numFrames(1)
                Screen('DrawTexture',  params1.window, params1.bckimTexture);
                Screen('TextSize',  params1.window, 40);
                DrawFormattedText( params1.window, 'Odd',params1.xCenter-params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
                DrawFormattedText( params1.window, 'Even',params1.xCenter+params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
                Screen('TextSize',  params1.window, 120);
                DrawFormattedText( params1.window, '.',params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
                    
                if (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 1) && (response ==0)                    
                    AC(jt) = 1;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [0 1 0]);                    
                elseif (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 1) && (response ==2)
                    AC(jt) = 0;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [1 0 0]);
                elseif (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 0) && (response ==2)
                    AC(jt) = 1;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [0 1 0]);
                else
                    AC(jt) = 0;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [1 0 0]);
                end;
                
                % Flip to the screen
                vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            end;
        end;
        params2.vbl = vbl;
        iti_trial(params2);
    end;
    
else
    
    vbl = Screen('Flip',params1.window);
    params2.vbl = vbl;
    
    iti_trial(params2);
        
    for jt = 1:length(params1.dist_trl_idx)
        
        Screen('FillRect',params1.window, params1.bc_color);
        
        Screen('TextSize',  params1.window, 120);
        DrawFormattedText( params1.window, '.',params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
        
        Screen('TextSize',  params1.window, 40);
        DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Odd',params1.xCenter-params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Even',params1.xCenter+params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
        
        Screen('Flip',  params1.window);
        
        if strcmp(params1.debugmode,'no') ||  strcmp(params1.debugmode,'mode2')
            tStart = GetSecs;
            [response,rt(jt)] = get_response(1,tStart,params1.btns);
            KbReleaseWait;
            GpWait(params1.btns);
            %vbl = Screen('Flip',params1.window);
            for frame = 1:params1.numFrames(1)
                Screen('FillRect',params1.window, params1.bc_color);
                Screen('TextSize',  params1.window, 40);
                DrawFormattedText( params1.window, 'Odd',params1.xCenter-params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
                DrawFormattedText( params1.window, 'Even',params1.xCenter+params1.xoff/2, params1.yCenter+params1.yoff, [.25 .25 .25]);
                Screen('TextSize',  params1.window, 120);
                DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
                                
                if (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 1) && (response ==0)
                    AC(jt) = 1;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [0 1 0]);
                elseif (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 1) && (response ==2)
                    AC(jt) = 0;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [1 0 0]);
                elseif (mod(params1.rnum(params1.dist_trl_idx(jt)),2)== 0) && (response ==2)
                    AC(jt) = 1;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter, params1.yCenter-100 , [0 1 0]);
                else
                    AC(jt) = 0;
                    Screen('TextSize',  params1.window, 40);
                    DrawFormattedText( params1.window, num2str(params1.rnum(params1.dist_trl_idx(jt))),params1.xCenter,  params1.yCenter-100, [1 0 0]);
                end;
                
                % Flip to the screen
                vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            end;
        end;
        params2.vbl = vbl;
        iti_trial(params2);
    end;
end;

return;
