function [output] = compute_numFrames(params,d)
% Length of time and number of frames we will use for each drawing test
%old
% function [params] = compute_numFrames(params,d)
% params.numSecs = d;
% params.numFrames = round(params.numSecs ./ params.ifi);
% params.waitframes = 1;

%new
output.numSecs = d;
output.numFrames = round(output.numSecs ./ params.ifi);
output.waitframes = 1;