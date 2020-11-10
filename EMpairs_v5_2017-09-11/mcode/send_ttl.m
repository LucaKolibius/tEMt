function send_ttl(params, bv)

if strcmp(params.trg, 'ttl')
%     if isfield(params,'debugmode')
%         if strcmp(params.debugmode,'no')
            [out_] = DaqDOut(params.daqID,0,bv); % send trigger
%         end
%     end
    
%     if isfield(params,'debug')
%         if strcmp(params.debug,'no')
%             [out_] = DaqDOut(params.daqID,0,bv); % send trigger
%         end
%     end
    
elseif strcmp(params.trg, 'serial')
     switch bv
        case 0
            trigVal = uint8(3); %% start trigger
        case 6
            trigVal = uint8(4); %% crash trigger
        case 7
            trigVal = params.trg_data;
     end
    
    IOPort('Write',params.trg_handle, trigVal); % sending the trigger
    
elseif strcmp(params.trg, 'utrecht')
    fprintf(params.serial,'%c','c');
end