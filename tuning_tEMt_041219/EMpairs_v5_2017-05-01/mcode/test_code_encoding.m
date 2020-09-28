%%
try
    %% Clear the workspace and the screen
    sca;
    close all;
    clearvars;
    %%
    addpath('/home/rouxf/MATLAB/EMexp/');
    [params] = set_up_stimuli;
    [btns] = SetExpButtons;
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
    theImage = cell(length(params.Imf),1);
    s1 = zeros(length(params.Imf),1);
    s2 = zeros(length(params.Imf),1);
    for kt = 1:length(params.Imf)
        % Here we load in an image from file.
        theImageLocation =  [params.Impath,params.Imf(kt).name];
        theImage{kt} = imread(theImageLocation);
        
        % Get the size of the image
        [s1(kt), s2(kt), ~] = size(theImage{kt});
        
    end;
    %% image coordinates expressed in pixel position
    %[top-left-x top-left-y bottom-right-x bottom-right-y]
    baseRect = [0 0 s2(1) s1(1)];
    offs = 5;
    centeredRect1 = CenterRectOnPointd(baseRect, xCenter, offs + baseRect(end));
    centeredRect2 = CenterRectOnPointd(baseRect, xCenter-350, yCenter+100);
    centeredRect3 = CenterRectOnPointd(baseRect, xCenter+350, yCenter+100);
    %% check if the image is too big to fit on the screen and abort if
    % it is. See ImageRescaleDemo to see how to rescale an image.
    if any(s1 > screenYpixels) || any(s2 > screenYpixels)
        disp('ERROR! Image is too big to fit on the screen');
        sca;
        return;
    end;
    %     %% ENCODING
    %     % loop over the number of triplets
    %     for jt = 2%1:size(params.stim_mat.seq,2)
    %         %% make imagoe to texture and get indices of each texture
    %         imageTexture = zeros(3,1);
    %
    %         for kt = 1:3
    %             imageTexture(kt) = Screen('MakeTexture', window, theImage{params.stim_mat.seq(kt,jt)});
    %         end;
    %         %% Draw the images to the screen
    %         % Make the image into a texture
    %         Screen('DrawTexture', window, imageTexture(1),[],  centeredRect1, 0);
    %         % Flip to the screen
    %         Screen('Flip', window);
    %         % Wait for two seconds
    %         WaitSecs(1);
    %
    %         Screen('DrawTexture', window, imageTexture(1),[],  centeredRect1, 0);
    %         Screen('Close', imageTexture(1));
    %         Screen('DrawTexture', window, imageTexture(2),[],  centeredRect2, 0);
    %         Screen('Close', imageTexture(2));
    %         Screen('DrawTexture', window, imageTexture(3),[],  centeredRect3, 0);
    %         Screen('Close',imageTexture(3));
    %
    %         % Flip to the screen
    %         Screen('Flip', window);
    %
    %         % Wait for two seconds
    %         WaitSecs(5);
    %
    %         % Now fill the screen green
    %         Screen('FillRect', window, grey);
    %
    %         % Flip to the screen
    %         Screen('Flip', window);
    %
    %         % Wait for two seconds
    %         WaitSecs(params.iti(jt));
    %     end;
    %% image coordinates expressed in pixel position
    %[top-left-x top-left-y bottom-right-x bottom-right-y]
    baseRect = [0 0 s2(1) s1(1)];
    offs = 5;
    
    centeredRect = [];
    
    % position of the cue
    centeredRectC = CenterRectOnPointd(baseRect, xCenter,offs + baseRect(end));
    
    offs = 30;
    % position of the 1st pair
    centeredRectT(1,:) = CenterRectOnPointd(baseRect, xCenter-350,2*offs + baseRect(end)*2);
    centeredRectT(2,:) = CenterRectOnPointd(baseRect, xCenter+350, 2*offs + baseRect(end)*2);
    
    % position of the 2nd pair
    centeredRectT(3,:) = CenterRectOnPointd(baseRect, xCenter-350, 3*offs + baseRect(end)*3);
    centeredRectT(4,:) = CenterRectOnPointd(baseRect, xCenter+350, 3*offs + baseRect(end)*3);
    
    % position of the 3rd pair
    centeredRectT(5,:) = CenterRectOnPointd(baseRect, xCenter-350, 4*offs + baseRect(end)*4);
    centeredRectT(6,:) = CenterRectOnPointd(baseRect, xCenter+350, 4*offs + baseRect(end)*4);
    
    % position of the 4th pair
    centeredRectT(7,:) = CenterRectOnPointd(baseRect, xCenter-350, 5*offs + baseRect(end)*5);
    centeredRectT(8,:) = CenterRectOnPointd(baseRect, xCenter+350, 5*offs + baseRect(end)*5);
    %% RETRIEVAL
    % loop over the number of triplets
    CM = zeros(size(params.stim_mat.seq,2),4);
    for jt = 2%1:size(para ms.stim_mat.seq,2)
        %% prepare the cue
        
        CueTexture = Screen('MakeTexture', window, theImage{params.stim_mat.seq(1,jt)});% the cue to the orig pair
        %% prepare the targets
        %the orig pair
        OrigTexture(1) = Screen('MakeTexture', window, theImage{params.stim_mat.seq(2,jt)});%
        OrigTexture(2) = Screen('MakeTexture', window, theImage{params.stim_mat.seq(3,jt)});%
        %% prepare the foils
        [foil_idx] = get_foil_indices(params,jt);
        
        FoilTexture = zeros(length(foil_idx),2);
        for kt = 1:length(foil_idx)
            FoilTexture(kt,1) = Screen('MakeTexture', window, theImage{params.stim_mat.seq(2,foil_idx(kt))});
            FoilTexture(kt,2) = Screen('MakeTexture', window, theImage{params.stim_mat.seq(3,foil_idx(kt))});
        end;
        FoilTexture = FoilTexture(:);
        %% flip coin
        oidx =[];
        fc = randperm(length(FoilTexture)+length(OrigTexture));
        oidx(1) = find(fc==1);
        oidx(2) =find(fc==2);
        
        fidx = [];
        fidx = setdiff(1:length(fc),oidx);
        fidx = fidx(randperm(length(fidx)));
        %% Draw the Cue image
        % Make texture
        Screen('DrawTexture', window, CueTexture(1),[],  centeredRectC, 0);
        % Flip to the screen
        Screen('Flip', window);
        % Wait for two seconds
        WaitSecs(1);
        %% Draw text in the upper portion of the screen with the default font in red
        Screen('DrawTexture', window, CueTexture(1),[],  centeredRectC, 0);
        Screen('TextSize', window, 40);
        DrawFormattedText(window, 'How many images that belong here do you remember?', 'center', screenYpixels * 0.35, [.25 .25 .25]);
        Screen('Flip', window);
        %%
        tStart = GetSecs;
        [response1,rt] = get_response(1,tStart,btns);
        KbReleaseWait;
        %% Draw the Cue image
        if response1 >0
            Screen('DrawTexture', window, CueTexture(1),[],  centeredRectC, 0);
            %Screen('Close', CueTexture(1));
            %%  Draw the Targets
            for kt = 1:length(oidx)
                Screen('DrawTexture', window, OrigTexture(kt),[],  centeredRectT(oidx(kt),:), 0);
                %Screen('Close', OrigTexture(kt));
            end;
            %%  Draw the Foils
            for kt = 1:length(fidx)
                Screen('DrawTexture', window, FoilTexture(kt),[],  centeredRectT(fidx(kt),:), 0);
                %Screen('Close', FoilTexture(kt));
            end;
            Screen('FrameRect', window ,black, centeredRectT(fidx(1),:), 5);
            % Flip to the screen
            Screen('Flip', window);
            %imageArray = Screen('GetImage', window, windowRect);
            %%
            tStart = GetSecs;
            [response2,rt] = get_response(1,tStart,btns);
            KbReleaseWait;
            %%
            orig_pos = fidx(1);
            pos = orig_pos;
            final_pos =[];
            f=0;
            while f<1
                if response2 ==0% move left
                    
                    if pos ==2 || pos ==4
                        pos = pos-1;
                    else
                        pos = pos+1;
                    end;
                elseif response2 ==1% move down
                    if pos ==1 || pos ==2
                        pos = pos+2;
                    else
                        pos = pos-2;
                    end;
                elseif response2 ==2% move right
                    if pos ==1 || pos ==3
                        pos = pos+1;
                    else
                        pos = pos-1;
                    end;
                elseif response2 ==3% move up
                    if pos ==3 || pos ==4
                        pos = pos-2;
                    else
                        pos = pos+2;
                    end;
                    
                end;
                %%
                Screen('DrawTexture', window, CueTexture(1),[],  centeredRectC, 0);
                %Screen('Close', CueTexture(1));
                %%  Draw the Targets
                for kt = 1:length(oidx)
                    Screen('DrawTexture', window, OrigTexture(kt),[],  centeredRectT(oidx(kt),:), 0);
                    %Screen('Close', OrigTexture(kt));
                end;
                %%  Draw the Foils
                for kt = 1:length(fidx)
                    Screen('DrawTexture', window, FoilTexture(kt),[],  centeredRectT(fidx(kt),:), 0);
                    %Screen('Close', FoilTexture(kt));
                end;
                %Screen('PutImage', window, imageArray, windowRect);
                Screen('FrameRect', window ,black, centeredRectT(pos,:), 5);
                Screen('Flip', window);
                %%
                tStart = GetSecs;
                [response2,~] = get_response(1,tStart,btns);
                KbReleaseWait;
                if response2 == 4
                    %%
                    final_pos = [final_pos pos];
                    %%
                    Screen('DrawTexture', window, CueTexture(1),[],  centeredRectC, 0);
                    %Screen('Close', CueTexture(1));
                    %%  Draw the Targets
                    for kt = 1:length(oidx)
                        Screen('DrawTexture', window, OrigTexture(kt),[],  centeredRectT(oidx(kt),:), 0);
                        %Screen('Close', OrigTexture(kt));
                    end;
                    %%  Draw the Foils
                    for kt = 1:length(fidx)
                        Screen('DrawTexture', window, FoilTexture(kt),[],  centeredRectT(fidx(kt),:), 0);
                        %Screen('Close', FoilTexture(kt));
                    end;
                    %Screen('PutImage', window, imageArray, windowRect);
                    Screen('FrameRect', window ,white, centeredRectT(pos,:), 5);
                    Screen('Flip', window);
                    Screen('FrameRect', window ,black, centeredRectT(pos,:), 5);
                    Screen('Flip', window);
                    %%
                    if length(final_pos)>1
                            CM(jt,:) = [final_pos oidx];
                            Screen('Close', OrigTexture(:));
                            Screen('Close', OrigTexture(:));
                            Screen('Close', FoilTexture(:));
                        break;
                    end;
                end;
            end;
        end;
        
        %% Draw the ITI image
        % Now fill the screen grey
        Screen('FillRect', window, grey);
        % Flip to the screen
        Screen('Flip', window);
        
        % Wait for ITI duration
        WaitSecs(params.iti(jt));
    end;
    %% END
    % Clear the screen
    sca;
catch
    sca;
    %Screen('Close',imageTexture(:));
    error('program aborted');
end;