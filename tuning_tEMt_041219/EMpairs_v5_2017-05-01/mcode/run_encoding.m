function [params1] = run_encoding(params1 ,params2, trl_idx)

%% ENCODING
% loop over the number of triplets
params1.ot = cell(1,3);
params1.enc_id = cell(3,1);

%%
vbl = Screen('Flip', params1.window);
params2.vbl = vbl;

%% ITI
iti_trial(params2);

%%
for jt = 1:length(trl_idx)
    
    %% make imagoe to texture and get indices of each texture
    imageTexture = zeros(3,1);
    for kt = 1:3
        imageTexture(kt) = Screen('MakeTexture', params1.window, params1.theImage{params1.stim_mat.idx(params1.stim_mat.seq(kt,trl_idx(jt)))});
        params1.enc_id{kt} = params1.Imf(params1.stim_mat.idx(params1.stim_mat.seq(kt,trl_idx(jt)))).name;
    end;
    
    %% send out TTL
    [params1.ot(1)] = {num2str(GetSecs)};
    send_ttl(params1,params1.enctrig);%onset of cue
    send_ttl(params1,0);%offset of cues
    
    %%    
    if ~isempty(params1.bckimTexture)

        %% Draw the cue image to the screen
        Priority(params1.topPriorityLevel);
        for frame = 1:params1.numFrames(1)
                                    
            Screen('DrawTexture', params1.window,params1.bckimTexture);% Make the image into a texture
            Screen('TextSize', params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter, params1.yCenter-params1.yoff/4, [1 0 0]);
            Screen('DrawTexture', params1.window, imageTexture(1), [], params1.centeredRect1, 0);
                                    
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params1.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            
        end;
        
        %% Draw the pair images to the screen
        %vbl = Screen('Flip', params1.window);
        [params1.ot(2)] = {num2str(GetSecs)};
        for frame = 1:params1.numFrames(2)                     
            
            Screen('DrawTexture', params1.window,params1.bckimTexture);
            Screen('TextSize', params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter, params1.yCenter-params1.yoff/4, [1 0 0]);
        
            Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
            Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
            Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
                        
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params1.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);            
        end;
        Priority(0);
        
        %% display the rating
        Screen('DrawTexture', params1.window,params1.bckimTexture);
        Screen('TextSize', params1.window, 120);
        DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);

        Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
        Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
        Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);

        Screen('TextSize', params1.window, 40);        
        DrawFormattedText( params1.window, 'Plausible', 'center' , params1.Y(2) , [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Implausible', 'center' , params1.Y(3)+50 , [.25 .25 .25]);
        
        
        % Flip to the screen
        Screen('Flip',  params1.window);
        
    else
        
        %% Draw the cue
        Priority(params1.topPriorityLevel);
        for frame = 1:params1.numFrames(1)
            
            Screen('FillRect',params1.window, params1.bc_color);
            Screen('TextSize', params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            Screen('DrawTexture', params1.window, imageTexture(1), [], params1.centeredRect1, 0);
                        
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params1.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            
        end;        
        
        %% Draw the pair images to the screen
        [params1.ot(2)] = {num2str(GetSecs)};
        %vbl = Screen('Flip', params1.window);
        for frame = 1:params1.numFrames(2)
            
            Screen('FillRect',params1.window, params1.bc_color);
            Screen('TextSize', params1.window, 120);
            DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
            
            Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
            Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
            Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
                                    
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params1.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
            
        end;
        Priority(0);

        %% Add the rating
        Screen('FillRect',params1.window, params1.bc_color);
        Screen('TextSize', params1.window, 120);
        DrawFormattedText( params1.window, '.', params1.xCenter,  params1.yCenter+params1.Yoffs, [1 0 0]);
        
        Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
        Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
        Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);               

        Screen('TextSize', params1.window, 40);
        DrawFormattedText( params1.window, 'Plausible', 'center' , params1.Y(2) , [.25 .25 .25]);
        DrawFormattedText( params1.window, 'Implausible', 'center' , params1.Y(3)+50 , [.25 .25 .25]);
                
        % Flip to the screen
        Screen('Flip',  params1.window);
        
    end;
    
    %% poll response and wirte response to output
    resp.response = NaN;
    resp.rt = NaN;
    
    if strcmp(params1.debugmode,'no') || strcmp(params1.debugmode,'mode2')
        f=0;
        while f<1
            tStart = GetSecs;
            [resp.response,resp.rt] = get_response(1,tStart,params1.btns);
            KbReleaseWait;
            GpWait(params1.btns);
            if (resp.response==1) || (resp.response==3)
                f=1;
            end;
        end;
    end;
    [params1.ot(3)] = {num2str(GetSecs)};
    
    Screen('Close',imageTexture(1));
    Screen('Close',imageTexture(2));
    Screen('Close',imageTexture(3));
    
    [out] = create_encoding_output(params1,resp,trl_idx(jt));
    write_output2log(params1,out);
    
    %% ITI
    iti_trial(params2);
    
end;

