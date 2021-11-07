classdef shapeR < handle
    %SHAPER store a shape and its properties
    
    properties
        vertices    % Matrix with list of vertices
        faces       % Matrix with list of faces
        mass        % Scalar mass
        inertia     % 1x3 with xx, yy, and zz inertia
        color       % 1x3 color matrix (0-1 for RGB)
        
        wheels      % reaction wheels on this satellite
        
        h           % handle
    end
    
    methods (Access = public)
        function [obj] = shapeR(vertices, faces, mass, inertia, color, wheels)
            %SHAPE Construct an instance of this class
            obj.vertices = vertices;
            obj.faces = faces;
            obj.mass = mass;
            obj.inertia = inertia;
            obj.color = color;
            
            obj.wheels = wheels;
            
            obj.draw();
        end
        
        function [] = updateAttitude(obj, rotmat)
            % Update the attitude of shape using rotation matrix
            v_new = (rotmat*obj.vertices')';
            set(obj.h, 'Vertices', v_new);
        end
        
        function [] = draw(obj)
            % Draw the object with current values
            obj.h = patch('Faces', obj.faces, 'Vertices', obj.vertices,...
                          'FaceColor', obj.color);
            axis equal
            grid on
            rotate3d on
        end
    end
end

