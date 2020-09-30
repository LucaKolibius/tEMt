function [params] = set_up_stimuli(params,backgrnd)
%%
if nargin == 0
    params.p2f = '/home/rouxf/Exp_EM/test/';
    params.concept_neurons = {'gstq','bb'};
    backgrnd = 'n';
end

%% search for and get image file-names
[Impath] = [params.p2f]; % path where images are stored

[Imf] = dir([Impath,filesep,'*.*']); % struct of all images in Impath
Imf(1:2) = []; % clear the first two entries because they are not pictures
%if isempty(Imf)
%    error('no image files detected');
%end;

%% get the stimuli
[ID] = stimIDmat(Imf); % ID is a struct with two variables. one codes for type of image (animal/face/place) the other the number (1:361)

%% search for a background image
Imfb = [];
[Impath] = [params.basepath,filesep,'image_data',filesep,'background',filesep];
if strcmp(backgrnd,'y')
    [Imfb] = dir([Impath,'background*.*']);
end
[Imfb2] = dir([Impath,'break*.*']); % gets the "break" image

%% make up indices to simulate concept neurons
% (I think I can completely ignore this for tEMt)
%The logic here is that each image has a code that links it to an object.
%E.g. gstq links to all images of Quenn Elizabeth. So if a neuron responds
% to one particular object, to find all the images corresponding to that
% object the code of that object has to be entered.

% cnx = cell(length(params.concept_neurons),1); % empty 2x1 cell
% for kt = 1:length(params.concept_neurons)
%     [ix,~] = find(strcmp(ID.id, params.concept_neurons(kt))); % first get all
%     ix = unique(ix);
%
%     cnx{kt} = ix;
% end; clear ix;
%
% if isempty(cnx{1}) && isempty(cnx{2})
%
%     for kt = 1:length(params.concept_neurons)
%         [ix] = regexp(ID.id,params.concept_neurons{kt});
%         sel = []; k= 0;
%         for lt = 1:length(ix)
%             if ~isempty(ix{lt})
%                 k = k+1;
%                 sel(k) = lt;
%             end;
%         end;
%
%         cnx{kt} = sel;
%     end;
% end;

%%
%[stim_mat] = organize_stim_mat_concept_neurons(cnx,ID);
% changed 08/07/2016
% %% organize triplet sequences
%[stim_mat] = organize_stim_mat3(cnx,ID); clear cnx;
%if (length(unique(stim_mat.seq(1,:))) == size(stim_mat.seq,2)) ==0
%    error('indices must be unique');
%end;
%%
if strcmp(params.rep,'n')
    [stim_mat] = build_unique_cn_pairs(ID,params);
    
    % randomize sequence order
    rand('state',sum(100*clock));
    ridx = randperm(size(stim_mat.seq,2));
    stim_mat.seq = stim_mat.seq(:,ridx);
    ridx = randperm(size(stim_mat.seq,2));
    stim_mat.seq = stim_mat.seq(:,ridx);
    ridx = randperm(size(stim_mat.seq,2));
    stim_mat.seq = stim_mat.seq(:,ridx);
elseif strcmp(params.rep,'y')
    stim_mat = params.stim_mat;
end

%% generate inter-trial intervals
ntrl = size(stim_mat.seq,2);
[iti1] = generate_iti([1000 2250],ntrl);
[iti2] = generate_iti([250 400],ntrl);

%% save data
params.Impath = Impath; % path to images
params.Imf = Imf; % images
params.Imfb = Imfb; % background
params.Imfb2 = Imfb2; % break image
params.ID = ID; % name and number of images
params.stim_mat = stim_mat;
params.iti1 = iti1;
params.iti2 = iti2;

return;