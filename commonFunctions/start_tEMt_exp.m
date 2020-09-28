%% HEADER EM-task BHAM
%
% code developed by L.D. KOLIBIUS aka LDK
% based on code developed by F.ROUX aka FRO (2016)
% University of Birmingham, 2019
function start_tEMt_exp(trg, patientID, sesh, diff_level, lang)
if ~strcmp(sesh, '01') && ~strcmp(trg,'debug') % it is not the first session and it is not the practice (debug) session
    prepNextEMsesh(patientID, sesh)
end

params = [];
basepath = [ 'C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11' ]; % substitute with your experiment path

params.trg = trg;
% params.trg = 'debug'; diff_level = 3;
% params.trg = 'ttl'; diff_level = 20;
%% NOTHING NEEDS TO BE CHANGED FROM HERE
% participant ID
% patientID = [ 'sub-0014' ];% add here the Patient ID, eg P01, P02, etc
% sesh = ['01']; % session number

% set the initial difficulty level. Nothing needs to be changed here
% diff_level = 20; % change from 16 to 20, determines the initial block length
params.expDur = 30; % maximum experiment duration in minutes, might abort earlier due to stimulus material
params.stimSizeX = 320; % image size
params.stimSizeY = 320;

% mode in which to run the Exp:
[Exp_mode] ='exp_fVSp';% can also be 'exp_cp' for concept neurons, 'exp_fVSp' for face vs place, or 'debug' for debugging

% add folder with Experiment to Matlab path
% basepath = [ 'C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11' ]; %substitute with path
addpath(genpath(basepath));

% other settings
% params.trg = 'serial';  diff_level = 20; %% careful! I think the serial
% trigger is the same for the trial trigger and the send_start_trigger!
% params.trg = 'utrecht'; diff_level = 20;

params = loadLang(params, lang);
% params = loadLang(params, 'dutch');
% params = loadLang(params, 'german');

%% everything is automatic from hereon
d = datestr(now,'yyyy-mmm-dd');

params.start_idx = [];% can be used to start from a specific BLOCK on
params.initial_diff_level = diff_level;
params.diff_level = params.initial_diff_level;
params.Ed = [2 1];% Time for encoding
params.RetTime =  2;% Time for retrieval
params.permRet = 1; % permutate trial order for retrieval by default. Might be overwritten when loading old params. 

params.enctrig = 7;%
params.rettrig = 7;%
params.starttrig = 255;
params.crashTrig = 128;

%%
params.basepath = basepath;
params.p2log = [params.basepath,filesep,'log',filesep,patientID,filesep,'Session_',sesh, filesep]; % where to save logfiles
params.savep = [params.basepath,filesep,'params',filesep,patientID,filesep,'Session_',sesh, filesep]; % where to save params

%%
chck = dir([params.savep]); % does a param file already exist?

[params.rep] = 'n';
[params.encTrl] = 1;
[params.retTrl] = 1;

if isempty({chck.name}') % makes a parameter folder for that participant if it doesnt already exist
    mkdir([params.savep]);    
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
%% create path for saving output
params.savep = [params.basepath,filesep,'params',filesep,patientID,filesep]; % I don't know why fred repeats this here..

%%
concept_neurons = {'a_'}; % this is for the tEMt version
params.data_ID = [patientID,'_tEMt_',sesh];
% params.debugmode = 'no';
if strcmp(sesh, '01')
p2img = 'C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\image_data\EMtune\formatted_180-180\stimMat\';
else
    p2img = ['C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\image_data\EMtune\formatted_180-180', filesep, 'subjectSpecific', filesep, patientID, filesep,'sesh' sesh, filesep];
end

if strcmp(params.trg, 'debug')
    p2img = 'C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\image_data\EMtune\formatted_180-180\practice\';
end
params.concept_neurons = concept_neurons;
params.p2f = p2img;

%% generate file identifier for logfile
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

%% run the experiment
EMexp(params)