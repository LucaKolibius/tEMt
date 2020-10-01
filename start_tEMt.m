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

%% INPUT PROMPT
prompt   = {'Trigger (Test oder TTL):','Patienten ID (sub-10XX):', 'Sitzung (XX):', 'Schwierigkeitsgrad:', 'Sprache:'};
dlgtitle = 'Eingabe';
dims     = [1 35];
definput = {'','sub-10XX','01','20', 'german'};
answer   = inputdlg(prompt,dlgtitle,dims,definput);

% PARSE-IN INPUT
trg        = lower(answer{1});
trg        = regexprep(trg, 'test', 'debug'); % if input is "test" change trigger to debug mode
patientID  = lower(answer{2});

sesh       = answer{3};
if size(sesh,2) == 1; sesh = ['0', sesh]; end

diff_level = str2double(answer{4}); % initially should be between 16 and 20
if strcmp(trg, 'debug'); diff_level = 4; end

lang       = lower(answer{5});

% TUNING EXPERIMENT (PRE) (not currently implemented)
try
    % EPISODIC MEMORY EXPERIMENT
    start_tEMt_exp(basepathEM, trg, patientID, sesh, diff_level, lang);    % input through dialogue box
    
    % TUNING EXPERIMENT (POST)
    start_tEMt_tuning(basepathTN, trg, patientID, sesh, lang)              % input through dialogue box

catch % continue with tuning if EM part is aborted
    
    % TUNING EXPERIMENT (POST)
    start_tEMt_tuning(basepathTN, trg, patientID, sesh, lang)              % input through dialogue box
    
end
end