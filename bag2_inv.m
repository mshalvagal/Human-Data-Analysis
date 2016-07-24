function [gamma_stat,T] = bag2_inv(V2,L,Ldot,Lddot,dt)
%
%       THIS FUNCTION INVERTS THE MODEL OF BAG2 INTRAFUSAL FIBER
%
% June 2016
%
    Ksr = 10.4649;
    Kpr = 0.15;
    M = 0.0002;
    CL = 1;
    CS = 0.42;
    a = 0.3;
    R = 0.46;
    L0_sr = 0.04;
    L0_pr = 0.76;
    beta0 = 0.0822;
    beta2 = -0.0460;
    gamma2 = 0.0636;
    tau = 0.205;
    G2 = 7250;
    LN_sr = 0.0423;
    LN_pr = 0.89;
    X = 0.7;
    Lsec = 0.04;
    refractoryPeriod = 2e-3;
    
%   CALCULATE TENSION FROM THE ACTIVATION POTENTIAL
    T = V2/G2 + X*Lsec/L0_sr*(LN_sr - L0_sr) + (1-X)*Lsec/L0_pr*(L0_sr+LN_pr-L);
    T = Ksr*T/(X*Lsec/L0_sr+(X-1)*Lsec/L0_pr);
    %T1 = 10.4649*(V1/10000+0.0423-0.04);
    %T = 0.5*(T+T1);
    
    Tdot = ddt(T,dt);
    Tddot = ddt(Tdot,dt);
    
    C = Ldot;
    C(Ldot-Tdot/Ksr>=0) = CL;
    C(Ldot-Tdot/Ksr<0) = CS;
    
%   CALCULATE AN ESTIMATE OF STATIC FUSIMOTOR DRIVE BY INVERTING THE
%   SPINDLE MODEL (TURNS OUT TO BE A SIMPLE LINEAR COMBINATION OF KNOWN TERMS)
    fout = M/Ksr*Tddot - M*Lddot + T - Kpr*(L - L0_sr - T/Ksr - L0_pr);
    const1 = C.*sign(Ldot - Tdot/Ksr).*(abs(Ldot - Tdot/Ksr).^a).*(L-L0_sr-T/Ksr-R);
    fout = (fout - beta0*const1)./(gamma2 + beta2*const1);
    
    gamma_stat = ddt(fout,dt)*tau + fout;
    
    gamma_stat = (gamma_stat*3600./(1-gamma_stat)).^0.5;
    gamma_stat(gamma_stat>1/refractoryPeriod) = 1/refractoryPeriod;