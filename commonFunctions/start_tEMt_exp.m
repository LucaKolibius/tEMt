%% HEADER EM-task BHAM
%
% code developed by L.D. KOLIBIUS aka LDK
% based on code developed by F.ROUX aka FRO (2016)
% University of Birmingham, 2019

% trigger sent in EMexp (L22, 107), run_encoding (L32, 115), run_retrieval(L91, 133)
function start_tEMt_exp(basepath, trg, patientID, sesh, diff_level, lang)

% % EXAMPLE INPUT
% trg = 'debug';
% patientID = 'sub-1098';
% sesh = '01';
% diff_level = 20;
% lang = 'german';

% FOR SESSION 2 AND MORE YOU EXCLUDE PREVIOUSLY SHOWN STIMULUS MATERIAL
if ~strcmp(sesh, '01') && ~strcmp(trg,'debug') % it is not the first session and it is not the practice (debug) session
    prepNextEMsesh(basepath, patientID, sesh) % load the next set of stimuli
end

params = [];
params.trg = trg;

switch strcmp(trg, 'debug')
    case 0
        params.expDur = 1; % maximum experiment duration in minutes, might abort earlier due to stimulus material
    case 1
        params.expDur = 1;
        diff_level    = 3;
end

params.stimSizeX = 320; % image size
params.stimSizeY = 320;

% mode in which to run the Exp:
% [Exp_mode] = 'exp_fVSp';% can also be 'exp_cp' for concept neurons, 'exp_fVSp' for face vs place, or 'debug' for debugging

% add folder with Experiment to Matlab path
addpath(genpath(basepath));

% other settings
% params.trg = 'serial';  diff_level = 20; %% careful! I think the serial
% trigger is the same for the trial trigger and the send_start_trigger!
% params.trg = 'utrecht'; diff_level = 20;

params = loadLang(params, lang);

%% everything is automatic from hereon
d = datestr(now,'yyyy-mmm-dd');

params.start_idx = [];% can be used to start from a specific BLOCK on
params.initial_diff_level = diff_level;
params.diff_level = params.initial_diff_level;
params.Ed = [2 1];% Time for encoding
params.RetTime =  2;% Time for retrieval
params.permRet = 1; % permutate trial order for retrieval by default. Might be overwritten when loading old params.

params.enctrig = 7;
params.rettrig = 7;
params.starttrig = 255;
params.crashTrig = 128;

%%
params.basepath = basepath;
params.p2log    = [params.basepath,filesep,'log',   filesep,patientID,filesep,'Session_',sesh, filesep]; % where to save logfiles
params.savep    = [params.basepath,filesep,'params',filesep,patientID,filesep,'Session_',sesh, filesep]; % where to save params

%%
chck = dir([params.savep]); % does a param file already exist?

[params.rep]    = 'n';
[params.encTrl] = 1;
[params.retTrl] = 1;

if ~strcmp(trg, 'debug') % we don't create folders for debug runs
    
    if isempty({chck.name}') % makes a parameter folder for that participant if it doesnt already exist
        
        mkdir([params.savep]);
        mkdir([params.p2log])
        
    else % the case when there already is a parameter folder
        
        fprintf(['checking:\n']);
        fn = dir([params.savep,'*_params_aborted.mat']); % is there an aborted session?
        
        if ~isempty(fn) % if there is a partial session
            
            % find the last aborted session
            x = [];
            for tt = 1:length(fn)
                x(tt) = datenum(fn(tt).date);
            end
            [~,sidx] = sort(x);
            sel = sidx(end);
            
            [params.rep] = input(['Do you wish to continue aborted session: ', fn(sel).date, '? (y/n) '], 's');
            
            if strcmp(params.rep,'y')
                load([params.savep,fn(sel).name]);
                params.rep = 'y'; % this gets overwritten when loading the old parameter
            end
            
        end
        
    end
    
end % end of debug check

%%
concept_neurons = {'a_'}; % this is for the tEMt version
params.data_ID = [patientID,'_tEMt_',sesh];

if strcmp(sesh, '01') % first session are always the same stimuli (all except the practice pictures)
    p2img = [basepath, '\image_data\EMtune\formatted_180-180\stimMat\'];
else
    p2img = [basepath, '\image_data\EMtune\formatted_180-180', filesep, 'subjectSpecific', filesep, patientID, filesep,'sesh' sesh, filesep];
end

if strcmp(params.trg, 'debug')
    p2img = [basepath, '\image_data\EMtune\formatted_180-180\practice\'];
end

params.concept_neurons = concept_neurons;
params.p2f = p2img;

%% generate file identifier for logfile
if ~strcmp(trg, 'debug') % we don't open / reopen logfiles for practice runs
    
    if strcmp(params.rep, 'n')
        get_clock_time;
        params.fid = fopen([params.p2log,params.data_ID,'_',d,'_',ct,'_LogFile_EMtask.txt'],'w'); % creates the logfile
    elseif strcmp(params.rep, 'y') % find last logfile and continue to write output there
        fn2 = dir([params.p2log,params.data_ID,'*txt']);
        x = [];
        for tt = 1:length(fn2)
            x(tt) = datenum(fn2(tt).date);
        end
        [~,sidx] = sort(x);
        sel = sidx(end);
        params.fid = fopen([fn2(sel).folder, filesep, fn2(sel).name], 'a'); % r+ might also work
        if params.fid < 0
            error('Could not re-open logfile')
        end
        
    end
    
end

%% run the experiment
EMexp(params)

%% REMOVE EXPERIMENT FOLDER FROM PATH
rmpath(genpath(basepath))
end