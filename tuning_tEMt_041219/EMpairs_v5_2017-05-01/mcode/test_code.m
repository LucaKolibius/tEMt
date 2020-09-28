%%
try
    %% Clear the workspace and the screen
    sca;
    close all;
    clearvars;
    %%
    addpath('/home/rouxf/MATLAB/EMexp/');
    [stim_mat,Imf,Impath,ID,iti] = set_up_stimuli;
    %% call some default settings for setting up Psychtoolbox
    PsychDefaultSetup(2);
    %% set buttons
    SetExpButtons;
    %% Get the screen numbers
    screens = Screen('Screens');
    
    % Draw to the external screen if avaliable
    screenNumber = max(screens);
    
    % Define black and white
    white = WhiteIndex(screenNumber);
    black = BlackIndex(screenNumber);
    grey = white / 2;
    inc = white - grey;
    
    % Open an on screen window
    [window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey);
    
    % Get the size of the on screen window
    [screenXpixels, screenYpixels] = Screen('WindowSize', window);
    
    % Query the frame duration
    ifi = Screen('GetFlipInterval', window);
    
    % Get the centre coordinate of the window
    [xCenter, yCenter] = RectCenter(windowRect);
    
    % Set up alpha-blending for smooth (anti-aliased) lines
    Screen('BlendFunction', window, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');
    %% load in an images from file
    theImage = cell(length(Imf),1);
    s1 = zeros(length(Imf),1);
    s2 = zeros(length(Imf),1);
    for kt = 1:length(Imf)
        % Here we load in an image from file.
        theImageLocation =  [Impath,Imf(kt).name];
        theImage{kt} = imread(theImageLocation);
        
        % Get the size of the image
        [s1(kt), s2(kt), ~] = size(theImage{kt});
        
    end;
    %% partition the stimulus material into triplets
    nImages = length(theImage);
    nStims = 3;
    
    [p] = make_stim_partition(nImages,nStims);
    %% image coordinates expressed in pixel position
    %[top-left-x top-left-y bottom-right-x bottom-right-y]
    baseRect = [0 0 s2(1) s1(1)];
    centeredRect1 = CenterRectOnPointd(baseRect, xCenter, yCenter-250);
    centeredRect2 = CenterRectOnPointd(baseRect, xCenter-350, yCenter+100);
    centeredRect3 = CenterRectOnPointd(baseRect, xCenter+350, yCenter+100);
    %% check if the image is too big to fit on the screen and abort if
    % it is. See ImageRescaleDemo to see how to rescale an image.
    if any(s1 > screenYpixels) || any(s2 > screenYpixels)
        disp('ERROR! Image is too big to fit on the screen');
        sca;
        return;
    end;
    %% loop over the number of triplets
    for jt = 1:size(stim_mat.seq,2)
        %% make imagoe to texture and get indices of each texture
        imageTexture = zeros(3,1);
        
        for kt = 1:3
            imageTexture(kt) = Screen('MakeTexture', window, theImage{stim_mat.seq(kt,jt)});
        end;
        %% Draw the images to the screen
        % Make the image into a texture        
        Screen('DrawTexture', window, imageTexture(1),[],  centeredRect1, 0);          
        % Flip to the screen
        Screen('Flip', window);
        % Wait for two seconds
        WaitSecs(.5);
        
        Screen('DrawTexture', window, imageTexture(1),[],  centeredRect1, 0);        
        Screen('Close', imageTexture(1));     
        Screen('DrawTexture', window, imageTexture(2),[],  centeredRect2, 0);
        Screen('Close', imageTexture(2));
        Screen('DrawTexture', window, imageTexture(3),[],  centeredRect3, 0);
        Screen('Close',imageTexture(3));
        
        % Flip to the screen
        Screen('Flip', window);
        
        % Wait for two seconds
        WaitSecs(1);
        
        % Now fill the screen green
        Screen('FillRect', window, grey);
        
        % Flip to the screen
        Screen('Flip', window);
        
        % Wait for two seconds
        WaitSecs(iti(jt));
    end;
    % Clear the screen
    sca;
catch
    sca;
    %Screen('Close',imageTexture(:));
    error('program aborted');    
end;