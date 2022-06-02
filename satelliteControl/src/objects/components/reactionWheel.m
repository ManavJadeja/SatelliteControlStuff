classdef reactionWheel < handle
    %%% reactionWheel
    %       3 Axis Reaction Wheels (Object)
    %
    %   Created by Manav Jadeja on 20220515
    
    properties
        state0A             % State Vector (Initial Actual)
        state0E             % State Vector (Initial Estimate)
        
        inertiaA            % Inertia Matrix (Actual)
        inertiaE            % Inertia Matrix (Estimate)
        maxMoment           % Maximum Moment/Torque
                
        h                   % Handle
    end
    
    methods
        function obj = reactionWheel(state0, state0Error, inertiaA, inertiaError, maxMoment)
            %%% reactionWheel
            %       Create a 3 axis reaction wheel
            obj.state0A = state0;
            obj.state0E = state0 + state0Error;
            
            obj.inertiaA = inertiaA;
            obj.inertiaE = inertiaA + inertiaError;
            obj.maxMoment = maxMoment;
        end
        
        function [Mc] = controlTorque(obj, q, w, K, qd)
            %%% controlTorque
            %       Get control torque with a certain orientation
            %   INPUTS:
            %       q           Quaternion (current)
            %       w           Angular Velocity (current)
            %       K           Quaternion Controller Gains
            %       qd          Quaternion (desired)
            %   OUTPUTS:
            %       Mc          Control Moment
            
            % Compute Control Torque
            %{
            disp('OBJ')
            disp(obj)
            disp('Q')
            disp(q)
            disp('W')
            disp(w)
            disp('K')
            disp(K)
            disp('QD')
            disp(qd)
            %}
            Mc = quatEMc(obj, q, w, K, qd);

            % Saturation
            if norm(Mc) > obj.maxMoment
                Mc = obj.maxMoment*(Mc/norm(Mc));
            end
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
            %       Computes Standard Cross-Product Matrix from Vector
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