function [params] = compute_numFrames(params,d)
% Length of time and number of frames we will use for each drawing test
params.numSecs = d;
params.numFrames = round(params.numSecs ./ params.ifi);
params.waitframes = 1;