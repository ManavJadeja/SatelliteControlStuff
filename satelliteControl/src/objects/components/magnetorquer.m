classdef magnetorquer < handle
    %%% magnetorquer
    %       Magnetorquer (Object)
    %
    %   Created by Manav Jadeja on 20220105
    
    properties
        magneticDipole              % Magnetic Dipole (3x1 double: A m^2)
        magneticField               % External Magnetic Field (3x1 double: kg A^-1 s^-1)
        
        h                           % Handle
    end
    
    methods
        function obj = magnetorquer(dipoleMagnitude, direction, magneticField)
            %%% magnetorquer
            %       Create a magnetorquer
            
            obj.magneticDipole = dipoleMagnitude*direction/norm(direction);
            obj.magneticField = magneticField;
        end
        
        function [Mm] = magneticMoment(obj, B, q)
            %%% magneticMoment
            %       Computes Magnetic Moment from current Magnetic Dipole
            %       (rotated with quaternion) and External Magnetic Field
            %   INPUTS:
            %       B           External Magnetic Field
            %       q           Current Quaternion (orientation)
            %   OUTPUTS:
            %       Mm          Moment caused by Magnetic Dipole and Field
            
            m = obj.magneticDipole;
            mQ = q*[0;m']*[q(1), -q(2), -q(3), -q(4)];
            Mm = [
                mQ(2)*B(3) - mQ(3)*B(2),...
                mQ(3)*B(1) - mQ(1)*B(3),...
                mQ(1)*B(2) - mQ(2)*B(1),...
            ];
        end
    end
end

