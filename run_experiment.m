function corr = run_experiment(subject,stg,trial,fit,count)

    Tsim = 0.7;

    dt = 0.001;
    t = 0:dt:Tsim;
    t = t';

    load('nFileDat.mat');
    L = 1 + nFileDat(subject).stage(stg).dat(trial,:,1)'/81;
    Ldot = nFileDat(subject).stage(stg).dat(trial,:,2)'/81;
    Lddot = nFileDat(subject).stage(stg).dat(trial,:,3)'/81;
    secondary_afferent = firing_rate(nFileDat(subject).stage(stg).dat(1:2,:,6)',dt,Tsim,25,fit);
    primary_afferent = zeros(size(t));

    [gamma_dyn_est,gamma_stat_est] = inverse_spindle(L,Ldot,Lddot,primary_afferent,secondary_afferent,Tsim,dt);
    [primary_afferent_est,secondary_afferent_est] = spindle(L,Ldot,Lddot,gamma_dyn_est,gamma_stat_est,Tsim,dt);
    primary_afferent_est = primary_afferent_est/3.4;
    secondary_afferent_est = secondary_afferent_est/3.3;

    fig = figure(count);
    set (fig, 'Units', 'normalized', 'Position', [0,0,1,1]);
    fig.Name = ['Subject:',num2str(subject),' Stage:',num2str(subject),' Trial:',num2str(subject)];
    subplot(231)
    plot(t,L);
    title('Muscle Length')
    subplot(232)
    plot(t,Ldot);
    title('Muscle Velocity')
    subplot(233)
    plot(t,Lddot);
    title('Muscle Acceleration');
    subplot(234)
    plot(t,secondary_afferent);
    hold on;
    plot(t,secondary_afferent_est);
    title('Secondary Afferent');
    legend('Original','Re-calculated');
    subplot(235)
    plot(t,primary_afferent);
    hold on;
    plot(t,primary_afferent_est)
    title('Primary Afferent');
    legend('Original','Re-calculated');

    corr = corrcoef(secondary_afferent(200:end),secondary_afferent_est(200:end));
    corr = corr(1,2);
end