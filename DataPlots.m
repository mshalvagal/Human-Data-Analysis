load('nFileDat.mat');

subject = 1;
stg = 1;
Tsim = 0.7;
dt = 0.001;
t = 0:dt:Tsim;
t = t';

figure(1)
plot(1+nFileDat(subject).stage(stg).dat(1:3,:,1)'/81)
legend('1','2','3','4','5','6')

figure(2)
plot(firing_rate(nFileDat(subject).stage(stg).dat(1,:,6)',dt,Tsim,25))
hold on
plot(firing_rate(nFileDat(subject).stage(stg).dat(2,:,6)',dt,Tsim,25))
plot(firing_rate(nFileDat(subject).stage(stg).dat(3,:,6)',dt,Tsim,25))
legend('1','2','3','4','5','6')

%%
figure(3)
plot(ddt(nFileDat(subject).stage(stg).dat(1,:,6)',dt))
hold on;
plot(ddt(nFileDat(subject).stage(stg).dat(2,:,6)',dt))
plot(ddt(nFileDat(subject).stage(stg).dat(3,:,6)',dt))
legend('1','2','3','4','5','6')

figure(4)
plot(nFileDat(subject).stage(stg).dat(1:3,:,6)')
legend('1','2','3','4','5','6')

%L = [nFileDat(1).stage(stg).dat(:,:,1);nFileDat(3).stage(stg).dat(:,:,1);nFileDat(5).stage(stg).dat(:,:,1);nFileDat(11).stage(stg).dat(:,:,1)]';
L = nFileDat(subject).stage(stg).dat(:,:,1)';
L = 1 + L/81;

L = L(end,:) - L(1,:);
secondary_afferent = nFileDat(11).stage(stg).dat(:,:,6)';
slopes = zeros(1,size(secondary_afferent,2));
ss = slopes;

for index = 1:size(secondary_afferent,2)
        secondary_afferent(:,index) = abs(ddt(secondary_afferent(:,index),dt));
        secondary_afferent(secondary_afferent(:,index)<10,index) = 0;
        temp = zeros(size(secondary_afferent(:,index)));
        t2 = 1;
        i = 2;
        while(i<=length(secondary_afferent(:,index))-5)
            if secondary_afferent(i,index)>0
                t1 = t2;
                t2 = i;
                temp(t1:t2+5) = 1/(dt*(t2-t1));
                i = i+5;
            else
                temp(i) = temp(i-1);
                i = i+1;
            end
        end
        coeff = polyfit(t(1:300),temp(1:300),1);
        secondary_afferent(:,index) = temp;
        slopes(index) = coeff(1);
        ss(index) = temp(end-10);
end

figure(5)
scatter(L,slopes);

figure(6)
scatter(L,ss);
%%
figure(7)
subplot(2,1,1)
plot(t,secondary_afferent(:,1:3))
subplot(2,1,2)
plot(t,secondary_afferent(:,4:6))
%legend('1','2','3','4','5','6')