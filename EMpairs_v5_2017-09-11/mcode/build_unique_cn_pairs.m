function [stim_mat] = build_unique_cn_pairs(ID,params)

flag = 0;
rand('state',sum(100*clock));

while flag <1
    
    %%
    stim_mat.ID = ID.id;
    stim_mat.idx =ID.idx;
    
    %%
    ID2 = ID.id;
    
    %% we already have that in Id.idx?
    idx = zeros(length(ID2),1);
    for it = 1:length(ID2)        
        idx(it) = it;% assign number to each image        
    end;
    
     %% here we look whether any images are f_ or p_
    concept_n = params.concept_neurons; %concept neuron labels
%     cc = zeros(length(idx),1);
%     for it = 1:length(concept_n) % for f_ and then for p_
%         
%         % see if the loaded images are f_ or p_
%         chck = regexp(ID2,concept_n{it});% use regexp instead of strcmp
%                                          %to allow for more complex labeling
%         
%         % check2 is 1 if check1 is empty
%         chck2 = zeros(length(chck),1);
%         for jt = 1:length(chck)
%             chck2(jt) = isempty(chck{jt});
%         end;
%         
%         ix = find(chck2 ==0);
%         cc(ix) = it+zeros(length(ix),1); % cc is an index over all images. cc is 1 for f_ and 2 for p_
%         
%     end;
    
% since this is never the case we might as well simply do:
    cc = zeros(length(ID2),1);
    
    %% generate condition labels
    
    % for two conditions (f and p) cp =
    %     [1 1
    %      1 2
    %      2 2]
%     n = length(concept_n);
%     
%     cp = zeros(n*(n-1)/2+n,2);
%     k = 0;
%     
%     x1 = 1;
%     for it = 1:n
%         for jt = x1:n
%             k=k+1;
%             cp(k,:) = [it jt];
%             
%         end;
%         x1 = x1+1;
%     end;
    
    %% store the indexes of the cues 
    % new for tEMt:
    % half of the cc stimuli are now ones (declared associate images)
    assIdx = randperm(size(cc,1),size(cc,1));
    assIdx(1:size(cc,1)/2) = [];
    cc(assIdx) = 1;
    %
    
    samp = [idx cc]; % number of image / category it belongs to initially (0(c) 1(f) 2(p)). for tEMt it is 0(c) 1(a)
    
    [c_idx] = find(samp(:,2)==0);%indexes of the cue images
    [c_idx] = c_idx(randperm(length(c_idx)));% randomize the cues
    
    
    %%
    aIdx = find(samp(:,2) == 1); % find associate
    aIdx = aIdx(randperm(size(aIdx,1)));
    seq = [c_idx'; aIdx'];
    
    %
%     %% old fVSp stuff
%     trl = 0;
%     %seq = zeros(3,round(length(find(samp(:,2)~=0))/2));
%     seq = zeros(3,length(find(samp(:,2)~=0)));
%     f1 = 0;
%     h = [];
%     p_mem = [];
%     while f1==0
%         for it = 1:size(cp,1)
%             
%             p = cp(it,:);
%             
%             sel = [];
%             ix = cell(length(p),1);
%             for jt = 1:length(p)
%                 ix{jt} = find(samp(:,2) == p(jt));
%             end;
%             if isempty(ix{1})
%                 f1=1;
%             else
%                 p_mem = [p_mem;p];
%                 ix{1} = ix{1}(randperm(length(ix{1})));
%                 sel(1) = ix{1}(1);
%                 
%                 
%                 if (length(find(ismember(samp(:,2),cp(it,:)))) >=2) && ~isempty(ix{2})
%                     f2 = 0;
%                     while f2 ==0
%                         ix{2} = ix{2}(randperm(length(ix{2})));
%                         sel(2) = ix{2}(1);
%                         if sel(2) ~= sel(1)
%                             f2=1;
%                         end;
%                     end;
%                 end;
%                 
%                 if length(sel) ==2
%                     trl = trl+1;
%                     h(trl,:) = p;
%                     seq(2:3,trl) = samp(sel,1);
%                     samp(sel,:) = [];
%                 end;
%             end;
%         end;
%         
%     end;
%     
%     %%
%     ix2 = find(samp(:,2)~=0);
%     
%     sel_mem = [];
%     for it = 1:length(ix2)
%         
%         ix = find(samp(:,2)~=0);        
%         ix = ix(randperm(length(ix)));
%         
%         if length(ix) >1
%             
%             ix = ix(1:2);          
%             
%             con = [];
%             con(1) = samp(ix(1),2);
%             con(2) = samp(ix(2),2);            
%             con = sort(con);
%             
%             if any(sum(ismember(cp,con),2)==2)
%                 
%                 sel = [];
%                 sel(1) = samp(ix(1),1);
%                 sel(2) = samp(ix(2),1);
%                 
%                 sel_mem = [sel_mem;sel];
%                 samp(ix,:) = [];
%             end;
%             
%         end;
%     end;
%     
%     %%     
%     if size(seq,2) > length(c_idx)
%         for it = 1:length(c_idx)
%             seq(1,it) = c_idx(it);
%         end;
%         seq(:,it+1:size(seq,2)) =[];
%         
%     else
%         for it = 1:size(seq,2)
%             seq(1,it) = c_idx(it);
%         end;
%     end;
    
    %% sanity checks
    if any(ismember(seq(1,:),seq(2,:)));error('overlap between cues and associates');end;%sanity check
    if length(unique(seq(:))) ~= length(seq(:));error('overlap between images detected');end;%sanity check
    
    %% fix triplets
%     [~,d2] = find(seq(2,:) == 0);
%     c = seq(1,d2);
%     seq(:,d2) = [];
    
    %% fix triplets
%     for it = 1:length(c)
%         if ~isempty(sel_mem)
%             rsel = randperm(size(sel_mem,1));
%             rsel = rsel(1);
%             seq(:,end+1) = [c(it) sel_mem(rsel,:)]';
%             sel_mem(rsel,:) = [];
%         end;
%     end;
       
    %%
    ix = randperm(size(seq,2));
    for it =1:1e3
        ix = ix(randperm(length(ix)));
    end; 
    
    seq = seq(:,ix);
    
    %% sanity check
%     x = seq(2:3,:);
%     x = x(:);
%     if (length(x) == length(unique(x))) ~= 1
%         error('non-unique event codes not permitted');
%     end;
    
    %%
    stim_mat.tc = [];
    stim_mat.lkp = [];
    stim_mat.c = find(cc==0); % image number of the cues
    stim_mat.p = find(cc ~=0); % image number of the associates
    stim_mat.seq = seq; % originally sequence of image triplets. 3xNtrls
    stim_mat.xc =[];
    
    if any(ismember(stim_mat.c,stim_mat.p))
        error('overlap between pair and cue indices');
    end
    
%     c =0;
%     chck = 0;
%     
%     if isfield(params,'stim_mat')
%         for kt = 1:size(stim_mat.seq,2)
%             sel = stim_mat.seq(2,kt);
%             for lt = 1:size(params.stim_mat.seq,2)
%                 sel2 = params.stim_mat.seq(2,lt);
%                 if isequal(sel,sel2)
%                     c =c+1;
%                     chck(c) = 1;
%                     fprintf('warning searching for compatible cn-pair configuration\n');
%                 end;
%             end;
%         end;
%     end;
%     
%     if sum(chck)==0
        flag=1;
%     end;
    
end;
fprintf('exiting cn pair configuration: all pairs ok\n');
return;