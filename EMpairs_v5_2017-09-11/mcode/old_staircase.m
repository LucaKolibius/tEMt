        %               % % adapt difficulty given past performance
        %             a  = zeros(1,length(params.trl_idx));for kt = 1:length(params.trl_idx);a(kt) =params.perf{params.trl_idx(kt)}.H;end;
        %         if params.c ==1
        %             [sc,d] = staircase([1/size(params.perf{1}.CM,2),mean(a)],params.sc_trsh);
        %         else
        %             %measure deviation from the desired level
        %             [sc,d] = staircase([params.baseperf,mean(a)],params.sc_trsh);
        %         end;
        %         if sc == 1% increase difficulty
        %             params.r(1) = round(d*5);
        %             params.diff_level = params.diff_level+sc*params.r(1);
        %         else
        %             if (params.diff_level-1)>1% decrease difficulty
        %                 params.r(2) = floor(d*5);
        %                 params.diff_level = params.diff_level+sc*params.r(2);
        %             end;
        %         end;