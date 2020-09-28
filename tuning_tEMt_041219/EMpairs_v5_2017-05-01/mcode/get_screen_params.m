function params = get_screen_params(params)

% if strcmp(params.debugmode,'mode1') || strcmp(params.debugmode,'mode2') 
%     window_size = [0 0 900 600];
% end;
%% Get and set screen parameters
params.screens = Screen('Screens');%handle

% Draw to the external screen if avaliable
params.screenNumber = max(params.screens);

% Define black, white & grey
params.white = WhiteIndex(params.screenNumber);
params.black = BlackIndex(params.screenNumber);
params.grey  = GrayIndex(params.screenNumber);
params.inc   = params.white - params.grey;

params.bc_color = [1 1 1];%[.65 .65 .65];%params.grey;

% Open an on screenwindow
[params.window, params.windowRect] = PsychImaging('OpenWindow', params.screenNumber,params.bc_color, []);

% Get the size of the on screen window
[params.screenXpixels, params.screenYpixels] = Screen('WindowSize',params.window);

% Query the frame duration
params.ifi = Screen('GetFlipInterval', params.window);

% Get the centre coordinate of the window
[params.xCenter, params.yCenter] = RectCenter(params.windowRect);

params.ifi = Screen('GetFlipInterval', params.window);

