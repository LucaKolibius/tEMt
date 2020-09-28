function [params] = calculate_coordinates_tuning(params)
%26/04/2017 - FRO: introduced params.Yoffs to keep consistent with
%iti_trial.m

%% image coordinates expressed in pixel position
%[top-left-x top-left-y bottom-right-x bottom-right-y]
params.baseRect = [0 0 params.s2(1) params.s1(1)];
params.baseRect = [0 0 320 320];
%% image coordinates for cue and targets during encoding
%position of the cue
%params.centeredRect = CenterRectOnPointd(params.baseRect, params.xCenter, params.offs + params.baseRect(end));
params.centeredRect = CenterRectOnPointd(params.baseRect, params.xCenter, params.yCenter-params.Yoffs);
