function [gamma_dyn,bestGamma_stat] = inverse_spindle(L,Ldot,Lddot,primary_afferent,secondary_afferent,Tsim,dt)
%
%       THIS FUNCTION INVERTS THE MODEL OF THE MUSCLE SPINDLE THAT WAS
%       DEVELOPED IN:
%       "Mathematical Models of Proprioceptors. I. Control and Transduction
%       in the Muscle Spindle"
%       AND GIVES AN ESTIMATE OF THE FUSIMOTOR DRIVE AS A FUNCTION OF THE
%       AFFERENT FIRING RATE AND MUSCLE KINEMATICS
%
% June 2016
%

%   MODEL PARAMETERS
    G2 = 10000;
    Ksr = 10.4649;
    L0_sr = 0.04;
    LN_sr = 0.0423;
    S = 0.156;
    refractoryPeriod = 2e-3;

%   THE REFRACTORY PERIOD LIMITS THE FIRING RATES (UNREALISTICALLY HIGH FIRING RATES COULD ARISE FROM MODEL TRANSIENTS)
    primary_afferent(primary_afferent>1/refractoryPeriod) = 1/refractoryPeriod;
    secondary_afferent(secondary_afferent>1/refractoryPeriod) = 1/refractoryPeriod;

    minError = inf;

%   ASSSUMPTION: BAG2 AND CHAIN ARE EACH A FRACTION OF THE SECONDARY FIRING
%   RATE THAT ADD UP TO GIVE THE SECONDARY FIRING RATE.
    for x = 0:0.01:1
        [gamma_stat_bag,T_bag] = bag2_inv(secondary_afferent*x,L,Ldot,Lddot,dt);
        [gamma_stat_chain,T_chain] = chain_inv(secondary_afferent*(1-x),L,Ldot,Lddot,dt);
        error = sum(abs(gamma_stat_bag - gamma_stat_chain));
        if error < minError
            minError = error;
            bestGamma_stat = gamma_stat_chain;
            bestT_bag = T_bag;
            bestT_chain = T_chain;
            bestX = x;
        end
    end
    bestGamma_stat = abs(bestGamma_stat);
    bestGamma_stat(bestGamma_stat>1/refractoryPeriod) = 1/refractoryPeriod;
    
    V_bag2_chain = G2*(bestT_bag/Ksr + bestT_chain/Ksr + 2*L0_sr - 2*LN_sr);

%   PARTIAL OCCLUSION: PRIMARY_OUTPUT = MAX(BAG1,BAG2+CHAIN) + S*MIN(BAG1,BAG2+CHAIN)
%   ASSUME BAG2+CHAIN IS ALWAYS SMALLER
    V_bag1 = primary_afferent - S*V_bag2_chain;

%   CORRECT WHEREVER ASSUMPTION DOES NOT HOLD
    V_bag1(V_bag1<V_bag2_chain) = (primary_afferent(V_bag1<V_bag2_chain) - V_bag2_chain(V_bag1<V_bag2_chain))/S;

    gamma_dyn = abs(bag1_inv(V_bag1,L,Ldot,Lddot,dt));
    gamma_dyn(gamma_dyn>1/refractoryPeriod) = 1/refractoryPeriod;