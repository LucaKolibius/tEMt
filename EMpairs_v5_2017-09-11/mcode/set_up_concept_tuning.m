function [params] = set_up_concept_tuning(params,backgrnd)
%% 
if nargin == 0
    params.p2f = '/home/rouxf/Exp_EM/test/';
    backgrnd = 'n';
    params.nrep = 6;
end;
%% search for and get image file-names
[Impath] = [params.p2f];
[Imf] = dir([Impath,'*.*']);
Imf(1:2) = [];
if isempty(Imf)
    error('no image files detected');
end;

%for it = 1:length(Imf)
%    Imf(it).name(regexp(Imf(it).name,' ')) =[];
%end;

%% get the stimuli
ID = cell(1,length(Imf));
for it = 1:length(Imf)
    [~,fn,~] = fileparts(Imf(it).name);
    %fn(regexp(fn,' ')) = [];%remove white spaces in file name
    [ID{it}] = fn;
end;

%% pseudo randomize stimuli sequence
%[params.ID,params.idx] = pseudo_randomize(ID,params.nreps);

%% search for a background image
[Imp] = [params.basepath,filesep,'image_data',filesep,'background',filesep];
if strcmp(backgrnd,'y')    
    [Imfb] = dir([Imp,'background*.*']);
    Imfb.name = [];
end;
[Imfb2] = dir([Imp,'break.*']);

%% generate inter-trial intervals
[iti] = generate_iti(params.iti,length(ID));

%% trigger codes of images
%tc = zeros(length(Imf),1);for it = 1:length(Imf);tc(it) = params.basetrig + str2num(Imf(it).name(regexp(Imf(it).name,'\d')));end;

%% save data
params.tc = [];
params.Impath = Impath;
params.Imf = Imf;
params.Imfb2 = Imfb2;

if strcmp(backgrnd,'y')
    params.Imfb = Imfb;    
else
    params.Imfb = [];
end;
params.ID = ID;
params.iti = iti;

return;