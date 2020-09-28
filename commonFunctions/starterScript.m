%% dependencies
addpath('C:\Experiments\tEMt_041219\commonFunctions')

%% Tuning A
% not currently implemented

%% EM PART
% start_tEMt_exp(trg, patientID, sesh, diff_level, lang)
% start_tEMt_exp('debug', 'sub-1013', '01', 3, 'german') % practice
start_tEMt_exp('ttl', 'sub-1013', '04', 8, 'german') % EM session

%% TUNING B
% start_tEMt_tuning('debug', 'sub-1013', '01', 'german', 'post') % practice
start_tEMt_tuning('ttl', 'sub-1013', '04', 'german', 'post') % tunning post EM