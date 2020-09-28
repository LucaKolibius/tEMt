    
    tmstp = clock;
    tmstp = tmstp(4:end);
    tmstp(end) = round(tmstp(end));
    x = [];
    for it = 1:length(tmstp)
        x = [x num2str(tmstp(it)),'_'];
    end; 
    x(end) = [];
    tmstp = x;