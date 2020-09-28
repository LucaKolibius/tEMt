%% simulate subject performance
% psychometric function of mem-performance
xx = 1:2:20;
fx = 1./sqrt((xx));
sp = [1 1 fx]; 
np = 1:length(xx)+2;

[optdiff] = find(sp>= .5 & sp <.7);
[indtrsh] = sp(optdiff);
%% parameters for adaptive difficulty
t = [.1 .1];% change treshold [hits misses]
r = [1 1];% change rate [hits misses]
%% simulate performance fluctuations
sd = 0.1;% assumed variability
tpt = 15;% duration of encoding trial in seconds
%% simulation loops
nsim = 1;
ntrl = 25;% number of encoding blocks (item-pairs);
%% preallocate for logging
P1 = zeros(nsim,ntrl);
P2 = zeros(nsim,ntrl);
%%
for kt = 1:nsim
    
    [cp] = optdiff*ones(1,ntrl);% vector of performance value for each encoding trial
    [x] = zeros(1,ntrl);
    
    for it = 1:ntrl% loop over each encongding trial
        
        x(it) = sp(find(cp(it)==np)) + sd*randn(1,1);% simulate behavior
        
        if it>2 && it < ntrl            
            
            %measure deviation from the desired level
            [sc,d] = staircase([indtrsh x(it)],t);
            
            if sc ==1% increase difficulty
                cp(it+1) = cp(it)+sc*r(1);
                r(1) = floor(d*5);
            else
                if cp(it-1)>1% decrease difficulty
                    r(2) = floor(d*5);
                    cp(it+1) = cp(it)+sc*r(2);
                end;
            end;
            
        end;
                        
    end;
    P1(kt,:) = cp;
    P2(kt,:) = x;
    
end;
%%
td =sum(mean(P1).*tpt)/60 + sum(np.*tpt)/60;
%%
figure; 

subplot(321);
hold on;
plot([1 length(sp)],[indtrsh indtrsh],'r--');
plot(np,sp,'bs-');
axis tight;
xlabel('Number of presented pairs');
ylabel('% retrieved pairs');

subplot(323);
errorbar(1:ntrl,mean(P2,1),std(P2,0,1),'b.-');%./sqrt(size(P2,1)-1)
axis tight;
xlabel('Encoding blocks');
ylabel('% retrieved pairs');

subplot(324);
hold on;
errorbar(1:ntrl,mean(P1,1),std(P1,0,1),'b.-');%./sqrt(size(P1,1)-1)
xlabel('Encoding blocks');
ylabel('Number of presented pairs');
axis tight;
ylim([0 max(mean(P1,1))+2]);

subplot(325);
[n,w] = hist(mean(P2,1));
hold on;
bar(w,n);
plot(mean(mean(P2,1))*ones(1,2),[0 max(n)],'r--');
axis tight;
xlabel('% retrieved pairs');
ylabel('Count');

subplot(326);
ctrl = sum((mean(P1.*P2,1)));
nctrl = sum(mean(P1,1))-sum((mean(P2.*P1,1)));
bar([1 2],[ctrl nctrl]);
axis tight;
set(gca,'XTickLabel',{'Hits' 'Misses'});
ylabel('Count');
title(['Duration:',num2str(round(td*10)/10),'m']);