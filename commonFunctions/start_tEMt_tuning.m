%% HEADER Tuning BHAM
%
%
% code developed by F.ROUX
% 2016, University of Birmingham

% revisions by FRO, 26/04/2017
% revisions by FRO, 05/05/2017
% implemented ttl/serial trigger versions by LDK, 31/10/19 (happy halloween)
% adapted for tEMt by LDK, 04/12/19 (happy chrisis / crysler)

% trigger sent in: concept_tuning (L114, 135) & run_concept_tuning (L19, 54)

function start_tEMt_tuning(basepath, trg, patientID, sesh, lang)
close all
sca

prePost = 'post';       % so far no pre tuning allowed
cd(basepath); cd('..'); % to make sure we are not in the EM folder anymore and have some old functions on the path

if ~strcmp(trg,'debug')
    findPics(basepath, patientID, sesh) % first find the images that were presented during the previous EM part
end

params.trg = trg;
% params = [];

% never add filesep at end
cd([basepath,filesep,'mcode']);

% enter the appropriate date
d = datestr(now,'ddmmyyyy');

% trigger type
%     params.trg = 'ttl'; % real experiment
%     params.trg = 'serial';
% params.trg = 'debug'; % practice
%     prePost = 'pre';
params.prePost = prePost;
params         = loadLang(params, lang);

%number of repetitions per item
nreps = [ 6 ];
if strcmp(params.trg, 'debug') % also only has only 4 trials
    nreps = 2;
end

% response label for button press requested after each stimulus (left & right)
resp1 = 'Face'; % Label for left button
resp2 = 'Place'; % Label for right button
resp3 = 'Animal';

% mode in which to run the Exp:
%     Exp_mode = [ 'exp' ];% can be either 'debug' for debugging, or 'exp' for real Exp

% add folder with Experiment to Matlab path
addpath(genpath(basepath));

params.data_ID = [ patientID,'_TS', sesh ];
params.basepath = basepath;

% decide the folder from which to choose images
if ~strcmp(params.trg, 'debug') % not a practice run
    if strcmp(params.prePost, 'pre') % before the EM task we tune the whole session
        error('Pre Tuning not yet implemented. Simon says no.');
        params.p2f = [basepath, '\image_data\Tune\sesh',sesh, filesep];
    elseif strcmp(params.prePost, 'post') % after the EM task we only look for tunings to the images that were shown before
        params.p2f = [basepath, '\image_data\Tune\', patientID, filesep, 'sesh',sesh, '_postEM_',d, filesep];
    end
elseif strcmp(params.trg, 'debug')
    params.p2f = [basepath, '\image_data\EMtune\formatted_180-180\practice\'];
    %     params.p2f = 'C:\Experiments\tEMt_041219\EMpairs_v5_2017-09-11\image_data\EMtune\formatted_180-180\numbers\';
end

%     saving path for the params and logfile
params.p2log    = [params.basepath,filesep, 'log', filesep, 'Tuning', filesep, patientID, filesep, 'Session_', sesh, filesep];
params.p2params = [params.basepath,filesep, 'params', filesep, patientID, filesep, 'Session_', sesh, filesep];

params.nreps = nreps;% number of reps per pic
%     params.resptimeout = 5;% max time given to respond
params.start_trl  = 1;% where to begin within a block
params.startBlock = 1; % with which block out of nrep blocks to begin
params.iti        = [200 225];% duration of inter-trial jitter % originally [500 550]
params.stimd      = 1.1;%duration of pic on screen
params.doPerm     = 1;

params.starttrig = 255;
params.basetrig  =  30; % not in use to reduce TTL artifacts
params.resptrig  = 150; % not in use to reduce TTL artifacts
params.crashTrig = 128;

params.resp_cat1 = resp1; %left arrow
params.resp_cat2 = resp2; %right arrow
params.resp_cat3 = resp3; % down arrow

create_logfile_timestamp; % creates a timestamp called tmstp with the clock time (eg. 8_50_12)
params.tmstp = tmstp;
params.date = d; % d was defined earlier and is the datestring

%% check for aborted sessions
chck = dir([params.p2params]); % does a param folder already exist?
[params.rep] = 'n'; % default answer is to start a new session

if ~strcmp(trg, 'debug') % we don't create folders for debug runs
if isempty(chck)
    mkdir(params.p2params);
else
    fprintf(['checking:\n']);
    fn = dir([params.p2params,'*_tuning_params_aborted.mat']); % params.tmstp will be from the experiment start
    
    if ~isempty(fn) % if there is a partial session
        x = [];
        for tt = 1:length(fn)
            %             x(tt) = datenum(fn(tt).date);
            x(tt) = fn(tt).datenum;
        end
        [~,sidx] = sort(x);
        sel = sidx(end);
        [params.rep] = input(['Do you wish to continue aborted session: ', fn(sel).date, '? (y/n) '], 's');
        if strcmp(params.rep,'y')
            load([params.p2params,fn(sel).name]);
            params.rep = 'y'; % when loading the old params file params.rep will be reset to 'n'
        end
    end
end
end

% creates an empty logfile in the exp/log/Tuning folder or reopens one
% from an aborted session

chckLog = dir(params.p2log);

if ~strcmp(trg, 'debug') % we don't create folders for debug runs
    if isempty(chckLog)
        mkdir(params.p2log);
    end
    
    if strcmp(params.rep, 'n') % new session
        params.fid = fopen([params.p2log,params.data_ID,'_TS',num2str(sesh),'_log_ctune_',params.date,'_',params.tmstp,'.txt'],'w');
    elseif strcmp(params.rep, 'y') % reopen aborted session's logfile
        fn2 = dir([params.p2log,'*txt']);
        x = [];
        for tt = 1:length(fn2)
            %             x(tt) = datenum(fn2(tt).date);
            x(tt) = fn(tt).datenum;
        end
        [~,sidx] = sort(x);
        sel = sidx(end);
        params.fid = fopen([fn2(sel).folder, filesep, fn2(sel).name], 'a'); % r+ might also work
        if params.fid < 0
            error('Could not re-open logfile')
        end
    end
end

%%j.l#
Concept_tuning(params);

%% REMOVE ALL PATHS FROM TUNING
rmpath(genpath(basepath));

end % END OF FUNCTION

