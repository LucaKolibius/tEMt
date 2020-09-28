%%

Fs = 10e3;
t = 0:1/Fs:.25;
sig1 = sin(2*pi*5.*t);%+.05.*randn(1,length(t));
%sig2 = sin(2*pi*.35.*t)+.05.*randn(1,length(t));
sig =sig1;%(sig1.*sig2);

% x = conv(sig,gausswin(1/5*Fs));
% d1 = floor((length(x)-length(sig))/2);
% d2 = round((length(x)-length(sig))/2);
% 
% x = x(d2:length(x)-d2);
% x = sign(x)==1;
% x = diff(x);
% 
% idx = [[1 find(x==1)];find(x==-1)];
% 
% m = [min(sig) max(sig)];

figure;
hold on;
% h = zeros(1,size(idx,2));
% for it = 1:size(idx,2)
%     h(it) = area(t(idx(:,it)),[m(2) m(2)],m(1),'ShowBaseline','off');
% end;
%set(h(1:it),'EdgeColor','w');
%set(h(1:it),'FaceColor',[.85 .85 .85]);
plot(t,sig,'k','LineWidth',6);
set(gca,'XTick',0:.2:1);
axis off;
%%
cn = 2:2:12;
N = zeros(length(cn),3);
for kt = 1:length(cn)
    np =cn(kt);
    nnp = np;
    n = np +nnp;
    %%
    l = [ones(1,np) 2*ones(1,nnp)];
    l = 1:length(l);
    %%
    p =zeros(n*(n-1)/2,2);
    k = 0;
    for it = 1:length(l)
        for jt = it+1:length(l)
            k = k+1;
            p(k,:) = [l(it) l(jt)];
            
        end;
    end;
    %%
    np_p = length(intersect(find(p(:,1)<=np),find(p(:,2)<=np)));
    np_m = length(intersect(find(p(:,1)<=np),find(p(:,2)>np)));
    np_np = length(intersect(find(p(:,1)>np),find(p(:,2)>np)));
    %%
    if cn(kt) ==4
       np_p2 = np_p;
       np_m2  = np_m;
       np_np2 = np_np;
       np2 = np;
       nnp2 = nnp;
    end;
    %%
    N(kt,1) = np_p;
    N(kt,2) = np_m;
    N(kt,3) = np_np;
end;
%%
M = zeros(np2+nnp2,np2+nnp2);

for it = 1:length(l)
    if it <=length(l)/2
        M(p(find(p(:,1)==it),2),it) = 1;%l(it);
    else
        M(p(find(p(:,1)==it),2),it) = 2;%l(it);
    end;
end;

figure;
subplot(221);
hold on;
h = imagesc(M);
plot([length(l)/2 length(l)/2]+.5,[1 length(l)/2],'r--','LineWidth',3);
plot([1 length(l)/2],[length(l)/2 length(l)/2]+.5,'r--','LineWidth',3);
plot([length(l)/2 length(l)/2]+.5,[length(l)/2+1 length(l)],'b--','LineWidth',3);
plot([length(l)/2+1 length(l)],[length(l)/2 length(l)/2]+.5,'b--','LineWidth',3);

axis xy;axis tight;
set(gca,'XTick',1:16);
set(gca,'YTick',1:16);
colormap bone;


subplot(222);

bar([1 2 3],[np_p2 np_m2 np_np2]);
set(gca,'YTick',[min([np_p2 np_m2 np_np2]) max([np_p2 np_m2 np_np2])]);
ylabel('Count');
set(gca,'XTickLabel',{'P' 'M' 'NP'});

subplot(223);
hold on;
plot(cn,N(:,1),'rs-');
plot(cn,N(:,2),'ks-');
axis tight;
xlabel('Number of concept neurons')
ylabel('Number of pairwise comparisons');