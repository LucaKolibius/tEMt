function [buttonState,axisState] = poll_response_game_pad(gp)
%%
if gp.gp ==1
    buttonState = Gamepad('GetButton', gp.gamepadIndex, 1:gp.numButtons);
    axisState = Gamepad('GetAxis', gp.gamepadIndex, 1:gp.numAxes);
    y = axisState;

    a = sign(diff([gp.ref_aS;y],[],1));
    a = [a(3) a(4)];
    axisState = a;

else
    [x,y,z,buttonState] = WinJoystickMex(0);
    axisState = [x y z];
    y = axisState;
    a = sign(diff([gp.ref_aS;y],[],1));
    a = [a(1) a(2)];
    axisState = a;
end;
%
%a(1) = -1 => left
%a(1) = 1 => right
%a(2) = -1 => up
%a(2) = 1 => down

return