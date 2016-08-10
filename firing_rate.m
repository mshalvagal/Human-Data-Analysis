function out = firing_rate(secondary_afferent,dt,Tsim,order,fit)
    t = (0:dt:Tsim)';
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
        if fit == 1
            secondary_afferent(:,index) = polyval(polyfit(t,temp,order),t);
        else
            secondary_afferent(:,index) = temp;
        end
    end
    out = mean(secondary_afferent,2);