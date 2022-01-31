classdef satellite < handle
    %SATELLITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        state0              % Initial State Vector
        stateD              % Desired State Vector
        stateS              % Simulated State Vector
        inertia             % Inertia Tensor
        K                   % Control Gains
        wheel               % Reaction Wheel (object)
        
        t                   % Time Span
        dt                  % Time Step
        
        vertices            % Vertices
        faces               % Faces
        color               % Color
        
        h                   % Handle
    end
    
    methods
        function obj = satellite(state0, stateD, K, inertia, t, dt, wheel,...
                vertices, faces, color)
            %%% satellite
            %       Constructor
            obj.state0 = [state0, wheel.state0];
            obj.stateD = stateD;
            obj.K = K;
            obj.inertia = inertia;
            obj.wheel = wheel;
            
            obj.t = t;
            obj.dt = dt;
            
            obj.vertices = vertices;
            obj.faces = faces;
            obj.color = color;
            
            obj.draw();
        end
        
        function [] = simulate(obj)
            %%% simulate
            %   	Run a simulation
            
            obj.stateS = zeros(length(obj.t), size(obj.state0, 2));
            obj.stateS(1,:) = obj.state0;
            for a = 1:length(obj.t)-1
                obj.stateS(a+1,:) = RK4(@obj.satelliteSystemDynamics, obj.dt, obj.stateS(a,:), a);
            end
        end
        
        function [X] = RK4(dynamics, dt, X, varargin)
            k1 = dt*dynamics(0, X, varargin{:});
            k2 = dt*dynamics(0.5*dt, X + 0.5*k1, varargin{:});
            k3 = dt*dynamics(0.5*dt, X + 0.5*k2, varargin{:});
            k4 = dt*dynamics(dt, X + k3, varargin{:});
            
            X = X + (k1 + 2*k2 + 2*k3 + k4)/6;
        end
        
        function [dState] = satelliteSystemDynamics(obj, dt, state, a)
            %%% satelliteSystemDynamics
            %       Gradient of the system at a given state and time
            
            %%% SETUP
            q = state(1:4);
            w = state(5:7);
            W = state(8:10);
            
            %%% CONTROL MOMENT
            Mc = quatEMc(obj, q, w, obj.K, obj.stateD(a,:));
            % Make sure all components of Mc are less than the max!
            if norm(Mc) > 6e-4
                direction = Mc/norm(Mc);
                Mc = 6e-4*direction;
            end
            
            %Mc(1) = 6e-4*(abs(Mc(1))>6e-4) + Mc(1)*(abs(Mc(1))<=6e-4);
            %Mc(2) = 6e-4*(abs(Mc(2))>6e-4) + Mc(2)*(abs(Mc(2))<=6e-4);
            %Mc(3) = 6e-4*(abs(Mc(3))>6e-4) + Mc(3)*(abs(Mc(3))<=6e-4);
            
            %%% KINEMATICS
            dq = -qp(obj, [0,w], q)/2;
            dw = obj.inertia\(-1*cpm(obj, w)*obj.inertia*(w') + Mc');
            dW = obj.wheel.inertia\(-1*cpm(obj, W)*obj.wheel.inertia*(W') - Mc');
            
            %%% INSERT REACTION WHEEL DYNAMICS HERE LATER
            
            %%% DSTATE
            dState = [dq, dw', dW'];
        end
        
        function [Mc] = quatEMc(obj, q, w, K, qd)
            %%% quatEMc
            %       Control Moment from Quaternion Error
            
            qErr = qp(obj, qd, [q(1), -q(2), -q(3), -q(4)]);
            
            Mc = -K(1)*qErr(2:4) -K(2)*w;
        end
        
        function [pq] = qp(obj, p, q)
            %%% pq
            %       Kronecker (Quaternion Product)
            
            pq = [
                p(1)*q(1) - p(2)*q(2) - p(3)*q(3) - p(4)*q(4),...
                p(1)*q(2) + p(2)*q(1) + p(3)*q(4) - p(4)*q(3),...
                p(1)*q(3) - p(2)*q(4) + p(3)*q(1) + p(4)*q(2),...
                p(1)*q(4) + p(2)*q(3) - p(3)*q(2) + p(4)*q(1),...
            ];
        end
        
        function [mat] = cpm(obj, vec)
            %%% cpm
            %       Standard Cross Product Matrix from Vector
            
            mat = [
                      0, -vec(3),  vec(2);
                 vec(3),       0, -vec(1);
                -vec(2),  vec(1),       0;
            ];
        end
        
        function A = q2a(obj, q)
        %%% q2a
        %       Quaternion to Attitude Profile
            q = q/norm(q);

            A=[q(1)^2-q(2)^2-q(3)^2+q(4)^2, 2*(q(1)*q(2)+q(3)*q(4)), 2*(q(1)*q(3)-q(2)*q(4));
                2*(q(1)*q(2)-q(3)*q(4)), -q(1)^2+q(2)^2-q(3)^2+q(4)^2, 2*(q(2)*q(3)+q(1)*q(4));
                2*(q(1)*q(3)+q(2)*q(4)), 2*(q(2)*q(3)-q(1)*q(4)), -q(1)^2-q(2)^2+q(3)^2+q(4)^2];
        end
        
        function [] = animate(obj)
            % Draw and Figure
            xlim([-2 2])
            ylim([-2 2])
            zlim([-2 2])
            view(45,20)
            
            % Animation
            for i = 1:50:length(obj.t)
                rotmat = obj.q2a(obj.stateS(i, 1:4));
                obj.updateAttitude(rotmat)
                title(num2str(obj.t(i), '%.2f'))
                drawnow
                pause(1e-2)
            end
        end
        
        function [] = updateAttitude(obj, rotmat)
            %%% UPDATE ATTITUDE
            % Turn block
            v_new = (rotmat*obj.vertices')';
            set(obj.h, 'Vertices', v_new);
        end
        
        function [] = draw(obj)
            %%% DRAW
            % Draw block            
            obj.h = patch('Faces', obj.faces, 'Vertices', obj.vertices,...
                'FaceColor', obj.color);
            view(45,20)
            
            axis equal
            grid on
            rotate3d on
        end
    end
end

