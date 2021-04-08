function [params] = run_retrieval(params)
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
    vbl = Screen('Flip',params.window);
    params.Ret.vbl = vbl;
    
    %%
%     c = 0 ;
    params.CM = zeros(length(params.trl_idx),2);
    params.ot = cell(1,4);
    
    %% randomize order of pair-presentation during retrieval
    %
    % if strcmp(params.rep, 'y') && params.stopPerm == 1 % avoid permutating trl_idx twice after a crash
    %     params.stopPerm = 0;
    %     disp('Successfully stopped repeated retrieval trial permutation');
    % else
    %     params.trl_idx = params.trl_idx(randperm(length(params.trl_idx)));
    % end
    
    if params.permRet == 0 % already shuffled, don't do anything
    elseif params.permRet == 1 % order needs to be shuffled from encoding
        params.trl_idx = params.trl_idx(randperm(length(params.trl_idx)));
        params.permRet = 0;
    end
    %% start with ITI
    iti_trial(params, params.Ret);
    
    %% get the indices for the foils
    % [foil_idx] = get_foil_indices2(trl_idx); % this takes the two targets from a trial within that block and uses them as a distractor. foil_idx is an index vector that is the permutated trl_idx.
    foil_idx = get_foil_indices_tEMt(params); % this function gives you the index of the distractor images (not of the trials whose images will be used as a distractor!)
    
    %% loop over the number of encoded pairs
    for retTrl = params.retTrl : length(params.trl_idx) % this...
        
        % saving params
        params.retTrl = retTrl;
        get_clock_time;
        
        if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
            save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params')%  .. and this is is my crash insurance
        end
        %% just a counter
%         c=c+1;
         
        %% prepare the cue
        CueTexture = Screen('MakeTexture', params.window, params.theImage{params.stim_mat.idx(params.stim_mat.seq(1,params.trl_idx(retTrl)))});% the cue to the orig pair
        
        %% prepare the target
        %the orig pair
        OrigTexture(1) = Screen('MakeTexture', params.window, params.theImage{params.stim_mat.idx(params.stim_mat.seq(2,params.trl_idx(retTrl)))});% % theImage contains the pixels for all images. here we take out the associate image
        %     OrigTexture(2) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(3,trl_idx(jt)))});%we take out the second associate stimulus, because in tEMt we do not present one
        params.ret_id = [params.Imf(params.stim_mat.idx(params.stim_mat.seq(1,params.trl_idx(retTrl)))).name,'\t',params.Imf(params.stim_mat.idx(params.stim_mat.seq(2,params.trl_idx(retTrl)))).name]; % names of the cue and associate
        
        %% prepare the foils
        FoilTexture = zeros(length(foil_idx(retTrl)),3);
        for kt = 1:length(foil_idx(retTrl)) % why is this a loop?
            FoilTexture(kt,1) = Screen('MakeTexture', params.window, params.theImage{foil_idx(1,params.trl_idx(retTrl))});
            FoilTexture(kt,2) = Screen('MakeTexture', params.window, params.theImage{foil_idx(2,params.trl_idx(retTrl))});
            FoilTexture(kt,3) = Screen('MakeTexture', params.window, params.theImage{foil_idx(3,params.trl_idx(retTrl))});
        end
        FoilTexture = FoilTexture(:);
        
        %% flip coin
        oidx =[];
        fc = randperm(length(FoilTexture)+length(OrigTexture)); % we have four stimuli. fc is a random permutation of 1:4
        oidx(1) = find(fc==1); % on which position is value 1?
        %     oidx(2) = find(fc==2); % on which position is value 2?
        
        params.CM(retTrl,1) = oidx; % correct response
        
        fidx = [];
        fidx = setdiff(1:length(fc),oidx); % on which position are number 3 and 4 (remaining images)?
        fidx = fidx(randperm(length(fidx)));
        
        %% send out trigger
%         if ~strcmp(params.trg, 'debug')
%             send_ttl(params,params.rettrig); [params.ot(1)] = {num2str(GetSecs)}; % onset of cue - raise pin
%         else
            [params.ot(1)] = {num2str(GetSecs)};
%         end
        
        %% Draw the background image
        if ~isempty(params.bckimTexture)
            %         Priority(params1.topPriorityLevel);
            %         for frame = 1:params1.numFrames(1)
            %
            %             Screen('DrawTexture', params1.window,params1.bckimTexture);
            %             %% Draw the Cue image
            %             % Make texture
            %             Screen('DrawTexture', params1.window, CueTexture(1),[],  params1.centeredRectC, 0);
            %             Screen('TextSize',  params1.window, 120);
            %             DrawFormattedText( params1.window, '.', params1.xCenter+1,  params1.yCenter+params1.Yoffs, [1 0 0]);
            %
            %             % Flip to the screen
            %             vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            %
            %         end
            %         Priority(0);
        else
            Priority(params.topPriorityLevel);
            cStart = zeros(1,params.Ret.numFrames(1));
            for frame = 1:params.Ret.numFrames(1)
                
                Screen('FillRect',params.window, params.bc_color);
                %% Draw the Cue image
                % Make texture
                Screen('DrawTexture', params.window, CueTexture(1),[],  params.centeredRectC, 0);
                Screen('TextSize',  params.window, 120);
                %             DrawFormattedText( params1.window, '.', params1.xCenter+1,  params1.yCenter+params1.Yoffs, [1 0 0]);
                
                % Flip to the screen
                vbl = Screen('Flip', params.window, vbl+ (params.Ret.waitframes - 0.5) * params.ifi);
                cStart(frame) = vbl;
            end
            Priority(0);
        end
        
%         if strcmp(params.trg, 'ttl')
%             send_ttl(params,0); % lower the pin
%         end
        
        %% Draw text: Do you remember?
        %     [params1.ot(2)] = {num2str(GetSecs)};
        if ~isempty(params.bckimTexture)
            Screen('DrawTexture',  params.window, params.bckimTexture);
        else
            Screen('FillRect',params.window, params.bc_color);
        end
        
        Screen('DrawTexture',  params.window,  CueTexture(1),[],   params.centeredRectC, 0);
        Screen('TextSize',  params.window, 40);
        DrawFormattedText( params.window, params.retrieval.a, 'center',  params.screenYpixels * 0.25, [.25 .25 .25]);
        DrawFormattedText( params.window, params.retrieval.b, 'center',  params.screenYpixels * 0.30, [.25 .25 .25]);
        Screen('TextSize',  params.window, 120);
        %     DrawFormattedText( params1.window, '.', params1.xCenter+1,  params1.yCenter+params1.Yoffs, [1 0 0]);
        qFlip = Screen('Flip',  params.window);
        
        %%
        %     if strcmp(params.debugmode,'no') || strcmp(params.debugmode,'mode2')
        
        %         tStart1 = GetSecs;
        [response1,rt] = get_response(1,cStart(1), params.btns); % response1 is 0 for left, 1 for down, 2 for right
        if isfield(params.btns,'gamepadIndex') % if the gamepad is connected
            response1 = response1-4;
        end
        while ~ismember(response1,[0 2]) % continue to wait for response if something other than an arrow key was pressed
            %             tStart2 = GetSecs;
            [response1,rt] = get_response(1,cStart(1), params.btns);
            if isfield(params.btns,'gamepadIndex')
                response1 = response1-4;
            end
        end
        KbReleaseWait;
        GpWait(params.btns);
        params.RT = rt;
        
        %% Draw the targets + distractors
        final_pos =[];
        tarFoil = NaN;
        
        % if indicating remembering
        if ismember(response1, 2)
            
            % make the background
            if ~isempty(params.bckimTexture)
                Screen('DrawTexture',  params.window, params.bckimTexture);
            else
                Screen('FillRect',params.window, params.bc_color);
            end
            
            %             % make the cue
            %             Screen('DrawTexture',  params1.window,  CueTexture(1),[],   params1.centeredRectC, 0);
            
            %%  Draw the Target
            for kt = 1:length(oidx)
                Screen('DrawTexture',  params.window,  OrigTexture,[],   params.centeredRectT(oidx,:), 0);
            end
            
            %%  Draw the Foils
            for kt = 1:length(fidx)
                Screen('DrawTexture',  params.window, FoilTexture(kt),[],   params.centeredRectT(fidx(kt),:), 0);
            end
            Screen('TextSize',  params.window, 120);
            DrawFormattedText( params.window, '.', params.xCenter+1,  params.yCenter+params.Yoffs, [1 0 0]);
            
            % Flip to the screen
            tarFoil = Screen('Flip',  params.window);
            
            %% make a screenshot
            imageArray = Screen('GetImage',  params.window,  params.windowRect);
            imageArray = Screen('MakeTexture', params.window, imageArray);
            
            %%
            Screen('DrawTexture',  params.window,  imageArray, [],  params.windowRect, 0);
            Screen('FrameRect',  params.window , [0 0 0],  params.centeredRectT(fidx(1),:), 5);
            Screen('TextSize',  params.window, 120);
            DrawFormattedText( params.window, '.', params.xCenter+1,  params.yCenter+params.Yoffs, [1 0 0]);
            
            % Flip to the screen
            Screen('Flip',  params.window);
            
            %%
            %             tStart3 = GetSecs;
            [response2,rt2] = get_response(1,tarFoil, params.btns);
            KbReleaseWait;
            GpWait(params.btns);
            
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
                        end
                    elseif response2 ==1% move down
                        if pos ==1 || pos ==2
                            pos = pos+2;
                        else
                            pos = pos-2;
                        end
                    elseif response2 ==2% move right
                        if pos ==1 || pos ==3
                            pos = pos+1;
                        else
                            pos = pos-1;
                        end
                    elseif response2 ==3% move up
                        if pos ==3 || pos ==4
                            pos = pos-2;
                        else
                            pos = pos+2;
                        end
                    end
                    
                    Screen('DrawTexture', params.window, imageArray, [], params.windowRect, 0);
                    Screen('FrameRect', params.window ,[0 0 0], params.centeredRectT(pos,:), 5);
                    Screen('TextSize',  params.window, 120);
                    DrawFormattedText( params.window, '.', params.xCenter+1,  params.yCenter+params.Yoffs, [1 0 0]);
                    Screen('Flip', params.window);
                    
                    %% if the patient just moved to select another image, get the next response. dont reset rt.
                    %                     tStart4 = GetSecs;
                    [response2,rt2] = get_response(1,tarFoil,params.btns);
                    KbReleaseWait;
                    GpWait(params.btns);
                    
                end
                
                if response2 > 3 % when chosing an image
                    %%
                    response2 = -1; % WHY??
                    final_pos = [final_pos pos];
                    params.RT = [params.RT rt2];
                    
                    %% show the selection frame
                    Screen('DrawTexture', params.window,imageArray, [], params.windowRect, 0);
                    Screen('FrameRect', params.window ,[.9 .75 0], params.centeredRectT(pos,:), 5);
                    Screen('TextSize',  params.window, 120);
                    DrawFormattedText( params.window, '.', params.xCenter+1,  params.yCenter+params.Yoffs, [1 0 0]);
                    Screen('Flip', params.window);
                    
                    %%
                    %                     if length(final_pos)>1
                    %params1.CM(jt,:) = [final_pos oidx];
                    params.CM(retTrl,2) = [final_pos]; % actual response
                    Screen('Close', CueTexture(:));
                    Screen('Close', imageArray);
                    Screen('Close', OrigTexture(:));
                    Screen('Close', FoilTexture(:));
                    break; % why use the f as a gatekeeper at all??
                    %                     end;
                end
                
            end
            
            [params.perf{params.trl_idx(retTrl)}] = compute_accuracy(params.CM(retTrl,:)); % writes 1 for a hit, 0 for miss
            
        elseif response1 == 0 % if indicating patient does NOT remember
            [params.perf{params.trl_idx(retTrl)}] = compute_accuracy(zeros(1,2));
            params.RT = [params.RT 1e6];%add 2x NaNs because of the missing RTs
        end
        %     end
        %%
        if isnan(tarFoil)
            rt2 = NaN;
        end
        [params.ot(2)] = {num2str(cStart(1))};                       % first frame of the cue flip. this should be very close to ot(1) which is being sent right before that and at the same time as the trigger
        [params.ot(3)] = {num2str(qFlip)};                           % when questions comes up ~2s after cue
        [params.ot(4)] = {num2str(tarFoil)};                         % when showing the stimuli (targets and foils)
        [params.ot(5)] = {num2str(tarFoil + rt2)};                   % when responding to matrix of target/distractors
        [out] = create_retrieval_output(params, params.trl_idx(retTrl));  % c is a counter for trials within that block

        if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
            write_output2log(params,out);
        end
        %% ITI
        iti_trial(params, params.Ret);
        
    end
    params.retTrl = 1;
    params.flag2 = 0;
    params.permRet = 1; % for the next retrieval block, permutate trial order again!
    get_clock_time;
    
    if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
        save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params')
    end
end % end of function
