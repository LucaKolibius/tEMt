function Concept_tuning(params)
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
    
    %% see if there are any uncompleted tunings
    %     chck = dir([params.p2f,filesep,'params',filesep,params.data_ID,'_tuning_params_',params.date,'_',params.tmstp,'.mat']);
    %     if ~isempty(chck)
    %         load([params.p2f,filesep,'params',filesep,params.data_ID,'_tuning_params_',params.date,'_',params.tmstp,'.mat'],'params');
    %     else
    %% setting up the trial structure and response buttons
    if strcmp(params.rep, 'n') % otherwise this info is already in the params file
        params = set_up_concept_tuning(params,'n');
    end
    %     end
    
    %% setup reponse buttons
    params.btns = SetExpButtons;
    
    %% get screen params
    params = get_screen_params(params);
    
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('Preference', 'VBLTimestampingMode', 2);
    Screen('BlendFunction', params.window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    params.Yoffs = 0;% controls center of screen offset
    
    %% Retreive the maximum priority number
    params.topPriorityLevel = MaxPriority(params.window);
    
    %% load in background image from file
    params = read_bckgrnd_image(params,'n');
    
    %% load in all images from file
    params = read_stim_images(params);
    
    for it = 1:length(params.ID)
        x = params.ID{it}; % load image name number 'it'
        x(regexp(x,' ')) = [];%make sure there are no white-spaces
        x(regexp(x,',')) = [];%make sure there are no white-spaces
        params.ID{it} = x; % update image name
        x = params.Imf(it).name; % repeat for Imf
        x(regexp(x,' ')) = [];
        x(regexp(x,',')) = [];
        params.Imf(it).name = x;
    end
    
    %% compute corrdinates
    params = calculate_coordinates_tuning(params);
    
    %%
    if strcmp(params.rep, 'n') % do not overwrite params.idx when reloading it from a crashed session
        params.idx = 1:length(params.Imf); % number of trials per rep, equals number of input images
    end
    
    %% some more display settings
    %compute the number of frames
    params = compute_numFrames(params,params.stimd);
    
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
        end
    else
        iti_params = cell(1,length(params.idx));
        for kt = 1:length(params.idx)
            ix = randperm(length(params.iti));
            ix = ix(1);
            iti_params{kt} = compute_numFrames(params,params.iti(ix));
        end
    end
    
    %% prepare logfile
    params = prepare_concept_tuning_logfile(params);
    
    %% save params structure
    save([params.p2params,params.data_ID,'_',params.date,'_',params.tmstp,'_tuning_params_init.mat'],'params');
    
    %% prep trigger box + start trigger
    % ttl trigger
    if strcmp(params.trg, 'ttl')
        params.daqID  = DaqDeviceIndex;
        if isempty(params.daqID)
            error('trigger box not connected');
        end
        err = DaqDConfigPort(params.daqID,[],0);
        out_ = DaqDOut(params.daqID,0,0); % reset
        
        % serial trigger
    elseif strcmp(params.trg,'serial')
        params.trg_handle = IOPort('OpenSerialPort', 'COM5'); % try out COM3 otherwise, creates trigger handle
        params.trg_data = uint8(1); % value that is being sent
        
        % utrecht serial trigger
    elseif strcmp(params.trg, 'utrecht')
        %Trigger output is at 115200
        params.serial = serial('COM4','BaudRate',115200);
        fopen(params.serial)
    elseif strcmp(params.trg, 'debug')
    end
    
    if ~strcmp(params.trg, 'debug')
        send_start_trigger(params);
        send_start_trigger(params);
        send_start_trigger(params);
    end
    
    %% initialize random number generator
    rand('state',sum(100*clock));
    
    %% calculate some parameters
    n = length(params.Imf)*params.nreps; % number of total trials
    pct = ceil(n/4); %calculate 25%
    pct = pct.*[1:3]; % pct = 25% / 50% / 75%
    c = 0;
    
    %% instructions for tuning
    instructions_tuning(params, 5 );
    
    %% ITI
    iti_trial(iti_params{1});
    
    %% run the tuning
    nImg = length(params.idx);
    Priority(params.topPriorityLevel);
    
    for yt = params.startBlock:params.nreps % loop each pic over the reps    % from 1 to 8(reps)
        params.startBlock = yt;
        disp('Resume at block: ')
        disp(yt);
        
        if params.doPerm == 1
            params.idx = params.idx(randperm(nImg));% randomize order of pics
            params.idx = params.idx(randperm(nImg));% randomize order of pics
            params.idx = params.idx(randperm(nImg));% randomize order of pics
            params.idx = params.idx(randperm(nImg));% randomize order of pics
            params.doPerm = 0;
            
            disp('Permutating. New order: ');
            disp(params.idx);
        end
        disp('Using Order: ');
        disp(params.idx);
        
        
        
        for kt = params.start_trl:nImg % from 1 to number of images
            params.start_trl = kt;
            
            % save parameters
            create_logfile_timestamp
            save([params.p2params,params.data_ID,params.date,'_',tmstp,'_tuning_params_aborted.mat'],'params'); % params.tmstp will be from the experiment start
            
            disp('Resume at trial: ');
            disp(kt);
            
            c = c+1; %count
            
            %% make texture
            params.imageTexture = Screen('MakeTexture', params.window, params.theImage{params.idx(kt)});
            
            %% show stimulus
            [~,~] = run_concept_tuning(params, params.idx(kt));
            
            %% close texture
            %             Screen('Close',params.imageTexture);
            
            %% ITI
            iti_trial(iti_params{kt});
            
            
            %% break % (break whenever we reach 25% / 50% / 75%
            if ismember(c,pct)
                [break_params] = compute_numFrames(params,5/100);
                wait_barEM(break_params,[num2str(floor(c/n*100)), params.tunInstrBreak1]);
            end
            
        end
        params.start_trl = 1; % for the next block start with trial 1 again
        params.doPerm = 1; % permutate the trial order again for the next block
    end
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
    disp('Cought it!')
    send_crashTrig(params)
    
    Screen('CloseAll');
    sca;% Clear the screen
    close all;
    fclose(params.fid);
    psychrethrow(psychlasterror);
    error('program aborted');
end