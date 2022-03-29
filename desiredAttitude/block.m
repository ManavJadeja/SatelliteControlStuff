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
        
        vertices        % Matrix with vertices
        faces           % Matrix with faces
        inertia         % Inertia Matrix
        color           % Color
        
        h               % handle
    end
    
    methods
        function obj = block(state0, stateD, K, dynamics, t, vertices, faces, inertia, color)
            %%% BLOCK
            % Block State and Path
            obj.state0 = state0;
            obj.stateD = stateD;
            obj.K = K;
            obj.dynamics = dynamics;
            obj.t = t';
            
            % Block Visuals
            obj.vertices = vertices;
            obj.faces = faces;
            obj.inertia = inertia;
            obj.color = color;
        end
        
        function [t, q] = simulate(obj)
            options = odeset('RelTol', 1e-9, 'AbsTol', 1e-9*ones(1,7));
            [t, q] = ode45(@(t,X)obj.dynamics(t, X, obj.inertia, obj.stateD, obj.K), obj.t, obj.state0, options);
            obj.stateS = q;
        end
        
        function [] = animate(obj)
            % Draw and Figure
            obj.draw();
            xlim([-2 2])
            ylim([-2 2])
            zlim([-2 2])
            view(45,20)
            
            % Animation
            for i = 1:length(obj.t)
                rotmat = q2a(obj.stateS(1:4, i));
                obj.updateAttitude(rotmat)
                title(num2str(obj.t(i), '%.2f'))
                drawnow
                %pause(1/100)
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

