function [params] = read_bckgrnd_image(params,sel)    
% modified 26/04/2017 by FRO to keep break icon independent from background
% image

%% background image
params.bckimTexture = [];
if strcmp(sel,'y')
    if ~isempty(params.Imfb)
        Ip = [params.basepath,filesep,'image_data',filesep,'background',filesep];
        theImageLocation =  [Ip,params.Imfb.name];
        [bckim,~,ach] = imread(theImageLocation);
        [s1, s2, ~] = size(bckim);
        if ~isempty(ach)
            bckim(:,:,4) = ach;
        end;
        %% check if the image is too big to fit on the screen and abort if
        % it is. See ImageRescaleDemo to see how to rescale an image.
        if s1 > params.screenYpixels || s2 > params.screenXpixels
            disp('ERROR! Image is too big to fit on the screen');
            sca;
            return;
        end;
        params.bckimTexture = Screen('MakeTexture', params.window, bckim);
    end;
end;

%% break icon
if ~isempty(params.Imfb2)
    Ip = [params.basepath,filesep,'image_data',filesep,'background',filesep];
    theImageLocation =  [Ip,params.Imfb2.name];
    [bckim2,~,ach] = imread(theImageLocation);
    
    [s1, s2, ~] = size(bckim2);
    if ~isempty(ach)
        bckim2(:,:,4) = ach;
    end;
    %% check if the image is too big to fit on the screen and abort if
    % it is. See ImageRescaleDemo to see how to rescale an image.
    if s1 > params.screenYpixels || s2 > params.screenXpixels
        disp('ERROR! Image is too big to fit on the screen');
        sca;
        return;
    end;       
    params.bckimTexture2 = Screen('MakeTexture', params.window, bckim2);
    
end;