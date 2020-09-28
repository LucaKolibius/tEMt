
function test_code_encoding_and_retrieval(params)
%% default params
if nargin ==0
    params.sel_idx = [];
    params.initial_diff_level = 4;
    params.p2f = [filesep,'home',filesep,'rouxf',filesep,'Exp_EM',filesep];
    params.concept_neurons = {'gstq','bb'};
    params.data_ID = 'debug';
    params.Ed = [2 5];
    params.Ret = 1;
end;
%%
try
    %% add folder with m-files to MATLAB path
    addpath('/home/rouxf/MATLAB/EMexp/');
    %% Clear the workspace and the screen
    sca;
    close all;
    %% setting up Psychtoolbox
    PsychDefaultSetup(2);
    AssertOpenGL;
    LoadPsychHID;
    %% setting up the trial structure and response buttons
    [params] = set_up_stimuli(params,'y'); 
%% !%%%%%%%%% implement non-preferred stimuli
    [params.btns] = SetExpButtons;
    %% get screen params
    [params] = get_screen_params(params);
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', params.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %% Retreive the maximum priority number
    params.topPriorityLevel = MaxPriority(params.window);    
    %% load in background image from file
    [params] = read_bckgrnd_image(params); 
    %% load in all images from file
    [params] = read_stim_images(params);    
    %% compute corrdinates
    [params] = calculate_coordinates(params);
    %% set initial difficulty level
    if isempty(params.sel_idx)
        params.sel_idx=1;
    end;
    params.trl_idx = params.sel_idx:params.initial_diff_level;
    params.diff_level = params.initial_diff_level;
    %% intialize performance loging
    params.c = 0;
    params.perf = cell(size(params.stim_mat.seq,2),1);
    %% prepare logfile
    [params] = prepare_EMlogfile(params);  
    %% create randum numbers for the distractor trial
    params.rnum = randi(99,length(params.stim_mat.seq),1);
    %% loop over trials
    f1 =0;
    f2 =0;
    params.st = GetSecs;% get start time
    while f2<1
        %% flag trl index
        if params.trl_idx(end) >= length(params.stim_mat.seq)
            params.trl_idx(find(params.trl_idx>length(params.stim_mat.seq))) = [];
            f1 = 1;
        end;   
        %% debugger
        %PTBdebug;
        %% Encoding task
        [ot1] = run_encoding(params,params.trl_idx);   
        wait_barEM(params,5,'Task completed. Take a short break ...');
        %% Blank sceen
        iti_trial(params);
        %% distractor task
        %odd/even number judgement
        [~,~] = distracter_task(params,params.trl_idx);
        wait_barEM(params,5,'Task completed. Take a short break ...');
        %% Retrieval task
        params.c = params.c+1;
        [CM,ot2,params.RT] = run_retrieval(params,params.trl_idx);
        wait_barEM(params,5,'Task completed. Take a short break ...');
        %% compute accuracy
        [params.perf{params.c}] = compute_accuracy(CM);       
        %% log response to txt file 
        write_output2log(params.fid,params,[ot1;ot2]);        
        %% update difficulty
        params.trl_idx = params.trl_idx + params.diff_level;%increments by diiculty
        %% implement staircase: eg start with x and then increase/ decrease with
        % each block completed        
        %% abort if trl index is out of range
        if (params.trl_idx(end) >= length(params.stim_mat.seq)) && (f1 == 1);
            f2 =1;
        end;
        PTBdebug;
    end;
    %% END
    % Clear the screen
    sca;
    close all;
    fclose(fid);
    clear all;
    return;
catch
    sca;% Clear the screen
    error('program aborted');
end;