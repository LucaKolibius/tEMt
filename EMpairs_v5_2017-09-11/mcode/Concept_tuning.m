function Concept_tuning(params)

error('Use the code on the tuning path. You are using the code on the EM path.');
%% default params
if nargin ==0
%     params.basepath = 'C:\Experiments\EMpairs_v4_2016-1007';
%     params.p2f = ['C:\Experiments\EMpairs_v4_2016-1007\image_data\Tune\P02\tuning_p02_120716_SE01\'];
%     params.p2log = [params.basepath,filesep,'log',filesep];
%     params.p2params = [params.basepath,filesep,'params',filesep];
%     
%     params.data_ID = 'debug';
%     %params.data_ID = 'P02_TS03_';
%     
%     params.debugmode = 'mode2';
%     %params.debugmode = 'no';
%     
%     params.nreps =6;% number of reps per pic
%     params.resptimeout = 5;% max time given to respond
%     params.start_trl =1;% where to begin 
%     params.iti = [500 750];% duration of inter-trial jitter
%     params.stimd = 1;%duration of pic on screen
%     
%     create_logfile_timestamp;
%     params.fid = fopen([params.basepath,filesep,'log',filesep,'Tuning',filesep,params.data_ID,'_log_ctune_',date,'_',tmstp,'.txt'],'w');
%     params.starttrig = 255;
%     params.basetrig = 30;
%     params.resptrig = 150;
    
end;
%%
try
    %% add folder with m-files to MATLAB path
    addpath([params.basepath,filesep,'mcode',filesep]);
    %PTBdebug;
    
    %% Clear the workspace and the screen
    sca;
    close all;
    
    %% setting up Psychtoolbox
    PsychDefaultSetup(2);
    AssertOpenGL;
    LoadPsychHID;
    HideCursor;
    
    %% prep trigger box
    if strcmp(params.debugmode,'no')
        
        params.daqID  = DaqDeviceIndex;
        err = DaqDConfigPort(params.daqID,[],0);        
        out_ = DaqDOut(params.daqID,0,0); % reset

        send_start_trigger(params);
        send_start_trigger(params);
        send_start_trigger(params);
    end;
    %PTBdebug;
    
    %% see if there are any uncompleted tunings
    chck = dir([params.p2f,filesep,'params',filesep,params.data_ID,'_tuning_params_',params.date,'_',params.tmstp,'.mat']);
    if ~isempty(chck)
        load([params.p2f,filesep,'params',filesep,params.data_ID,'_tuning_params_',params.date,'_',params.tmstp,'.mat'],'params');
    else
        %% setting up the trial structure and response buttons
        [params] = set_up_concept_tuning(params,'n'); 
    end;
    %PTBdebug;
    
    %% setup reponse buttons
    [params.btns] = SetExpButtons;    
    %PTBdebug;
    
    %% get screen params
    [params] = get_screen_params(params);
    
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('Preference', 'VBLTimestampingMode', 2);
    Screen('BlendFunction', params.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %PTBdebug;
    
    params.Yoffs = 0;% controls center of screen offset
    
    %% Retreive the maximum priority number
    params.topPriorityLevel = MaxPriority(params.window);    
    %PTBdebug;
    
    %% load in background image from file
    [params] = read_bckgrnd_image(params,'n'); 
    %PTBdebug;
    
    %% load in all images from file
    [params] = read_stim_images(params);
    %PTBdebug;

    for it = 1:length(params.ID)
        x = params.ID{it};
        x(regexp(x,' ')) = [];%make sure there are no white-spaces
        x(regexp(x,',')) = [];%make sure there are no white-spaces
        params.ID{it} = x;
        x = params.Imf(it).name;
        x(regexp(x,' ')) = [];
        x(regexp(x,',')) = [];
        params.Imf(it).name = x;
    end;
    %PTBdebug;
    
    %% compute corrdinates
    [params] = calculate_coordinates_tuning(params);    
    %PTBdebug;

    %%
    params.idx = 1:length(params.Imf);%number of trials per rep, equals number of input images    
    %PTBdebug;
        
    %% some more display settings     
    %compute the number of frames
    [params] = compute_numFrames(params,params.stimd);
    
    % screen coordinates y-axis
    params.Y(1) = params.Yoffs + params.baseRect(end);
    params.Y(2) = params.yCenter+200;
    params.Y(3) = params.yCenter+200;
    
    % screen coordinates x-axis
    params.X(1) = params.xCenter;
    params.X(2) = params.xCenter-500;
    params.X(3) = params.xCenter+300;

    f = [];
    if ~isempty(f)
        if f==1
            ix = randperm(length(params.iti1));
            ix = ix(1);
            [params] = compute_numFrames(params,params.iti1(ix));
        elseif f==2
            ix = randperm(length(params.iti2));
            ix = ix(1);
            [params] = compute_numFrames(params,params.iti2(ix));
        end;
    else
        iti_params = cell(1,length(params.idx));
        for kt = 1:length(params.idx)
            ix = randperm(length(params.iti));
            ix = ix(1);
            [iti_params{kt}] = compute_numFrames(params,params.iti(ix));
        end;
    end;

    %% prepare logfile    
    [params] = prepare_concept_tuning_logfile(params);    
    %PTBdebug;
    
    %% save params structure
    save([params.p2params,params.data_ID,'_tuning_params',params.date,'_',params.tmstp,'.mat'],'params');
    %PTBdebug;
    
    %% send the start trigger
    if isfield(params,'daqID')
        send_start_trigger(params);
        send_start_trigger(params);
        send_start_trigger(params);
    end;    
    %PTBdebug;
    
    %% initialize random number generator
    rand('state',sum(100*clock));

    %% calculate some parameters 
    n = length(params.Imf)*params.nreps;
    pct = ceil(n/4);%calculate the percentages
    pct = pct.*[1:3];
    c = 0;
        
    %% instructions for tuning
    instructions_tuning(params, 5 );        
    %PTBdebug;

    %% ITI
    iti_trial(iti_params{1});
    %PTBdebug;
        
    %% run the tuning
    nImg = length(params.idx);
    Priority(params.topPriorityLevel);
    for yt = 1:params.nreps% loop each pic over the reps
                
        [params.idx] = params.idx(randperm(nImg));% randomize order of pics        
        [params.idx] = params.idx(randperm(nImg));% randomize order of pics        
        [params.idx] = params.idx(randperm(nImg));% randomize order of pics        
        [params.idx] = params.idx(randperm(nImg));% randomize order of pics        
        
        for kt = params.start_trl:nImg
            %%
            c = c+1;%count

            %% make texture
            params.imageTexture = Screen('MakeTexture', params.window, params.theImage{params.idx(kt)});
            
            %% show stimulus
            [~,~] = run_concept_tuning(params,params.idx(kt));
            
            %% close texture
            Screen('Close',params.imageTexture);

            %% ITI
            iti_trial(iti_params{kt});
            %PTBdebug;
                
            %% break
            if ismember(c,pct)                
                [break_params] = compute_numFrames(params,5/100);
                wait_barEM(break_params,[num2str(floor(c/n*100)),'% of task completed. Take a short break ...']);
            end;
            %PTBdebug;
            
        end;
    end;
    Priority(0);

    %%
    params_end = compute_numFrames(params,2);
    end_of_task(params_end);
    
    %% END
    % Clear the screen
    Screen('CloseAll');
    sca;
    close all;
    fclose(params.fid);
    clear all;
    return;
    
catch
    %psychrethrow(psychlasterror);
    Screen('CloseAll');
    sca;% Clear the screen
    close all;
    fclose(params.fid);
    psychrethrow(psychlasterror);
    error('program aborted');
end;