function [params] = calculate_coordinates(params)
%% image coordinates expressed in pixel position
%[top-left-x top-left-y bottom-right-x bottom-right-y]
params.baseRect = [0 0 params.s2(1) params.s1(1)];

chck = [];x = 1:.25:10;for it= 1:length(x);chck(it) = (params.screenYpixels/(params.s1(1)*x(it))>2.5);end;
scf = x(min(find(chck==0))-1);

params.baseRect2 = params.baseRect.*scf;
params.offs = 0;

%x-offset
chck = [];x= 1:1e3;for it = 1:length(x); chck(it) = (x(it)/(params.screenXpixels-params.xCenter)*100)>30;end;
xoff = x(min(find(chck==1)));
chck = [];x= 1:1e3;for it = 1:length(x); chck(it) = (x(it)/(params.screenXpixels-params.xCenter)*100)>35;end;
xoff2 = x(min(find(chck==1)));
% y-offset
chck = [];x= 1:1e3;for it = 1:length(x); chck(it) = (x(it)/(params.screenYpixels-params.yCenter)*100)>18;end;
yoff = x(min(find(chck==1)));

params.xoff = xoff;
params.xoff2 = xoff2;
params.yoff = yoff;

x =1:1e3;chck = [];for it = 1:length(x);chck(it) = x(it)/(params.screenXpixels-params.xCenter)*100>3;end;
params.offs = x(min(find(chck==1)));

%% image coordinates for cue and targets during encoding
%position of the cue
%params.centeredRect1 = CenterRectOnPointd(params.baseRect, params.xCenter, params.offs + params.baseRect(end));
params.centeredRect1 = CenterRectOnPointd(params.baseRect2, params.xCenter, params.yCenter-xoff);

%position of the 1st target
params.centeredRect2 = CenterRectOnPointd(params.baseRect2, params.xCenter-xoff2, params.yCenter+yoff);
%position of the 2nd target
params.centeredRect3 = CenterRectOnPointd(params.baseRect2, params.xCenter+xoff2, params.yCenter+yoff);

%% image coordinates for cue and targets during retrieval
%[top-left-x top-left-y bottom-right-x bottom-right-y]
% position of the cue
%[params.centeredRectC] = CenterRectOnPointd(params.baseRect, params.xCenter,params.offs + params.baseRect(end));
[params.centeredRectC] = CenterRectOnPointd(params.baseRect, params.xCenter, params.yCenter-xoff);
%positions of the targets

[params.centeredRectT] = compute_target_position(params);

%%
params.Y(1) = params.offs + params.baseRect(end);
params.Y(2) = params.yCenter+yoff;
params.Y(3) = params.yCenter+yoff;

%%
params.X(1) = params.xCenter;
params.X(2) = params.xCenter-xoff2;
params.X(3) = params.xCenter+xoff2;

%%
params.X(4) = params.centeredRect2(1) + (params.centeredRect2(3)- params.centeredRect2(1))/2;
params.X(5) = params.centeredRect3(1) + (params.centeredRect3(3)- params.centeredRect3(1))/2;