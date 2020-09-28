function [params] = prepare_EMlogfile(params)

%28/06/2016 -FRO:fixed bug in Retrieval header line

if strcmp(params.rep, 'n') % when starting the experiment, prepare logfile header
    get_clock_time;
    fprintf(params.fid,['LOGFILE:\b',date,'\b']);
    fprintf(params.fid,[num2str(ct),'\b']);
    fprintf(params.fid,'\n');
    
    %ENC
    %block ntrials STIMID1 STIMID2 STIMID3 OT1 OT2 OFFT RESP RT
    fprintf(params.fid,'ENC\n');
    txt = ['TRL\tSTIMID1\tSTIMID2\tOT1\tOT2\tOT3\tRESP\tRT'];
    fprintf(params.fid,[txt,'\n']);
    
    %RET
    %block ntrials TRL_BEG TRL_END OT1 OT2 OFFT AC RT
    fprintf(params.fid,'RET\n');
    txt = ['TRL\tSTIMID1\tSTIMID2\tAC1\tRT1\tRT2\tOT1\tOT2\tOT3\tOT4\tOT5'];
    fprintf(params.fid,[txt,'\n']);
    
elseif strcmp(params.rep, 'y') % resume after a crash
    get_clock_time;
    fprintf(params.fid,[num2str(0),'\tResume Experiment\t',date,'\t', num2str(ct),'\n']);
end
