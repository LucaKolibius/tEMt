% this now sends either a ttl or a serial trigger
function send_ttl(params,bv)
% for ttl trigger
if strcmp(params.trg, 'ttl')
    if isfield(params,'debugmode')
        if strcmp(params.debugmode,'no')
            [out_] = DaqDOut(params.daqID,0,bv); % send trigger
        end
    end
    
    if isfield(params,'debug')
        if strcmp(params.debug,'no')
            [out_] = DaqDOut(params.daqID,0,bv); % send trigger
        end
    end
    
% for serial trigger
elseif strcmp(params.trg, 'serial')
    IOPort('Write',params.trg_handle, params.trg_data); % sending the trigger
end

end