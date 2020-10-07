% Psychophysicstoolbox need to be setup properly
function start_tEMt
addpath('X:\Luca\tEMt\commonFunctions')

%% BASEPATH: THIS NEEDS TO BE ADAPTED
basepathEM = [ 'X:\Luca\tEMt\EMpairs_v5_2017-09-11' ]; % substitute with your experiment path
basepathTN = [ 'X:\Luca\tEMt\tuning_tEMt_041219\EMpairs_v5_2017-05-01'];

% since EM and tuning were created from the same experimental code, some
% functions overlap. If we run the tuning task, we don't want any unedited / unaltered tuning
% functions from the EM folder to interfere.
rmpath(genpath(basepathEM))
rmpath(genpath(basepathTN))

%% TRY TO SUGGEST A NEW SESSION NUMBER
suggestSesh = 1;

findSbj    = dir([basepathEM,'\params\s*']); % CHANGE TO SUBJXXX WHATEVER % FIND LAST SUBJECT FOLDER
[~,idx]     = sort([findSbj.datenum]);
findSbj    = findSbj(idx);

%% check if >1 week -> previous patient
if now - findSbj(end).datenum >= 6 % IF THE NUMBER OF DAYS SINCE THE LAST PATIENT FOLDER IS OVER 6 IT SUGGESTS A NEW PATIENT
    suggestSesh = 1;
else
    temp = dir([findSbj(end).folder, filesep, findSbj(end).name, filesep, 'sesh*']); % FIND LAST SESSION
    [~,idx]     = sort([temp.datenum]);
    temp = temp(idx);
    
    finishedSesh = ~isempty(dir([temp(end).folder, filesep, temp(end).name, filesep, '*_params_completed.mat']));
    
    switch finishedSesh
        case 0
            suggestSesh = size(temp,1);
        case 1
            suggestSesh = size(temp,1) + 1;
    end
end
suggestSesh = num2str(suggestSesh);
if size(suggestSesh,2) == 1; suggestSesh = ['0', suggestSesh]; end

%% INPUT PROMPT
prompt   = {'Experiment: Tuning (tun) oder EM (em):', 'Trigger (Test oder TTL):','Patienten ID (sub-10XX):', 'Sitzung (XX):', 'Sprache:'};
dlgtitle = 'Eingabe (1/2)';
dims     = [1 35];
definput = {'tun', 'TTL','sub-10XX', suggestSesh, 'german'};
answer   = inputdlg(prompt,dlgtitle,dims,definput);

%% PARSE-IN INPUT
tunEM      = lower(answer{1});
tunEM      = regexprep(tunEM, 'tuning', 'tun'); % if input is "test" change trigger to debug mode
if ~strcmp(tunEM, 'tun') && ~strcmp(tunEM, 'em'); error('Falsches Experimentkürzel ("tun" oder "em")'); end

trg        = lower(answer{2});
trg        = regexprep(trg, 'test', 'debug'); % if input is "test" change trigger to debug mode

patientID  = lower(answer{3});

sesh       = answer{4};
if size(sesh,2) == 1; sesh = ['0', sesh]; end

lang       = lower(answer{5});

%% INPUT PROMPT DIFFICULTY
%  FIND PREVIOUS DIFFICULTY LEVEL IF POSSIBLE
%  (this could be combined with the suggestSesh part)
try
prevSesh = sesh;
prevSesh = str2double(sesh); 
prevSesh = prevSesh - 1;
prevSesh = num2str(prevSesh);
if size(prevSesh,2) == 1; prevSesh = ['0', prevSesh]; end

prevParams    = dir([basepathEM,'\params\',patientID,'\Session_',prevSesh, filesep]); % where to save params
load([prevParams(end).folder, filesep, prevParams(end).name], 'params');
prevDif = num2str(params.diff_level);
catch
    prevDif = '20';
end

prompt       = {'Schwierigkeitsgrad:'};
dlgtitle     = 'Eingabe (2/2)';
dims         = [1 35];
definput     = {prevDif};
answerDiff   = inputdlg(prompt,dlgtitle,dims,definput);

diff_level = str2double(answerDiff{1}); % initially should be between 16 and 20
if strcmp(trg, 'debug'); diff_level = 4; end

%% RUN EM-TASK OR TUNING
% ONLY POST EM TUNING IS IMPLEMENTED

if strcmp(tunEM, 'tun') % TUNING TASK
    start_tEMt_tuning(basepathTN, trg, patientID, sesh, lang)          % input through dialogue box
    
elseif strcmp(tunEM, 'em') % EPISODIC MEMORY EXPERIMENT
    start_tEMt_exp(basepathEM, trg, patientID, sesh, diff_level, lang);    % input through dialogue box
    
end
    
end
