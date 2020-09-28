function [sc,d] = staircase(x,t)

%%
sc = 0;
%%
d = x(2)-x(1);%difference between reference value and measured value

if  (sign(abs(d)-t(1))==1)
    sc = sign(d);
end;


return;