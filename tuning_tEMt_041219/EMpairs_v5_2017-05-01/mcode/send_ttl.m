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
    IOPort('Write',params.trg_handle, params.trg_data); % sending the trigger
    
elseif strcmp(params.trg, 'utrecht')
    fprintf(params.serial,'%c','c');
end