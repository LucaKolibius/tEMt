function [stim_mat] = organize_stim_mat3(concept_neurons,ID)
%t2 = [];
%bb = [];
%for yt = 1:10
%for zt = 1:100
    %t1 = tic;
    %%
    stim_code = zeros(length(ID.id),1);
    for it = 1:length(ID.id)
        if length(regexp(ID.id{it},'_')) ==1
            stim_code(it) = str2double(ID.id{it}(regexp(ID.id{it},'_')+1:end));
        else
            stim_code(it) = str2double(ID.id{it}(min(regexp(ID.id{it},'_'))+1:max(regexp(ID.id{it},'_'))-1));
        end;
    end;
    %%
    si = find(diff(stim_code)~=0);
    if any(si ==0)
        k = 0;        
        si(end+1) = length(stim_code);
        idx = 1:si(1);
        stim_code2 = zeros(length(stim_code),1);
        for it = 1:length(si)
            
            k = k+1;
            if it > 1
                idx = si(it-1)+1:si(it);
                stim_code2(idx) = k*ones(1,length(idx));
            else
                stim_code2(idx) = k*ones(1,length(idx));
            end;
            
        end;
    else
        stim_code2 = zeros(length(stim_code),1);
        for it = 1:size(ID.id,1)
            c = find(strcmp(concept_neurons,ID.id{it}(1)));
            if ~isempty(c)
                stim_code2(it) = c+1;
            else
                stim_code2(it) = 1;
            end;
        end;
    end;
    %%
    u = [ID.id{:}];
    ix = regexp(u,'_');
    ix = ix(1:2:length(ix));
    l = u(ix-1);
    id = unique(l);
    n = zeros(length(id),1);
    for it = 1:length(id)
        n(it) = length(regexp(l,id(it)));
    end;
    %%
    [sel_idx] = cell(length(id),1);
    for jt = 1:length(id)
        chck = regexp(ID.id,[id(jt),'_']);
        u = zeros(length(chck),1);for it = 1:length(chck);u(it) = isempty(chck{it});end;
        [sel_idx{jt}] = find(u==0);
    end;
    %% get the id of the cue
    l2 = l;
    for it = 1:length(concept_neurons)
        l2(regexp(l2,concept_neurons{it})) = [];
    end;
    l2 = unique(l2);
    [cidx] = regexp(l,l2);% get the cue index
    %% get the id of the cue
    l3 = l;
    l3 = setdiff(l3,l2);
    pidx = cell(length(unique(l3)),1);
    for it = 1:length(l3)
        [pidx{it}] = regexp(l,l3(it));% get the cue index
    end;
    %% count the number of files
    r = sel_idx;
    s_idx = regexp(id,l2);for it = 1:length(l3);s_idx = [s_idx regexp(id,l3(it))];end;
    r = r(s_idx);
    n2 = zeros(length(sel_idx),1);
    for it = 1:length(sel_idx)
        n2(it) = length(sel_idx{it});
    end;
    [~,I] = min(n2);

    %%
    ix(it) = setdiff(1:length(id),regexp(id,l2));
    k = 0;
    conds = [];
    for it = 1:length(ix)
        for jt = 1:length(ix)
            k = k+1;
            conds(k,:) = sort([ix(it) ix(jt)]);
        end;
    end;
    dix =find(diff(conds,[],2)~=0);
    dix(1:2:end) = [];
    conds(dix,:) = [];
    conds = id(conds);
    %[conds] = [id(2) id(2);id(2) id(3);id(3) id(3)];
    %% sanity check
    np = length(concept_neurons);
    np = np*(np-1)/2 + length(concept_neurons);
    if length(conds) ~= np
        error('number of pairs does not match');
    end;
    %% intialize
    nseq = length(r{I})-1;
    seq = zeros(3,nseq);
    tc = zeros(2,nseq);
    k= 0;    
    %% build the triplet sequences
    while length(r{1})>2
        %for jt = 1:length(cidx)
        %while length(r{I})>1
        for it = 1:size(conds,1)
            
            k = k+1;
            ix = [regexp([concept_neurons{:}],conds(it,1)) regexp([concept_neurons{:}],conds(it,2))]+1;
            
            sel1 = r{1}(randperm(length(r{1})));
            
            if ( ix(1) == ix(2) ) && ( length(unique(stim_code2(r{ix(1)}))) ) >=1
                
                sel2 = r{ix(1)}(randperm(length(r{ix(1)})));
                f = 0;
                while ( f==0 )
                    sel3 = r{ix(2)}(randperm(length(r{ix(2)})));
                    if ( sel2(1)~= sel3(1) ) && ( stim_code2(sel2(1)) ~= stim_code2(sel3(1)) )
                        f=1;
                    end;
                end;
                
            else
                if ( length(unique(stim_code2(r{ix(1)}))) ) >= 1
                    sel2 = r{ix(1)}(randperm(length(r{ix(1)})));
                    f=0;
                    while ( f==0 )
                        sel3 = r{ix(2)}(randperm(length(r{ix(2)})));
                        if ( stim_code2(sel2(1)) ~= stim_code2(sel3(1)) )
                            f=1;
                        end;
                    end;
                end;
            end;

            try
                seq(1,k) = find(strcmp(ID.id,ID.id(sel1(1))));
                seq(2,k) = find(strcmp(ID.id,ID.id(sel2(1))));
                seq(3,k) = find(strcmp(ID.id,ID.id(sel3(1))));
                
                x = seq(2:3,k);
                fc = randperm(2);
                x = x(fc);
                seq(2:3,k) = x;
                
                r{1}(find(ismember(r{1},sel1(1))))          = [];
                r{ix(1)}(find(ismember(r{ix(1)},sel2(1))))  = [];
                r{ix(2)}(find(ismember(r{ix(2)},sel3(1))))  = [];
                
                tc(:,k) = ix;
                
            catch
                break;
            end;            
            
        end;
    end;
    %%
    [~,d2] = find(seq ==0);
    if ( length(unique(seq(:,d2))) ==1 ) && (unique(seq(:,d2)))
        eror('zero values not permitted');
    end;
    %%
    seq(:,d2)   = [];
    tc(:,d2)    = [];
    %% trigger codes
    tc = sum(tc,1);
    tc(tc==2) = 1;
    tc(tc==3) = 2;
    tc(tc==4) = 3;
    %% pair and cue indexes
    p = seq(2:3,:)';
    c = seq(1,:)';
    %%
    chck = ID.id(seq(2:3,:))';
    %% ouput
    stim_mat.ID = ID.id;
    stim_mat.idx =ID.idx;
    stim_mat.tc = tc;
    stim_mat.lkp = [];
    stim_mat.c = c;
    stim_mat.p = p;
    stim_mat.seq = seq;
    stim_mat.xc =[];
    
%    t2(zt) = toc(t1);
%    bb(zt) = length(seq);
%end;
%%
%figure;subplot(121);plot(t2,'b.');subplot(122);plot(bb,'b.');
%pause(.1);
%end;
return