%%
x1 = 1:100;

figure;
hold on;
plot([-100 100],[0 0],'k');
plot([0 0],[-1 1],'k');
plot(1./sqrt(x1),'LineWidth',3);
plot(-x1,1./-sqrt(x1),'LineWidth',3);
%%
Fs = 1e3;
t = 0:1/Fs:.5;
sig = sin(2*pi*5.*t);

ntrl = 1;
y1 = zeros(ntrl,length(t));
y2 = zeros(ntrl,length(t));
y3 = zeros(ntrl,length(t));

for jt = 1:ntrl
    for it = 1:length(t)
        
        x = randperm(2);
        
        if x(1) ==1
            y1(jt,it) = 0;
        else
            y1(jt,it)  =1;
        end;
        
        x = randperm(2);
        if x(1) ==1
            y2(jt,it) = 0;
        else
            y2(jt,it)  =1;
        end;
        
        
        
        x = randperm(2);
        if x(1) ==2
            y3(jt,it) = 0;
        else
            y3(jt,it)  =1;
        end;
        
        
    end;
end;
%%
xc1 = zeros(ntrl,101);
xc2 = zeros(ntrl,101);

y4 = zeros(ntrl,length(t));
for it = 1:ntrl
    
    idx3 = find(y3(it,:)==1);
    
    idx4 = idx3+5;
    idx4(idx4>length(t))=[];
    
    y4(it,idx4)=1;
    
    [xc1(it,:),lag1] = xcorr(y2(it,:),y1(it,:),50);
    [xc2(it,:),lag2] = xcorr(y4(it,:),y3(it,:),50);
end;
%%
idx1 = find(y1(1,:)==1);
idx2 = find(y2(1,:)==1);

figure;
subplot(221);
hold on;
plot(t(idx1),y1(1,idx1),'b.');
plot(t(idx2),2.*y2(1,idx2),'r.');
axis tight;
ylim([0 3]);
xlim([0 .1]);
axis off;

subplot(223);
hold on;
plot(t(idx3),y3(1,idx3),'b.');
plot(t(idx4),2.*y4(1,idx4),'r.');
axis tight;
ylim([0 3]);
xlim([0 .1]);
axis off;

subplot(222);
a = gca;
bar(lag1./Fs.*1000,mean(xc1,1));
axis tight;
xlabel('Lag [ms]');
ylabel('Spike count/ms');

subplot(224);
a = [a gca];
bar(lag2./Fs.*1000,mean(xc2,1));
axis tight;
xlabel('Lag [ms]');
ylabel('Spike count/ms');

ax = get(a(2),'YLim');

set(a,'YLim',ax);
%%
Fs = 1e3;
t = 0:1/Fs:.5;
sig = sin(2*pi*5.*t);

ntrl = 1;
y1 = zeros(ntrl,length(t));
y2 = zeros(ntrl,length(t));
y3 = zeros(ntrl,length(t));

for jt = 1:ntrl
    for it = 1:length(t)
        
        x = randperm(2);
        if sign(sig(it))==-1
            if x(1) ==1
                y1(jt,it) = 0;
            else
                y1(jt,it)  =1;
            end;
            
            x = randperm(2);
            if x(1) ==1
                y2(jt,it) = 0;
            else
                y2(jt,it)  =1;
            end;
        end;
        
        if sign(sig(it))==1
            x = randperm(2);
            if x(1) ==2
                y3(jt,it) = 0;
            else
                y3(jt,it)  =1;
            end;
        end;
        
    end;
end;
%%
xc1 = zeros(ntrl,101);
xc2 = zeros(ntrl,101);

y4 = zeros(ntrl,length(t));
for it = 1:ntrl
    
    idx3 = find(y3(it,:)==1);
    
    idx4 = idx3+5;
    idx4(idx4>length(t))=[];
    
    y4(it,idx4)=1;
    
    [xc1(it,:),lag1] = xcorr(y2(it,:),y1(it,:),50);
    [xc2(it,:),lag2] = xcorr(y4(it,:),y3(it,:),50);
end;
%%
phi = angle(hilbert(sig));
pbins = -pi:pi/4:pi;

m1 = zeros(length(pbins),1);
m2 = zeros(length(pbins),1);
m3 = zeros(length(pbins),1);
m4 = zeros(length(pbins),1);
for kt = 1:length(pbins)-1
    
    idx = find(phi >= pbins(kt) & phi < pbins(kt+1));
    
    m1(kt) = sum(y1(1,idx));
    m2(kt) = sum(y2(1,idx));
    m3(kt) = sum(y3(1,idx));
    m4(kt) = sum(y4(1,idx));
    
end;
m1(end) = m1(1);
m2(end) = m2(1);
m3(end) = m3(1);
m4(end) = m4(1);
%%
idx1 = find(y1(1,:)==1);
idx2 = find(y2(1,:)==1);
idx3 = find(y3(1,:)==1);

figure;
subplot(331);
plot(t,sig,'k');
axis off;
subplot(334);
hold on;
plot(t(idx1),y1(1,idx1),'b.');
plot(t(idx2),2.*y2(1,idx2),'r.');
axis tight;
ylim([0 3]);
xlim([t(1) t(end)]);
axis off;

subplot(337);
hold on;
plot(t(idx3),y1(1,idx3),'b.');
plot(t(idx4),2.*y4(1,idx4),'r.');
axis tight;
ylim([0 3]);
xlim([t(1) t(end)]);
axis off;

subplot(335);
a = gca;
bar(lag1./Fs.*1000,mean(xc1,1));
axis tight;
xlabel('Lag [ms]');
ylabel('Spike count/ms');

subplot(338);
a = [a gca];
bar(lag2./Fs.*1000,mean(xc2,1));
axis tight;
xlabel('Lag [ms]');
ylabel('Spike count/ms');

ax = get(a(2),'YLim');

set(a,'YLim',ax);

subplot(336);
hold on;
plot(pbins,m1,'b');
plot(pbins,m2,'r');
axis tight;
xlabel('Phase [rad]');
ylabel('Spike Count');

subplot(339);
hold on;
plot(pbins,m3,'b');
plot(pbins,m4,'r');
axis tight;
xlabel('Phase [rad]');
ylabel('Spike Count');