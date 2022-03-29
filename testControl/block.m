classdef block < handle
    %%% BLOCK
    %       spinny block go whirl
    
    properties
        state0          % Initial State Vector
        stateD          % Desired State Vector
        stateS          % Simulated State Vector
        K               % Controller Gains
        dynamics        % Function for Equations of Motion
        t               % Time span
        dt              % Time step
        
        vertices        % Matrix with vertices
        faces           % Matrix with faces
        inertia         % Inertia Matrix
        color           % Color
        
        h               % handle
    end
    
    methods
        function obj = block(state0, stateD, K, dynamics, t, dt, vertices, faces, inertia, color)
            %%% BLOCK
            % Block State and Path
            obj.state0 = state0;
            obj.stateD = stateD;
            obj.K = K;
            obj.dynamics = dynamics;
            obj.t = t;
            obj.dt = dt;
            
            % Block Visuals
            obj.vertices = vertices;
            obj.faces = faces;
            obj.inertia = inertia;
            obj.color = color;
            
            obj.draw();
        end
        
        function [t, q] = simulate1(obj)
            options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,7));
            [t, q] = ode45(@(t,X)obj.dynamics(t, X, obj.inertia, obj.stateD, obj.K, obj.dt), obj.t, obj.state0, options);
            q = q';
            obj.stateS = q;
        end
        
        function [q] = simulate2(obj)
            q = zeros(length(obj.t), 7);
            q(1,:) = obj.state0;
            for a = 1:length(obj.t)-1
                % dynRotCon2(dt, X, qd, I, K)
                q(a+1,:) = RK4(@dynRotCon2, obj.dt, q(a,:), obj.stateD(a,:), obj.inertia, obj.K);
            end
        end
        
        function [X] = RK4(dynamics, dt, X, varargin)
            k1 = dt*dynamics(0, X, varargin{:});
            k2 = dt*dynamics(0.5*dt, X + 0.5*k1, varargin{:});
            k3 = dt*dynamics(0.5*dt, X + 0.5*k2, varargin{:});
            k4 = dt*dynamics(dt, X + k3, varargin{:});
            
            X = X + (k1 + 2*k2 + 2*k3 + k4)/6;
        end
        
        function [] = animate(q, obj)
            % Draw and Figure
            xlim([-2 2])
            ylim([-2 2])
            zlim([-2 2])
            view(45,20)
            
            % Animation
            for i = 1:length(obj.t)
                rotmat = q2a(q(1:4, i));
                obj.updateAttitude(rotmat)
                title(num2str(obj.t(i), '%.2f'))
                drawnow
                pause(1/100)
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

