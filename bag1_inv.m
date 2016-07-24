function gamma_dyn = bag1_inv(bag1_activation,L,Ldot,Lddot,dt)
%
%       THIS FUNCTION INVERTS THE MODEL OF BAG1 INTRAFUSAL FIBER
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
    LN_sr = 0.0423;
    beta0 = 0.0605;
    beta1 = 0.2592;
    gamma1 = 0.0289;
    tau = 0.149;
    G = 20000;
    refractoryPeriod = 2e-3;
    
%   CALCULATE TENSION FROM THE ACTIVATION POTENTIAL    
    T = Ksr*(bag1_activation/G + LN_sr - L0_sr);
    Tdot = ddt(T,dt);
    Tddot = ddt(Tdot,dt);
    %Tdot = Tdot_bag1.Data;
    %Tddot = Tddot_bag1.Data;
    
    C = Ldot;
    C(Ldot-Tdot/Ksr>=0) = CL;
    C(Ldot-Tdot/Ksr<0) = CS;

%   CALCULATE AN ESTIMATE OF DYNAMIC FUSIMOTOR DRIVE BY INVERTING THE
%   SPINDLE MODEL (TURNS OUT TO BE A SIMPLE LINEAR COMBINATION OF KNOWN TERMS)
    fout = M/Ksr*Tddot - M*Lddot + T - Kpr*(L - L0_sr - T/Ksr - L0_pr);
    const1 = C.*sign(Ldot - Tdot/Ksr).*(abs(Ldot - Tdot/Ksr).^a).*(L-L0_sr-T/Ksr-R);
    fout = (fout - beta0*const1)./(gamma1 + beta1*const1);
    
    gamma_dyn = ddt(fout,dt)*tau + fout;
    
    gamma_dyn = (gamma_dyn*3600./(1-gamma_dyn)).^0.5;
    gamma_dyn(gamma_dyn>1/refractoryPeriod) = 1/refractoryPeriod;