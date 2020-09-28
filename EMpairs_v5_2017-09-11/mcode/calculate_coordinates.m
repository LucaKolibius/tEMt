function [params] = calculate_coordinates(params)
%% image coordinates expressed in pixel position
%[top-left-x top-left-y bottom-right-x bottom-right-y]
% params.baseRect = [0 0 params.s2(1) params.s1(1)]; % old. dimensions of the first picture in the batch (e.g.: [0 0 183 183]) which determine the presentation dimensions of all stimuli
params.baseRect = [0 0 params.stimSizeX params.stimSizeY];
% params.baseRect2 = params.baseRect.*2.25; % old. I think this lead to enlargement during encoding
params.baseRect2 = params.baseRect; % new
params.offs = 0;



%% image coordinates for cue and targets during encoding
%position of the cue
%params.centeredRect1 = CenterRectOnPointd(params.baseRect, params.xCenter, params.offs + params.baseRect(end));
params.centeredRect1 = CenterRectOnPointd(params.baseRect2, params.xCenter, params.yCenter);
%position of the 1st target
params.centeredRect2 = CenterRectOnPointd(params.baseRect2, params.xCenter, params.yCenter);
% %position of the 2nd target
% params.centeredRect3 = CenterRectOnPointd(params.baseRect2, params.xCenter+350, params.yCenter+100);

%% image coordinates for cue and targets during retrieval
%[top-left-x top-left-y bottom-right-x bottom-right-y]
% position of the cue
%[params.centeredRectC] = CenterRectOnPointd(params.baseRect, params.xCenter,params.offs + params.baseRect(end));
[params.centeredRectC] = CenterRectOnPointd(params.baseRect, params.xCenter, params.yCenter);
%positions of the targets
params.offs = 30;
[params.centeredRectT] = compute_target_position(params);

%%
params.Y(1) = params.offs + params.baseRect(end);
params.Y(2) = params.yCenter+100;
params.Y(3) = params.yCenter+100;

%%
params.X(1) = params.xCenter;
params.X(2) = params.xCenter-350;
params.X(3) = params.xCenter+350;

%%
params.X(4) = params.centeredRect2(1) + (params.centeredRect2(3)- params.centeredRect2(1))/2;
% params.X(5) = params.centeredRect3(1) + (params.centeredRect3(3)- params.centeredRect3(1))/2;