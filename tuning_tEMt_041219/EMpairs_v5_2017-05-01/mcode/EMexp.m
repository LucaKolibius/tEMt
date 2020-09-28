function EMexp(params)

%% DOC
% 21/06/2016 - FRO: fixed bug in the readout of the random numbers in distractor task
%            - FRO: add nanmedian to adaptive measurement of performance to
%            avoid NaN-related error
%27/06/2026 - FRO: fixed bug in random number readout for distractor task
%28/06/2016 - FRO: fixed NaN values in response output
%04/07/2016 - FRO: fixed bug in response output
%05/07/2016 - FRO: fixed bug in response output
%06/07/2016 - FRO: fixed bug in how foils get selected
%06/07/2016 - FRO: fixed bug in distractor number sequence
%27/04/2017 - FRO: code revision, fixed minor bugs
%28/04/2017 - FRO: code revision, fixed minor bugs
%29/04/2017 - FRO: code revision, fixed minor bugs
%30/04/2017 - FRO: code revision, fixed minor bugs
%01/05/2017 - FRO: code revision, fixed minor bugs
%02/05/2017 - FRO: code revision, added some changes to the concept-neuron pair assignments, fixed minor bugs
%03/05/2017 - FRO: code revision, changed the priority settings during
                   %encoding and retrieval
%03/06/2017 - FRO: added flags if crash happens during task to start again
                   %from either encoding or retrieval
                   %also changed the way hit rate is computed as there was
                   %a bug in how the hit rate was calculated because of
                   % a change introduced previously
                   
%24/09/2017 - FRO: made coordinates relative to screen resolution (calculate_coordinates.m & compute_target_position)

%% START
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
    params.daqID  = DaqDeviceIndex;
    if isempty(params.daqID)
        if strcmp(params.debugmode,'no')
            error('trigger box not connected');
        end;
    else
        err = DaqDConfigPort(params.daqID,[],0);        
        out_ = DaqDOut(params.daqID,0,0); % reset
    end;
    %PTBdebug;
    
    %% setting up the trial structure and response buttons
    [params] = set_up_stimuli(params,'n');
    %PTBdebug;
        
    %% setup the response buttons
    [params.btns] = SetExpButtons;
    %PTBdebug;
    
    %% get screen params
    [params] = get_screen_params(params);    
    %PTBdebug;
    
    %% Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', params.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %PTBdebug;
    
    %% Retreive the maximum priority number
    params.topPriorityLevel = MaxPriority(params.window);
    %PTBdebug;
    
    %% load in background image from file
    [params] = read_bckgrnd_image(params,'n');
    %PTBdebug;
    
    %% load in all images fro m file
    [params] = read_stim_images(params);
    %PTBdebug;

    %% compute corrdinates
    [params] = calculate_coordinates(params);
    
    params.Yoffs = 0;% controls center of screen offset
    
    % screen coordinates y-axis
    params.Y(1) = params.Yoffs + params.baseRect(end);
    params.Y(2) = params.yCenter+params.yoff*2;
    params.Y(3) = params.yCenter+params.yoff*2;
    
    % screen coordinates x-axis
    params.X(1) = params.xCenter;
    params.X(2) = params.xCenter-params.xoff*1.6;%should be 500
    params.X(3) = params.xCenter+params.xoff*1.6;% should be 300?

    %% set initial difficulty level
    if isempty(params.start_idx)
        params.start_idx=1;
    end;
    params.trl_idx = params.start_idx:(params.start_idx-1)+(params.diff_level);
    %PTBdebug;
    
    %% intialize performance loging
    params.c =  0;%params.start_idx-1;
    params.perf = cell(size(params.stim_mat.seq,2),1);
    
    %% prepare LOGFILE
    [params] = prepare_EMlogfile(params);
    %PTBdebug;
    
    %% create randum numbers for the distractor trial
    rand('state',sum(100*clock));
    params.rnum = randi(99,1000,1);
    params.dist_trl_idx = 0;
    
    %% loop over trials
    f1 = 0;
    f2 = 0;
    params.st = GetSecs;% get start time
    %PTBdebug;
    
    %% save Exp-parameter file
    get_clock_time;
    save ([params.savep,params.data_ID,'_',date,'_',ct,'_params_initialized.mat'],'params');
    
    %% send the start trigger
    if isfield(params,'daqID')
        send_start_trigger(params);
        send_start_trigger(params);
        send_start_trigger(params);
    end;
    %PTBdebug;
    
    %% compute the number of frames
    [params_Enc] = compute_numFrames(params,params.Ed);
    [params_Ret] = compute_numFrames(params,params.Ret);
    [params_Ins] = compute_numFrames(params,2.5);
    [params_Dis] = compute_numFrames(params,.125);
    [params_Iti] = compute_numFrames(params,1);
    [params_Bre] = compute_numFrames(params,5/100);
    [params_End] = compute_numFrames(params,5);
    %PTBdebug;

    %% start the graphics    
    while f2<1
                
        %% flag reset
        if isfield(params,'flag1') && isfield(params,'flag2')
            if ( params.flag1 ~=1 ) && ( params.flag2 ~=1 )
                
                params.flag1 = 1;
                params.flag2 = 1;
                
                %% count blocks
                params_Enc.c = params_Enc.c+1;%
                %PTBdebug;
                
                %% flag  trl index
                if params.trl_idx(end) >= length(params.stim_mat.seq)
                    params.trl_idx(find(params.trl_idx>length(params.stim_mat.seq))) = [];
                    f1 = 1;
                end;
                %PTBdebug;
                
            end;
        else
            params.flag1 = 1;
            params.flag2 = 1;
            
            %% count blocks
            params_Enc.c = params_Enc.c+1;%
            %PTBdebug;
            
            %% flag  trl index
            if params.trl_idx(end) >= length(params.stim_mat.seq)
                params.trl_idx(find(params.trl_idx>length(params.stim_mat.seq))) = [];
                f1 = 1;
            end;
            %PTBdebug;
            
        end;
                        
        %%
        if params.flag1 ==1
            %% Instructions Encoding
            if params_Enc.c ==1
                instructions1(params_Ins);
            end;
            write_output2log(params,['ENC',num2str(params.c)]);
            %PTBdebug;
            
            %% Encoding task
            [params_Enc] = run_encoding(params_Enc,params_Iti,params.trl_idx);
            params.flag1 = 0;
            %PTBdebug;
            
            %% Instruction distractor task
            %odd/even number judgement
            if params_Enc.c ==1
                instructions2(params_Ins);
            end;
            %PTBdebug;
            
            %% Distractor task
            [~ ,~] = distracter_task(params_Dis,params_Iti,15);
            %PTBdebug;
            
        end;
        
        %%
        if params.flag2 ==1
            %% Instruction Retrieval task
            if params_Enc.c ==1
                instructions3(params_Ins);
            end;
            write_output2log(params,['RET',num2str(params.c)]);
            %PTBdebug;
            
            %% Retrieval task
            [params_Ret] = run_retrieval(params_Ret,params_Iti,params.trl_idx);
            Priority(0);
            params.flag2 = 0;
            %PTBdebug;
        end;
        
        %% adaptive task-difficulty
        a = zeros(1,length(params.trl_idx));
        for kt = 1:length(params.trl_idx);
            a(kt) =params_Ret.perf{params.trl_idx(kt)}.H;
        end;
        
        a = nansum(a)/length(a);
        
        a = (a-1/4)/(1-(1/4));% hit rate corrected for guesses
        if isnan(a)
            error('NaN value in hit rate detected');
        end;
        %PTBdebug;
                
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
        end;
          
        if params.diff_level <=4; params.diff_level =4;end;
        %if params.diff_level >=24; params.diff_level =24;end;
        
        % update difficulty
        params.trl_idx = params.trl_idx(end) + 1:params.trl_idx(end) + (params.diff_level);%increments by difficulty
        
        % abort if trl index is out of range
        if (params.trl_idx(end) >= length(params.stim_mat.seq)) && (f1 == 1);
            f2 =1;
        end;
        
        %% break trial    
        if f2 ~=1
            write_output2log(params,['BreakBeg',num2str(params_Enc.c),'\t',num2str(GetSecs)]);                
            wait_barEM(params_Bre,'Block completed. Take a short break ...');
            write_output2log(params,['BreakEnd',num2str(params_Enc.c),'\t',num2str(GetSecs)]);
        end;
        %PTBdebug;
        
        %% measure time of exp
        st = GetSecs;
        d = (st-params.st)/60;
        if d >40
             f2 =1;
        end;

    end;    
    
    %%  save the set of final parameters
    get_clock_time;
    save([params.savep,params.data_ID,'_',date,'_',ct,'_params_completed.mat'],'params');

    %% END    
    end_of_task(params_End);
    %PTBdebug;
    
    %% Clear the screen and the memory
    sca;
    close all;
    fclose(params.fid);
    return;
    
catch
    
    %% save the set of final parameters
    get_clock_time;
    save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params');
    sca;% Clear the screen
    close all;
    fclose(params.fid);   
    psychrethrow(psychlasterror)
    error('program aborted');
    
end;