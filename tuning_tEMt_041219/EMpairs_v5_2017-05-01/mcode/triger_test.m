%%
% prep trigger box
ID  = DaqDeviceIndex;
err = DaqDConfigPort(ID,[],0);

out_ = DaqDOut(ID,0,0); % reset
%%
for it = 1:10
    out_ = DaqDOut(ID,0,7); % send trigger
    WaitSecs(0.1);
    out_ = DaqDOut(ID,0,0); % reset
    WaitSecs(0.1);
end
