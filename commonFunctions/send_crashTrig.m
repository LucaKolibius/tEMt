function send_crashTrig(params)
% utrecht trigger
if strcmp(params.trg, 'utrecht')
    fprintf(params.serial,'%c','x');
    WaitSecs(.2)
    fprintf(params.serial,'%c','x');
    WaitSecs(.2)
    
    fprintf(params.serial,'%c','x');
    WaitSecs(.3)
    fprintf(params.serial,'%c','x');
    WaitSecs(.2)
    
    fprintf(params.serial,'%c','x');
    WaitSecs(.2)
    fprintf(params.serial,'%c','x');
    WaitSecs(.2)
    
% ttl trigger
elseif strcmp(params.trg, 'ttl')
    send_ttl(params,params.crashTrig);
    WaitSecs(.2);
    send_ttl(params,0);
    
    WaitSecs(.2);
    send_ttl(params,params.crashTrig);
    WaitSecs(.2);
    send_ttl(params,0);
    
    WaitSecs(.2);
    send_ttl(params,params.crashTrig);
    WaitSecs(.3);
    send_ttl(params,0);
    
    WaitSecs(.2);
    send_ttl(params,params.crashTrig);
    WaitSecs(.3);
    send_ttl(params,0);
    
% serial trigger
elseif strcmp(params.trg, 'serial')
    send_ttl(params,0);
    
    WaitSecs(.2);
    send_ttl(params,0);
    
    WaitSecs(.3);
    send_ttl(params,0);
    
    WaitSecs(.2);
    send_ttl(params,0);
end
end % end of function