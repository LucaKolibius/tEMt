function [fid] = prepare_EMlogfile(params)    

ct = clock;ct = ct(4:6);
fid = fopen([params.p2log,'log',filesep,'LogFile_EMtask.txt'],'w');
fprintf(fid,['LOGFILE:\b',date,'\b']);
for zt = 1:length(ct);fprintf(fid,[num2str(ct(zt)),'\b']);end;
fprintf(fid,'\n');
txt = ['RUN\tNPAIRS\tACCURACY\tSTART-TRIAL\tEND-TRIAL'];
fprintf(fid,[txt,'\n']);