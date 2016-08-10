Tsim = 0.7;

%sim('Signals',Tsim);
dt = 0.001;
t = 0:dt:Tsim;
t = t';

tx = 0:0.001:Tsim;
tx = tx';

stg = 4;
load('nFileDat.mat');
L = 1 + mean([nFileDat(1).stage(stg).dat(1:3,:,1);nFileDat(3).stage(stg).dat(1:3,:,1);nFileDat(5).stage(stg).dat(1:3,:,1);nFileDat(11).stage(stg).dat(1:3,:,1)]',2)/81;
Ldot = mean([nFileDat(1).stage(stg).dat(1:3,:,2);nFileDat(3).stage(stg).dat(1:3,:,2);nFileDat(5).stage(stg).dat(1:3,:,2);nFileDat(11).stage(stg).dat(1:3,:,2)]',2)/81;
Lddot = mean([nFileDat(1).stage(stg).dat(1:3,:,3);nFileDat(3).stage(stg).dat(1:3,:,3);nFileDat(5).stage(stg).dat(1:3,:,3);nFileDat(11).stage(stg).dat(1:3,:,3)]',2)/81;
secondary_afferent = firing_rate([nFileDat(1).stage(stg).dat(1:3,:,6);nFileDat(3).stage(stg).dat(1:3,:,6);nFileDat(5).stage(stg).dat(1:3,:,6);nFileDat(11).stage(stg).dat(1:3,:,6)]',dt,Tsim,10,1);
%secondary_afferent = temp;
%secondary_afferent = spline(x,y,t);
primary_afferent = zeros(size(t));

[gamma_dyn_est,gamma_stat_est] = inverse_spindle(L,Ldot,Lddot,primary_afferent,secondary_afferent,Tsim,dt);

figure(1)
plot(t,gamma_dyn_est);
title('Dynamic Fusimotor Drive');
hold on

figure(2)
plot(t,gamma_stat_est);
title('Static Fusimotor Drive');
hold on

[primary_afferent_est,secondary_afferent_est] = spindle(L,Ldot,Lddot,gamma_dyn_est,gamma_stat_est,Tsim,dt);
primary_afferent_est = primary_afferent_est/3.4;
secondary_afferent_est = secondary_afferent_est/3.3;

figure(3)
plot(t,primary_afferent);
hold on;
plot(t,primary_afferent_est)
title('Primary Afferent');
legend('Original','Re-calculated');

figure(4)
plot(t,secondary_afferent);
hold on;
plot(t,secondary_afferent_est);
title('Secondary Afferent');
legend('Original','Re-calculated');

figure(5)
plot(t,L);
title('Muscle Length');

figure(6)
subplot(221)
plot(t,Ldot);
title('Muscle Velocity')
subplot(222)
plot(t,Lddot);
title('Muscle Acceleration');
subplot(223)
plot(t,secondary_afferent);
hold on;
plot(t,secondary_afferent_est);
title('Secondary Afferent');
legend('Original','Re-calculated');
subplot(224)
plot(t,primary_afferent);
hold on;
plot(t,primary_afferent_est)
title('Primary Afferent');
legend('Original','Re-calculated');