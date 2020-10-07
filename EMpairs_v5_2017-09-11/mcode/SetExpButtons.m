function [btns] = SetExpButtons


btns =[];

%----------------------------------------------------------------------
%                       Gampad information
%----------------------------------------------------------------------
KbName('UnifyKeyNames');

% if strcmp(OSName,'Windows')
%     try
%         [btns.x, btns.y, btns.z, btns.w] = WinJoystickMex(0);
%         if ~isempty(btns)
%             btns.gp = 2;
%             btns.ref_aS = [btns.x btns.y btns.z];
%             btns.ref_bS = btns.w;
%         end;
%         if ~isempty(btns.w)
%             btns.gamepadName ='Logitech Logitech(R) Precision(TM) Gamepad';
%         end;
%     catch
%     end;
% else
%     try
%         gp_name ='Logitech Logitech(R) Precision(TM) Gamepad';
%         [btns]= setup_gamepad(gp_name);
%         if ~isempty(btns)
%             btns.gp = 1;
%         end;
%     catch
%     end;
% end;

%----------------------------------------------------------------------
%                       Keyboard information
%----------------------------------------------------------------------
if isempty(btns)
    % Define the keyboard keys that are listened for. We will be using the left
    % and right arrow keys as response keys for the task and the escape key as
    % a exit/reset key
    KbName('UnifyKeyNames');
    btns.escapeKey = KbName('Escape');
    btns.spaceKey = KbName('space');
    btns.rightKey = KbName('RightArrow');
    btns.leftKey = KbName('LeftArrow');
    btns.downKey = KbName('DownArrow');
    btns.upKey = KbName('UpArrow');
    btns.enter = KbName('Return');
    btns.ctrlR = KbName('RightControl');
    btns.zero = KbName('0');
    btns.end = KbName('End');
    btns.minus = KbName('-');
end
% btns.escapeKey = KbName('Escape');

return;