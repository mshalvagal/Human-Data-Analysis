subject = [1,3,5,11];
stg = 1:4;
trial = 1:6;

fit = 1;
corr5 = zeros(length(subject)*length(stg)*length(trial),1);

set(0,'DefaultFigureWindowStyle','docked');
count = 0;
for i = 1:length(subject)
    for j = 1:length(stg)
        for k = 1:length(trial)
            count = count+1;
            corr5(count) = run_experiment(subject(i),stg(j),trial(k),0,count);
        end
    end
end