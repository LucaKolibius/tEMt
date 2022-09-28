function EMexp(params)

try
    %% add folder with m-files to MATLAB path
    addpath([params.basepath,filesep,'mcode',filesep]);
    
    %% Clear the workspace and the screen
    sca;
    close all;
    
    %% setting up Psychtoolbox
    PsychDefaultSetup(2);
    AssertOpenGL;
    LoadPsychHID;
    HideCursor;
    
    %% prep trigger box
    if strcmp(params.trg, 'serial')
        IOPort('CloseALL');
        params.trg_handle = IOPort('OpenSerialPort', 'COM3'); % try out COM3 otherwise, creates trigger handle
        params.trg_data = uint8(1); % value that is being sent
    elseif strcmp(params.trg, 'ttl')
        params.daqID  = DaqDeviceIndex;
        if isempty(params.daqID)
            error('trigger box not connected');
        else
            err = DaqDConfigPort(params.daqID,[],0);
            out_ = DaqDOut(params.daqID,0,0); % reset
        end
    elseif strcmp(params.trg, 'utrecht')
        %Trigger output is at 115200
        params.serial = serial('COM4','BaudRate',115200);
        fopen(params.serial)
    elseif strcmp(params.trg, 'debug')
    end
    
    %% setting up the trial structure and response buttons
    [params] = set_up_stimuli(params,'n');
    
    %% implement non-preferred stimuli
    [params.btns] = SetExpButtons;
    
    %% get screen params
    [params] = get_screen_params(params);
    
    %% Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', params.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    
    %% Retreive the maximum priority number
    params.topPriorityLevel = MaxPriority(params.window);
    
    %% load in break image from file
    [params] = read_bckgrnd_image(params,'n');
    
    %% load in all images fro m file
    [params] = read_stim_images(params);
    
    %% compute corrdinates
    [params] = calculate_coordinates(params);
    params.Yoffs = 0;% controls center of screen offset
    
    % screen coordinates y-axis
    params.Y(1) = params.Yoffs + params.baseRect(end);
    params.Y(2) = params.yCenter+200;
    params.Y(3) = params.yCenter+200;
    
    % screen coordinates x-axis
    params.X(1) = params.xCenter;
    params.X(2) = params.xCenter-500;
    params.X(3) = params.xCenter+300;
    
    %% set initial difficulty level
    if isempty(params.start_idx) % For new sessions. This will be skipped when restarting a crashed session.
        params.start_idx=1;
        params.trl_idx = params.start_idx:(params.start_idx-1)+(params.diff_level);
    end
    
    %% intialize performance loging
    if ~isfield(params, 'c')
        params.c =  0; %params.start_idx-1;
        params.perf = cell(size(params.stim_mat.seq,2),3); % number of all possible trials X 3 retrievals
    else
    end
    
    %% prepare LOGFILE
    if ~strcmp(params.trg, 'debug') % don't need a logfile for debuge mode
        [params] = prepare_EMlogfile(params);
    end
    
    %% create randum numbers for the distractor trial
    rand('state',sum(100*clock));
    params.rnum = randi(99,1000,1);
    params.dist_trl_idx = 0;
    
    %% loop over trials
    %     f1 = 0;
    endExp = 0;
    params.st = GetSecs; % get start time
    
    %% save Exp-parameter file
    if ~strcmp(params.trg, 'debug') % don't need params for debuge mode
        get_clock_time;
        save([params.savep, params.data_ID, '_', date, '_', ct, '_params_initialized.mat'],'params');
    end
    
    %% send the start trigger
    if ~strcmp(params.trg, 'debug')
        send_start_trigger(params);
        send_start_trigger(params);
        send_start_trigger(params);
    end
    
    %% compute the number of frames
    [params.Enc] = compute_numFrames(params,params.Ed);
    [params.Ret] = compute_numFrames(params,params.RetTime);
    [params.Ins] = compute_numFrames(params,2.5);
    [params.Dis] = compute_numFrames(params,.125);
    [params.Iti] = compute_numFrames(params,1);
    [params.Bre] = compute_numFrames(params,5/100);
    [params.End] = compute_numFrames(params,5);
    
    %% testing crash resistance
    disp('params.stim_mat.seq: ');
    disp(params.stim_mat.seq);
    disp('params.trl_idx: ');
    disp(params.trl_idx);
    
    %% start the graphics
    while endExp<1
        %% flag reset until l.212
        % the way flags are used is as follows: in the beginning
        % flag1(encoding( and flag2(retrieval) are reset to 1. Then we run
        % encoding and switch flag1 to "0". Then we run retrieval and
        % switch flag2 to "0". Then we repeat the while loop and switch
        % flag1 and flag2 back to "1".
        if isfield(params,'flag0') && isfield(params,'flag1') && isfield(params,'flag2') && isfield(params,'flag3')
            if ( params.flag0 ~=1 ) && ( params.flag1 ~=1 ) && ( params.flag2 ~=1 ) && ( params.flag3 ~=1 ) % encoding and retrieval block both done! reset flags
                
                params.flag0 = 1;
                params.flag1 = 1;
                params.flag2 = 1;
                params.flag3 = 1;
                
                %% count blocks
                params.c = params.c+1;
                
                %% flag  trl index
                if params.trl_idx(end) >= length(params.stim_mat.seq)
                    params.trl_idx(params.trl_idx>length(params.stim_mat.seq)) = [];
                    endExp = 1;
                end
                
            end
        else % if flag0 to flag3 do not exist yet, create them here.
            params.flag0 = 1;
            params.flag1 = 1;
            params.flag2 = 1;
            params.flag3 = 1;
            
            %% count blocks
            params.c = params.c+1;
            
            %% make sure we dont have more trials than stimuli
            if params.trl_idx(end) >= length(params.stim_mat.seq)
                params.trl_idx(params.trl_idx>length(params.stim_mat.seq)) = [];
                endExp = 1;
            end
            
        end
        
        %%
        if params.flag0 == 1
            %% Instructions Encoding
            if params.c == 1
                instructions1(params);
            end
            
            if ~strcmp(params.trg, 'debug') % don't need a logfile for debuge mode
                write_output2log(params,['ENC',num2str(params.c)]);
            end
            
            %% Encoding task
            [params] = run_encoding(params);
            
            %% Instruction distractor task
            % odd/even number judgement
            if params.c ==1
                instructions2(params);
            end
            
            %% Distractor task
            [~ ,~] = distracter_task(params, 15);
            
        end
        
        %% RETRIEVAL #1
        if params.flag1 ==1
            %% Instruction Retrieval task
            if params.c ==1
                instructions3(params);
            end
            
            if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
                write_output2log(params,['RET1-B',num2str(params.c)]);
            end
            
            %% Retrieval task
            retBlock = 1;
            [params] = run_retrieval(params, retBlock);
            params.flag1 = 0; % previously within run_retrieval
            
            Priority(0);
            
            disp('Retrieval 1')
            disp('params.stim_mat.seq: ');
            disp(params.stim_mat.seq);
            disp('params.trl_idx: ');
            disp(params.trl_idx);
            
            %% Distractor task
            [~ ,~] = distracter_task(params, 15);
        end
        
        %% RETRIEVAL #2
        if params.flag2 == 1
            if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
                write_output2log(params,['RET2-B',num2str(params.c)]);
            end
            
            %% Retrieval task
            retBlock = 2;
            [params] = run_retrieval(params, retBlock);
            params.flag2 = 0;
            Priority(0);
            
            disp('Retrieval 2')
            disp('params.stim_mat.seq: ');
            disp(params.stim_mat.seq);
            disp('params.trl_idx: ');
            disp(params.trl_idx);
            
            %% Distractor task
            [~ ,~] = distracter_task(params, 15);
            
        end
        
        %% RETRIEVAL #3
        if params.flag3 == 1
            if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
                write_output2log(params,['RET3-B',num2str(params.c)]);
            end
            
            %% Retrieval task
            
            retBlock = 3;
            [params] = run_retrieval(params, retBlock);
            params.flag3 = 0;
            Priority(0);
            
            disp('Retrieval 3')
            disp('params.stim_mat.seq: ');
            disp(params.stim_mat.seq);
            disp('params.trl_idx: ');
            disp(params.trl_idx);
            
            %% Distractor task
            [~ ,~] = distracter_task(params, 15);
            
        end
        
        %% adaptive task-difficulty
        a = zeros(length(params.trl_idx),3);
        for trlIdx = 1:length(params.trl_idx)
            for rep = 1:3
                a(trlIdx,rep) = params.perf{params.trl_idx(trlIdx),rep}.H; % 1 and 0?
            end
        end
        
        % at this point 'a' corresponds with the last retrieval order and not
        % the encoding order. But it doesn't matter.
        a = nansum(a(:))/length(a(:)); % take the overall mean memory performance over all trials in the block and all three retrievals
        
        a = (a-1/4)/(1-(1/4));% hit rate corrected for guesses
        if isnan(a)
            error('NaN value in hit rate detected');
        end
        
        if (a >= .95)
            params.diff_level = params.diff_level+5;
        elseif (a >= .75) && (a <.95)
            params.diff_level = params.diff_level+3;
        elseif (a > .65) && (a <.75)
            params.diff_level = params.diff_level+1;
        elseif (a >= .55) && (a <=.65)
            params.diff_level = params.diff_level;
        elseif (a < .55) && (a > .35)
            params.diff_level = params.diff_level-1;
        elseif (a <= .35) && (a > .15)
            params.diff_level = params.diff_level-3;
        elseif a <= .15
            params.diff_level = params.diff_level-5;
        end
        
        if params.diff_level <=4; params.diff_level =4;end
        %if params.diff_level >=24; params.diff_level =24;end;
        
        %% 31.05.22 how many trials have we done?
        doneTrl = params.trl_idx(end);
        
        % update difficulty
        params.trl_idx = max(params.trl_idx)+1 : max(params.trl_idx)+(params.diff_level); %increments by difficulty. In tEMt I have to use max(). In the previous version (end) was used. However, here we keep the scrambled trial index of retrieval for crash resistance in the params file. Previously that retrieval trial index did not leave the function.
        
        % save parameter
        % otherwise when crashing after a retrieval trial and before an
        % encoding trial the trl_idx from the previous retrieval session is
        % used for the next encoding block
        if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
            get_clock_time;
            save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params')%  .. and this is is my crash insurance
        end
        
        %% measure time of exp
        % NEW: THIS WILL TAKE INTO CONSIDERATIONS PATIENTS THAT HAVE A LOT OF
        % MEMORY TRIALS, WHICH LEADS TO SUPER LONG TUNING PARTS AFTER THE 30MIN
        % MEMORY PART
        st = GetSecs;
        d = (st-params.st)/60; % how many minutes have passed since the initial session start? this will lead to problems if taking longer breaks between sessions. in this case a new session should be initiated anyway (but do visual tuning before!!)
        
        tPer = 1.91; % time in seconds per image
        estTunTime = doneTrl * 2 * tPer * 6 / 60; % how many trials, each trial has 2 images, how long each image takes, how many time each image is shown
        estTotTime = estTunTime + d;
        
        if d > params.expDur % set to 30mins
            endExp = 1;
        elseif estTotTime > params.expDur + 15 % 45 min total with CN
            endExp = 1;
        end
        
        % OLD
        % %         if d > params.expDur % set to 30mins
        % %             endExp = 1;
        % %         end
        
        %% break trial
        if endExp ~=1
            if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
                write_output2log(params,['BreakBeg',num2str(params.c),'\t',num2str(GetSecs)]);
            end
            
            wait_barEM(params);
            
            if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
                write_output2log(params,['BreakEnd',num2str(params.c),'\t',num2str(GetSecs)]);
            end
        end
        
    end
    
    %%  save the set of final parameters
    get_clock_time;
    
    if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
        save([params.savep, params.data_ID, '_', date, '_', ct, '_params_completed.mat'],'params');
        
        delete([params.savep, params.data_ID, '*_params_aborted.mat']) % DELETE ALL ABORTED PARAMETER FILES
    end
    
    %% END
    end_of_task(params);
    
    %% Clear the screen and the memory
    sca;
    close all;
    
    if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
        fclose(params.fid);
    end
    
    
    return;
    
    
catch er
    
    fprintf(2,'There was an error in line %s! The message was:\n%s', num2str([er.stack.line]), er.message);
    
    %% save the set of final parameters
    if ~strcmp(params.trg, 'debug') % don't need to sebd crash trigger in debuge mode
        get_clock_time;
        save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted2.mat'],'params');
        
        send_crashTrig(params);
    end
    
    sca;% Clear the screen
    close all;
    psychrethrow(psychlasterror)
    fclose(params.fid);
    error('program aborted');
    
end
end