function [X] = RK4(dynamics, t, dt, X, varargin)
%%% RK4
%       Generic 4th Order Runge-Kutta Numerical Integrator
%
%   INPUTS:
%       dynamics            Handle for System Dynamics
%       dt                  Time Step
%       X                   State Vector (step n)
%       varargin            Other Input Arguments
%
%   OUTPUTS:
%       X                   State Vector (step n+1)
%
%   Created by Manav Jadeja on 20220102


%%% COMPUTATION OF UPDATED STATE VECTOR
% 4TH ORDER RUNGE-KUTTA COEFFICIENTS
k1 = dt*dynamics(t,          dt, X,          varargin{:});
k2 = dt*dynamics(t + 0.5*dt, dt, X + 0.5*k1, varargin{:});
k3 = dt*dynamics(t + 0.5*dt, dt, X + 0.5*k2, varargin{:});
k4 = dt*dynamics(t + dt,     dt, X + k3,     varargin{:});

% UPDATED STATE VECTOR
X = X + (k1 + 2*k2 + 2*k3 + k4)/6;


end
