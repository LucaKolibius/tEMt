function [params] = read_stim_images(params)

%% parameters for progress bar
x = [params.xCenter-150 params.xCenter+150];
y = [params.yCenter-12.5 params.yCenter+12.5];

d = (x(2)-x(1))/length(params.Imf);

%%

params.theImage = cell(length(params.Imf),1);
params.s1 = zeros(length(params.Imf),1);
params.s2 = zeros(length(params.Imf),1);

%%
for kt = 1:length(params.Imf)
    % Here we load in an image from file.
    theImageLocation =  [params.p2f,params.Imf(kt).name];
    [params.theImage{kt},~,ach] = imread(theImageLocation);
    sz =size((params.theImage{kt}));
    
    %theImageLocation2 =  [params.p2f2,params.Imf(kt).name];
    %[params.theImage2{kt},~,ach] = imread(theImageLocation2);
    
    %     if sz(2) > sz(1) % portrait format
    %         if sz(2)>1024 && sz(1) >768
    %             params.theImage{kt} = imresize(params.theImage{kt},[768 1024]);
    %         end
    %     elseif sz(1) > sz(2)
    %
    %         if sz(1)>1024 && sz(2) >768 % landscape format
    %             params.theImage{kt} = imresize(params.theImage{kt},[1024 768]);
    %         end;
    %     end;
    %
    if ~isempty(ach)
        params.theImage{kt}(:,:,4) = ach;
    end
    
    % Get the size of the image
    [params.s1(kt), params.s2(kt), ~] = size(params.theImage{kt});
    
    %% Draw the background image        
    
    if isempty(params.bckimTexture)
        Screen('FillRect',params.window, params.bc_color);
    else
        Screen('DrawTexture', params.window,params.bckimTexture);
    end
    
    Screen('TextSize',  params.window, 40);
    
    Screen('FrameRect', params.window ,params.black,[x(1) y(1) x(2) y(2)], 5);
    Screen('FillRect', params.window ,params.black,[x(1) y(1) x(1)+(d.*kt) y(2)], 5);
    DrawFormattedText( params.window, 'Loading','center',  params.yCenter-100, [.25 .25 .25]);
    
    % Flip to the screen
    Screen('Flip', params.window);
    
end

%% check if the image is too big to fit on the screen and abort if
% it is. See ImageRescaleDemo to see how to rescale an image.
% if any(params.s1 > params.screenYpixels) || any(params.s2 > params.screenXpixels)
%     disp('ERROR! Image is too big to fit on the screen');
%     sca;
%     return;
% end;

%% sanitiy check
if isfield(params,'stim_mat')
    x = {};for it = 1:size(params.stim_mat.seq,2);x{it}=params.Imf(params.stim_mat.seq(1,it)).name;end;
    if length(unique(x)) ~= size(params.stim_mat.seq,2);error('array must not contain duplicate images');end;
end
return;