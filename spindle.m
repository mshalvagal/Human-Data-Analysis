function [primary_afferent,secondary_afferent] = spindle(L,Ldot,Lddot,gamma_dyn,gamma_stat,Tsim,dt)
%
%       THIS FUNCTION IMPLEMENTS THE MODEL OF THE MUSCLE SPINDLE THAT WAS
%       DEVELOPED IN:
%       "Mathematical Models of Proprioceptors. I. Control and Transduction
%       in the Muscle Spindle"
%       AND GIVES AFFERENT FIRING RATES AS A FUNCTION OF FUSIMOTOR DRIVE
%       AND THE MUSCLE KINEMATICS
%       
%       THE ACTUAL MODEL ITSELF IS IMPLEMENTED AS A SET OF BLOCKS IN
%       SIMULINK. THIS FUNCTION PERFORMS SOME PRE AND POST PROCESSING
%
% June 2016
%

    t = 0:dt:Tsim;

    L = timeseries(L,t);
    Ldot = timeseries(Ldot,t);
    Lddot = timeseries(Lddot,t);
    gamma_dyn = timeseries(gamma_dyn,t);
    gamma_stat = timeseries(gamma_stat,t);
    assignin('base','L',L);
    assignin('base','Ldot',Ldot);
    assignin('base','Lddot',Lddot);
    assignin('base','gamma_dyn',gamma_dyn);
    assignin('base','gamma_stat',gamma_stat);

    sim('spindle_model',Tsim);
    
    L = L.Data;
    Ldot = Ldot.Data;
    Lddot = Lddot.Data;
    gamma_dyn = gamma_dyn.Data;
    gamma_stat = gamma_stat.Data;
    assignin('base','L',L);
    assignin('base','Ldot',Ldot);
    assignin('base','Lddot',Lddot);
    assignin('base','gamma_dyn',gamma_dyn);
    assignin('base','gamma_stat',gamma_stat);
    
    %assignin('base','Tdot_bag1',Tdot_bag1);
    %assignin('base','Tddot_bag1',Tddot_bag1);
    
    primary_afferent = primary_afferent.Data;
    secondary_afferent = secondary_afferent.Data;