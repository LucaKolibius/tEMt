function send_start_trigger(params)
% for utrecht
if strcmp(params.trg, 'utrecht')
    fprintf(params.serial,'%c','t');
    WaitSecs(.01)
    fprintf(params.serial,'%c','t');
    WaitSecs(.2)
    
    fprintf(params.serial,'%c','t');
    WaitSecs(.01)
    fprintf(params.serial,'%c','t');
    WaitSecs(.2)
    
    fprintf(params.serial,'%c','t');
    WaitSecs(.01)
    fprintf(params.serial,'%c','t');
    WaitSecs(.2)
    
    % for other trigger (ttl or serial)
elseif strcmp(params.trg, 'ttl')
    send_ttl(params,params.starttrig);
    WaitSecs(.01);
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,params.starttrig);
    WaitSecs(.01);
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,params.starttrig);
    WaitSecs(.01);
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,params.starttrig);
    WaitSecs(.01);
    send_ttl(params,0);
    
elseif strcmp(params.trg, 'serial')
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,0);
    
    WaitSecs(.02);
    send_ttl(params,0);
end
end


