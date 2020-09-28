function GpWait(gp)
if isfield(gp,'gp')
    f=0;
    while f<1
        if gp.gp==1
            
            buttonState = Gamepad('GetButton', gp.gamepadIndex, 1:gp.numButtons);
            axisState = Gamepad('GetAxis', gp.gamepadIndex, 1:gp.numAxes);
            if sum(buttonState)==0 && sum(axisState(3:5)-gp.ref_aS(3:5))==0
                break;
            end;
            
        else
            [x,y,z,buttonState] = WinJoystickMex(0);
            axisState = [x y z];
            if sum(buttonState)==0 && sum(axisState(1:3)-gp.ref_aS(1:3))==0
                break;
            end;
        end;
    end;
end;
return;