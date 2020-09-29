function start_tEMt

addpath('C:\Experiments\tEMt_041219\commonFunctions')

%% TUNING EXPERIMENT (PRE)
%  not currently implemented

%% EPISODIC MEMORY EXPERIMENT
[trg, patientID, sesh, lang] = start_tEMt_exp;                             % input through dialogue box

%% TUNING EXPERIMENT (POST)
start_tEMt_tuning(trg, patientID, sesh, lang)                              % input from start_tEMt_exp

end