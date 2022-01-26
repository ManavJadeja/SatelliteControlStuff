classdef attitudeSystem < handle
    %%% attitudeSystem
    %       Model of a satellite attitude control system
    %
    %   Created by Manav Jadeja on 20220102

    properties
        time                % Time Vector
        t                   % Time Index
        stateI              % Initial State Vector
        
        I                   % Inertia Matrix (diagonal)
        K                   % Quaternion Controller Gains
        
        magnetorquer        % Magnetorquer (3x1 Dipole Moment)
        
        qd                  % Desired Attitude Quaternions
                                % 1: Nothing Mode
                                % 2: Safety Mode
                                % 3: Experiment Mode
                                % 4: Charging Mode
                                % 5: Access Location 1
                                % 6: Access Location 2
        
        h                   % Handle
    end
    
    methods
        function obj = attitudeSystem(time, t, stateI, qd, I, K, magnetorquer)
            %%% attitudeSystem
            %       Create an attitude control system
            
            obj.time = time;
            obj.t = t;
            obj.stateI = stateI;
            
            obj.I = I;
            obj.K = K;
            
            obj.magnetorquer = magnetorquer;
            
            obj.qd = qd;
        end
        
        function [dX] = attitudeSystemDynamics(dt, X, qd, obj)
            %%% attitudeSystemDynamics
            %       Attitude Control System Dynamics
            %   INPUTS:
            %       dt          Time Step
            %       X           State Vector
            %       qd          Quaternion (desired)
            %       obj         attitudeSystem (obj)
            %   OUTPUTS:
            %       dX          State Vector Derivative
            
            %%% SETUP
            q = X(1:4);
            w = X(5:7);
            
            %%% EQUATIONS OF MOTION
            % DISTURBANCE TORQUE
            %Mm = magnetTorque(q, dt, obj);
            
            % CONTROL TORQUE
            Mc = quatEMc(obj, q, w, obj.K, qd);
            
            % KINEMATICS
            dq = -qp(obj, [0,w],q)/2;
            
            dw = obj.I\(-1*cpm(obj, w)*obj.I*(w') + Mc');
            
            
            %%% OUTPUT
            dX = [dq, dw'];
        end
        
        function [Mc] = quatEMc(obj, q, w, K, qd)
            %%% quatEMc
            %       Control Moment from Quaternion Error
            %   INPUTS:
            %       q           Quaternion (current)
            %       w           Angular Velocity (current)
            %       K           Quaternion Controller Gains
            %       qd          Quaternion (desired)
            %   OUTPUTS:
            %       Mc          Control Moment

            %%% COMPUTE CONTROL MOMENT
            % QUATERNION ERROR
            qErr = qp(obj, qd, [q(1), -q(2), -q(3), -q(4)]);
            
            % CONTROL MOMENT
            Mc = -K(1)*qErr(2:4) -K(2)*w;
        end
        
        function [pq] = qp(obj, p, q)
            %%% qp
            %       Kronecker (Quaternion) Product
            %   INPUTS:
            %       p           Quaternion 1
            %       q           Quaternion 2
            %   OUTPUTS:
            %       pq          Quaternion Product (p*q)
            
            pq = [
                p(1)*q(1) - p(2)*q(2) - p(3)*q(3) - p(4)*q(4),...
                p(1)*q(2) + p(2)*q(1) + p(3)*q(4) - p(4)*q(3),...
                p(1)*q(3) - p(2)*q(4) + p(3)*q(1) + p(4)*q(2),...
                p(1)*q(4) + p(2)*q(3) - p(3)*q(2) + p(4)*q(1),...
            ];
        end
        
        function mat = cpm(obj, vec)
            %%% cpm 
            %       Computs Standard Cross-Product Matrix from Vector
            %   INPUTS:
            %       vec         3x1 Vector
            %   OUTPUTS:
            %       mat         3x3 Standard Cross-Product Matrix
            
            mat = [
                      0, -vec(3),  vec(2);
                 vec(3),       0, -vec(1);
                -vec(2),  vec(1),       0;
            ];
        end
        
    end
end
