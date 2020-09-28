function [AC,rt,params1] = distracter_task(params ,ntrl)
if strcmp(params.trg, 'debug')
    ntrl = params.diff_level;
end
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
x = randperm(length(params.rnum));
params.dist_trl_idx = x(1:ntrl);

if ~isempty(params.bckimTexture)
    
    vbl = Screen('Flip',params.window);
    params.Iti.vbl = vbl;

    iti_trial(params, params.Iti);
    
    for jt = 1:length(params.dist_trl_idx)
        
        Screen('DrawTexture',  params.window, params.bckimTexture);
        
        Screen('TextSize',  params.window, 120);
        DrawFormattedText( params.window, '.',params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
        Screen('TextSize',  params.window, 40);
        DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [.25 .25 .25]);
        DrawFormattedText( params.window, params.distr.odd, params.xCenter-210, params.yCenter+100, [.25 .25 .25]);
        DrawFormattedText( params.window, params.distr.even, params.xCenter+120, params.yCenter+100, [.25 .25 .25]);
        
        Screen('Flip',  params.window);
        
        if strcmp(params.debugmode,'no') ||  strcmp(params.debugmode,'mode2')
            tStart = GetSecs;
            [response,rt(jt)] = get_response(1,tStart,params.btns);
            KbReleaseWait;
            GpWait(params.btns);
            
            %vbl = Screen('Flip',params.window);
            for frame = 1:params.Dis.numFrames(1)
                Screen('DrawTexture',  params.window, params.bckimTexture);
                Screen('TextSize',  params.window, 40);
                DrawFormattedText( params.window, params.distr.odd ,params.xCenter-210, params.yCenter+100, [.25 .25 .25]);
                DrawFormattedText( params.window, params.distr.even ,params.xCenter+120, params.yCenter+100, [.25 .25 .25]);
                Screen('TextSize',  params.window, 120);
                DrawFormattedText( params.window, '.',params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
                    
                if (mod(params.rnum(params.dist_trl_idx(jt)),2)== 1) && (response ==0)                    
                    AC(jt) = 1;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [0 1 0]);                    
                elseif (mod(params.rnum(params.dist_trl_idx(jt)),2)== 1) && (response ==2)
                    AC(jt) = 0;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [1 0 0]);
                elseif (mod(params.rnum(params.dist_trl_idx(jt)),2)== 0) && (response ==2)
                    AC(jt) = 1;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [0 1 0]);
                else
                    AC(jt) = 0;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [1 0 0]);
                end
                
                % Flip to the screen
                vbl = Screen('Flip', params.window, vbl + (params.Dis.waitframes - 0.5) * params.ifi);
            end
        end
        params.Iti.vbl = vbl;
        iti_trial(params, params.Iti);
    end
    
else
    
    vbl = Screen('Flip', params.window);
    params.Iti.vbl = vbl;
    
    iti_trial(params, params.Iti);
        
    for jt = 1:length(params.dist_trl_idx)
        
        Screen('FillRect',params.window, params.bc_color);
        
        Screen('TextSize',  params.window, 120);
        DrawFormattedText( params.window, '.',params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
        
        Screen('TextSize',  params.window, 40);
        DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [.25 .25 .25]);
        DrawFormattedText( params.window, params.distr.odd, params.xCenter-210, params.yCenter+100, [.25 .25 .25]);
        DrawFormattedText( params.window, params.distr.even, params.xCenter+120, params.yCenter+100, [.25 .25 .25]);
        
        Screen('Flip',  params.window);
        
%         if strcmp(params.debugmode,'no') ||  strcmp(params.debugmode,'mode2')
            tStart = GetSecs;
            [response,rt(jt)] = get_response(1,tStart,params.btns);
            KbReleaseWait;
            GpWait(params.btns);
            %vbl = Screen('Flip',params.window);
            for frame = 1:params.Dis.numFrames(1)
                Screen('FillRect',params.window, params.bc_color);
                Screen('TextSize',  params.window, 40);
                DrawFormattedText( params.window, params.distr.odd, params.xCenter-210, params.yCenter+100, [.25 .25 .25]);
                DrawFormattedText( params.window, params.distr.even ,params.xCenter+120, params.yCenter+100, [.25 .25 .25]);
                Screen('TextSize',  params.window, 120);
                DrawFormattedText( params.window, '.', params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
                                
                if (mod(params.rnum(params.dist_trl_idx(jt)),2)== 1) && (response ==0)
                    AC(jt) = 1;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [0 1 0]);
                elseif (mod(params.rnum(params.dist_trl_idx(jt)),2)== 1) && (response ==2)
                    AC(jt) = 0;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [1 0 0]);
                elseif (mod(params.rnum(params.dist_trl_idx(jt)),2)== 0) && (response ==2)
                    AC(jt) = 1;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter, params.yCenter-100 , [0 1 0]);
                else
                    AC(jt) = 0;
                    Screen('TextSize',  params.window, 40);
                    DrawFormattedText( params.window, num2str(params.rnum(params.dist_trl_idx(jt))),params.xCenter,  params.yCenter-100, [1 0 0]);
                end
                
                % Flip to the screen
                vbl = Screen('Flip', params.window, vbl + (params.Dis.waitframes - 0.5) * params.ifi);
            end
%         end
        params.Iti.vbl = vbl;
        iti_trial(params, params.Iti);
    end
end

return
