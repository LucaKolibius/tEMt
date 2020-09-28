function [params1] = run_retrieval(params1,params2,trl_idx)
%% intialize
%To Do: -measure the reaction time of the first button press
%22/06/16 - FRO: fixed the selection of the foils by balancing faces and
%                places and by including a distance constraint of 15 trials for foils
%28/06/16 -FRO: fixed bug in how RTs for second response are measured and
%added RT for the first button press.
%01/07/16 -FRO: fixed bug related to number of frames that was reset and
%changed duration parameter
%04/07/16 - FRO: fixed bug related to missing Accuracy values when participants do skip
%retrieval
%05/07/16 - FRO: fixed bug related to missing RTs when participants do skip
%retrieval
% 29/04/2017,code revised by FRO

%%
vbl = Screen('Flip',params1.window);
params2.vbl = vbl;

%%
c=0;
params1.CM = zeros(length(trl_idx),4);
params1.ot = cell(1,3);

%% randomize order of pair-presentation during retrieval
trl_idx = trl_idx(randperm(length(trl_idx)));

%% start with ITI
iti_trial(params2);

%% get the indices for the foils
[foil_idx] = get_foil_indices2(trl_idx);% generates two other stimuli

%% loop over the number of encoded pairs
for jt = 1:length(trl_idx)
    
    %% just a counter
    c=c+1;
    
    %% prepare the cue
    CueTexture = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(1,trl_idx(jt)))});% the cue to the orig pair
    
    %% prepare the targets
    %the orig pair
    OrigTexture(1) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(2,trl_idx(jt)))});%
    OrigTexture(2) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(3,trl_idx(jt)))});%
    params1.ret_id = [params1.Imf(params1.stim_mat.idx(params1.stim_mat.seq(1,trl_idx(jt)))).name,'\t',params1.Imf(params1.stim_mat.idx(params1.stim_mat.seq(2,trl_idx(jt)))).name,'\t',params1.Imf(params1.stim_mat.idx(params1.stim_mat.seq(3,trl_idx(jt)))).name];
    
    %% prepare the foils
    %[foil_idx] = get_foil_indices(params1,trl_idx(jt));% generates two other stimuli
    FoilTexture = zeros(length(foil_idx(jt)),2);
    for kt = 1:length(foil_idx(jt))
        FoilTexture(kt,1) = Screen('MakeTexture',params1. window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(2,foil_idx(jt)))});
        FoilTexture(kt,2) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(3,foil_idx(jt)))});
        %changed 09/07/2016
        %FoilTexture(kt,1) = Screen('MakeTexture',params1. window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(2,foil_idx2(kt,1)))});
        %FoilTexture(kt,2) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(3,foil_idx2(kt,2)))});
    end;
    FoilTexture = FoilTexture(:);
    
    %% flip coin
    oidx =[];
    fc = randperm(length(FoilTexture)+length(OrigTexture));
    oidx(1) = find(fc==1);
    oidx(2) =find(fc==2);
    
    params1.CM(jt,3:4) = oidx;
    
    fidx = [];
    fidx = setdiff(1:length(fc),oidx);
    fidx = fidx(randperm(length(fidx)));
    
    %% Draw the background image
    [params1.ot(1)] = {num2str(GetSecs)};
    send_ttl(params1,params1.rettrig);%onset of cue - raise pin
    if ~isempty(params1.bckimTexture)
        Priority(params1.topPriorityLevel);
        for frame = 1:params1.numFrames(1)
            
            Screen('DrawTexture', params1.window,params1.bckimTexture);
            %% Draw the Cue image
            % Make texture
            Screen('DrawTexture', params1.window, CueTexture(1),[],  params1.centeredRectC, 0);
            Screen('TextSize',  params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            
        end;
        Priority(0);
    else
        Priority(params1.topPriorityLevel);
        for frame = 1:params1.numFrames(1)
            
            Screen('FillRect',params1.window, params1.bc_color);
            %% Draw the Cue image
            % Make texture
            Screen('DrawTexture', params1.window, CueTexture(1),[],  params1.centeredRectC, 0);
            Screen('TextSize',  params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            
        end;
        Priority(0);
    end;    
    send_ttl(params1,0);%lower the pin
    
    %% Draw text in the upper portion of the screen with the default font in red
    [params1.ot(2)] = {num2str(GetSecs)};
    if ~isempty(params1.bckimTexture)
        Screen('DrawTexture',  params1.window, params1.bckimTexture);
    else
        Screen('FillRect',params1.window, params1.bc_color);
    end;
    
    Screen('DrawTexture',  params1.window,  CueTexture(1),[],   params1.centeredRectC, 0);
    Screen('TextSize',  params1.window, 40);
    DrawFormattedText( params1.window, 'How many images that belong here do you remember?','center',  params1.screenYpixels * 0.35, [.25 .25 .25]);
    DrawFormattedText( params1.window, '0 (left), 1 (down), 2 (right)', 'center',  params1.screenYpixels * 0.40, [.25 .25 .25]);
    Screen('TextSize',  params1.window, 120);
    DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
    Screen('Flip',  params1.window);
    
    %%
    if strcmp(params1.debugmode,'no') || strcmp(params1.debugmode,'mode2')
        
        tStart1 = GetSecs;
        [response1,rt] = get_response(1,tStart1, params1.btns);
        if isfield(params1.btns,'gamepadIndex')
            response1 = response1-4;
        end;
        while ~ismember(response1,[0:2])
            tStart2 = GetSecs;
            [response1,rt] = get_response(1,tStart2, params1.btns);
            if isfield(params1.btns,'gamepadIndex')
                response1 = response1-4;
            end;
        end;
        KbReleaseWait;
        GpWait(params1.btns);
        
        %% Draw the Cue image
        final_pos =[];
        params1.RT = rt;
        
        if ismember(response1,[1 2])
    
            if ~isempty(params1.bckimTexture)
                Screen('DrawTexture',  params1.window, params1.bckimTexture);
            else
                Screen('FillRect',params1.window, params1.bc_color);
            end;
            
            Screen('DrawTexture',  params1.window,  CueTexture(1),[],   params1.centeredRectC, 0);
            
            %%  Draw the Targets
            for kt = 1:length(oidx)
                Screen('DrawTexture',  params1.window,  OrigTexture(kt),[],   params1.centeredRectT(oidx(kt),:), 0);
            end;
            
            %%  Draw the Foils
            for kt = 1:length(fidx)
                Screen('DrawTexture',  params1.window, FoilTexture(kt),[],   params1.centeredRectT(fidx(kt),:), 0);
            end;
            Screen('TextSize',  params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            
            % Flip to the screen
            Screen('Flip',  params1.window);
            
            %% make a screenshot
            imageArray = Screen('GetImage',  params1.window,  params1.windowRect);
            imageArray= Screen('MakeTexture', params1.window, imageArray);
            
            %%
            Screen('DrawTexture',  params1.window,  imageArray, [],  params1.windowRect, 0);
            Screen('FrameRect',  params1.window , [0 0 0],  params1.centeredRectT(fidx(1),:), 5);
            Screen('TextSize',  params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            
            % Flip to the screen
            Screen('Flip',  params1.window);
            
            %%
            tStart3 = GetSecs;
            [response2,rt2] = get_response(1,tStart3, params1.btns);
            KbReleaseWait;
            GpWait(params1.btns);
            
            %%
            orig_pos = fidx(1);
            pos = orig_pos;
            f=0;
            
            %%
            while f<1
                if response2 <4
                    if response2 ==0% move left
                        
                        if pos ==2 || pos ==4
                            pos = pos-1;
                        else
                            pos = pos+1;
                        end;
                    elseif response2 ==1% move down
                        if pos ==1 || pos ==2
                            pos = pos+2;
                        else
                            pos = pos-2;
                        end;
                    elseif response2 ==2% move right
                        if pos ==1 || pos ==3
                            pos = pos+1;
                        else
                            pos = pos-1;
                        end;
                    elseif response2 ==3% move up
                        if pos ==3 || pos ==4
                            pos = pos-2;
                        else
                            pos = pos+2;
                        end;
                    end;
                    
                    Screen('DrawTexture', params1.window, imageArray, [], params1.windowRect, 0);
                    Screen('FrameRect', params1.window ,[0 0 0], params1.centeredRectT(pos,:), 5);
                    Screen('TextSize',  params1.window, 120);
                    DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
                    Screen('Flip', params1.window);
                    
                    %%
                    tStart4 = GetSecs;
                    [response2,rt2] = get_response(1,tStart4,params1.btns);
                    KbReleaseWait;
                    GpWait(params1.btns);
                    
                end;
                
                if response2 > 3
                    %%
                    response2 = -1;
                    final_pos = [final_pos pos];
                    params1.RT = [params1.RT rt2];
                    
                    %% show the selection frame
                    Screen('DrawTexture', params1.window,imageArray, [], params1.windowRect, 0);
                    Screen('FrameRect', params1.window ,[.9 .75 0], params1.centeredRectT(pos,:), 5);
                    Screen('TextSize',  params1.window, 120);
                    DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);                    
                    Screen('Flip', params1.window);
                    
                    %%
                    if length(final_pos)>1
                        %params1.CM(jt,:) = [final_pos oidx];
                        params1.CM(jt,1:2) = [final_pos];
                        Screen('Close', CueTexture(:));
                        Screen('Close', imageArray);
                        Screen('Close', OrigTexture(:));
                        Screen('Close', FoilTexture(:));
                        break;
                    end;
                end;
                
            end;
            
            [params1.perf{trl_idx(c)}] = compute_accuracy(params1.CM(jt,:));
            
        elseif response1 == 0
            [params1.perf{trl_idx(c)}] = compute_accuracy(zeros(1,4));
            params1.RT = [params1.RT 1e6 1e6];%add 2x NaNs because of the missing RTs
        end;
    end;
    
    %%
    [params1.ot(3)] = {num2str(GetSecs)};
    [out] = create_retrieval_output(params1,trl_idx(c));
    write_output2log(params1,out);
    
    %% ITI
    iti_trial(params2);
    
end;
