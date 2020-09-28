function [params] = read_bckgrbd_image(params)    
%%
    if ~isempty(params.Imfb.name)
        theImageLocation =  [params.Impath,params.Imfb.name];
        [bckim] = imread(theImageLocation);
        [s1, s2, ~] = size(bckim);
        %% check if the image is too big to fit on the screen and abort if
        % it is. See ImageRescaleDemo to see how to rescale an image.
        if s1 > params.screenYpixels || s2 > params.screenXpixels
            disp('ERROR! Image is too big to fit on the screen');
            sca;
            return;
        end;
        params.bckimTexture = Screen('MakeTexture', params.window, bckim);
    end;