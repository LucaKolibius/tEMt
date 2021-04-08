function [params] = run_encoding(params)
%% ENCODING
% loop over the number of triplets
params.ot = cell(1,3);
params.enc_id = cell(2,1);

%%
vbl = Screen('Flip', params.window);
params.Enc.vbl = vbl;

%% ITI
iti_trial(params, params.Enc);

%%
for encTrl = params.encTrl : length(params.trl_idx) % this...
    % saving params
    params.encTrl = encTrl;
    get_clock_time;
    
    if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
        save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params') % .. and this is my crash insurance
    end
    %% make image to texture and get indices of each texture
    imageTexture = zeros(2,1);
    for kt = 1:2 % first the cue, then the associate
        imageTexture(kt) = Screen('MakeTexture', params.window, params.theImage{params.stim_mat.idx(params.stim_mat.seq(kt,params.trl_idx(encTrl)))});
        params.enc_id{kt} = params.Imf(params.stim_mat.idx(params.stim_mat.seq(kt,params.trl_idx(encTrl)))).name;
    end
    
    %% send out TTL
%     if ~strcmp(params.trg, 'debug') % if it is not in debug mode it sends a trigger and notes the time for the logfile
%         send_ttl(params, params.enctrig); [params.ot(1)] = {num2str(GetSecs)}; %onset of cue
%     else % if it is in debug mode it only notes down the time
        [params.ot(1)] = {num2str(GetSecs)};
%     end
    
    %%
    if ~isempty(params.bckimTexture)
        
        %         %% Draw the cue image to the screen
        %         Priority(params1.topPriorityLevel);
        %         for frame = 1:params1.numFrames(1)
        %
        %             Screen('DrawTexture', params1.window,params1.bckimTexture);% Make the image into a texture
        %             Screen('TextSize', params1.window, 120);
        %             DrawFormattedText( params1.window, '.', params1.xCenter+1, params1.yCenter-25, [1 0 0]);
        %             Screen('DrawTexture', params1.window, imageTexture(1), [], params1.centeredRect1, 0);
        %
        %             % Tell PTB no more drawing commands will be issued until the next flip
        %             Screen('DrawingFinished', params1.window);
        %
        %             % Flip to the screen
        %             vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
        %
        %         end
        %
        %         %% Draw the pair images to the screen
        %         %vbl = Screen('Flip', params1.window);
        %         [params1.ot(2)] = {num2str(GetSecs)};
        %         for frame = 1:params1.numFrames(2)
        %
        %             Screen('DrawTexture', params1.window,params1.bckimTexture);
        %             Screen('TextSize', params1.window, 120);
        %             DrawFormattedText( params1.window, '.', params1.xCenter+1, params1.yCenter-25, [1 0 0]);
        %
        %             Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
        %             Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
        %             Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
        %
        %             % Tell PTB no more drawing commands will be issued until the next flip
        %             Screen('DrawingFinished', params1.window);
        %
        %             % Flip to the screen
        %             vbl = Screen('Flip', params1.window, vbl + (params1.waitframes - 0.5) * params1.ifi);
        %         end
        %         Priority(0);
        %
        %         %% display the rating
        %         Screen('DrawTexture', params1.window,params1.bckimTexture);
        %         Screen('TextSize', params1.window, 120);
        %         DrawFormattedText( params1.window, '.', params1.xCenter+1,  params1.yCenter+params1.Yoffs, [1 0 0]);
        %
        %         Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
        %         Screen('DrawTexture', params1.window, imageTexture(2),[],  params1.centeredRect2, 0);
        %         Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
        %
        %         Screen('TextSize', params1.window, 40);
        %         DrawFormattedText( params1.window, 'Plausible', 'center' , params1.Y(2) , [.25 .25 .25]);
        %         DrawFormattedText( params1.window, 'Implausible', 'center' , params1.Y(3)+50 , [.25 .25 .25]);
        %
        %
        %         % Flip to the screen
        %         Screen('Flip',  params1.window);
        
    else % if there is no background defined
        
        %% Draw the cue
        Priority(params.topPriorityLevel);
        for frame = 1:params.Enc.numFrames(1)
            
            Screen('FillRect',params.window, params.bc_color);
            Screen('TextSize', params.window, 120);
            DrawFormattedText( params.window, '.', params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
            
            Screen('DrawTexture', params.window, imageTexture(1), [], params.centeredRect1, 0);
            
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params.window, vbl + (params.Enc.waitframes - 0.5) * params.ifi);
            
        end
%         if strcmp(params.trg, 'ttl')
%             send_ttl(params,0); %offset of cues
%         end
        
        %% Draw the associate image on the screen
        tStart = zeros(1,params.Enc.numFrames(1));
        %vbl = Screen('Flip', params1.window);
        for frame = 1:params.Enc.numFrames(1)
            
            Screen('FillRect',params.window, params.bc_color);
            Screen('TextSize', params.window, 120);
            DrawFormattedText( params.window, '.', params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
            
            %             Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
            Screen('DrawTexture', params.window, imageTexture(2),[],  params.centeredRect2, 0);
            %             Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
            
            % Tell PTB no more drawing commands will be issued until the next flip
            Screen('DrawingFinished', params.window);
            
            % Flip to the screen
            vbl = Screen('Flip', params.window, vbl + (params.Enc.waitframes - 0.5) * params.ifi);
            tStart(frame) = vbl;
        end
        Priority(0);
        
        %% Add the rating
        Screen('FillRect',params.window, params.bc_color);
        Screen('TextSize', params.window, 120);
        DrawFormattedText( params.window, '.', params.xCenter,  params.yCenter+params.Yoffs, [1 0 0]);
        
        %         Screen('DrawTexture', params1.window, imageTexture(1),[],  params1.centeredRect1, 0);
        %         Screen('DrawTexture', params1.window, imageTexture(2),[],
        %         params1.centeredRect2, 0); % we also don't want to have the
        %         associate be on the screen after 2s
        %         Screen('DrawTexture', params1.window, imageTexture(3),[],  params1.centeredRect3, 0);
        
        Screen('TextSize', params.window, 40);
        DrawFormattedText( params.window, params.encoding.a, 'center' , params.Y(2) , [.25 .25 .25]);
        DrawFormattedText( params.window, params.encoding.b, 'center' , params.Y(3)+75 , [.25 .25 .25]);
        
        % Flip to the screen
        Screen('Flip',  params.window);
        
    end
    
    %% poll response and wirte response to output
    resp.response = NaN;
    resp.rt = NaN;
    
    %     if strcmp(params.debugmode,'no') || strcmp(params.debugmode,'mode2')
    f=0;
    %         tStart = GetSecs;
    while f<1
        [resp.response,resp.rt] = get_response(1,tStart(1),params.btns);
        KbReleaseWait;
        GpWait(params.btns);
        if (resp.response==1) || (resp.response==3)
            f=1;
        end
    end
    %     end
    %     [params1.ot(3)] = {num2str(GetSecs)};
    [params.ot(2)] = {num2str(tStart(1))};
    [params.ot(3)] = {num2str(tStart(1)+resp.rt)};
    
    Screen('Close',imageTexture(1));
    Screen('Close',imageTexture(2));
    %     Screen('Close',imageTexture(3));
    
    [out] = create_encoding_output(params,resp,params.trl_idx(encTrl));
    
    if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
        write_output2log(params,out);
    end
    %% ITI
    iti_trial(params, params.Enc);
    
end
params.encTrl = 1; % reset trial counter for next block to begin at 1
params.flag1 = 0; % set flag to 0 indicating finished encoding block
get_clock_time; % saving params

if ~strcmp(params.trg, 'debug') % don't need to save in debuge mode
    save([params.savep,params.data_ID,'_',date,'_',ct,'_params_aborted.mat'],'params')
end
end % end of function
