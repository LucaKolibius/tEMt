function [centeredRectT] = compute_target_position(params)
%%
% position of the 1st pair
centeredRectT(1,:) = CenterRectOnPointd(params.baseRect, params.xCenter-params.xoff2,2*params.offs + params.baseRect(end)*2);
centeredRectT(2,:) = CenterRectOnPointd(params.baseRect, params.xCenter+params.xoff2, 2*params.offs + params.baseRect(end)*2);

% position of the 2nd pair
centeredRectT(3,:) = CenterRectOnPointd(params.baseRect, params.xCenter-params.xoff2, 3*params.offs + params.baseRect(end)*3);
centeredRectT(4,:) = CenterRectOnPointd(params.baseRect, params.xCenter+params.xoff2, 3*params.offs + params.baseRect(end)*3);

% position of the 3rd pair
centeredRectT(5,:) = CenterRectOnPointd(params.baseRect, params.xCenter-params.xoff2, 4*params.offs + params.baseRect(end)*4);
centeredRectT(6,:) = CenterRectOnPointd(params.baseRect, params.xCenter+params.xoff2, 4*params.offs + params.baseRect(end)*4);

% position of the 4th pair
centeredRectT(7,:) = CenterRectOnPointd(params.baseRect, params.xCenter-params.xoff2, 5*params.offs + params.baseRect(end)*5);
centeredRectT(8,:) = CenterRectOnPointd(params.baseRect, params.xCenter+params.xoff2, 5*params.offs + params.baseRect(end)*5);