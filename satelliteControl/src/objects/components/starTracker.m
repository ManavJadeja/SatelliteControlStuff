classdef starTracker < handle
    %%% starTracker
    %       Star Tracker (Object)
    %
    %   Created by Manav Jadeja on 20220519
    
    properties
        oneSigma
        offset
        
        h
    end
    
    methods
        function obj = starTracker(oneSigma, offset)
            %%% starTracker
            %       Create a star tracker
            
            obj.oneSigma = oneSigma;
            obj.offset = offset;
        end
        
        function [qEstimate] = perfectAttitudeAcquisition(obj, qActual)
            %%% perfectAttitudeAcquisition
            %   	Perfect Attitude Acquisition
            
            qEstimate = qActual;
        end
        
        function [qEstimate] = onesigmaAttitudeAcquisition(obj, qActual)
            %%% onesigmaAttitudeAcquisitions
            %       One Sigma Error Attitude Acquisition
            
            qEstimate = qActual + obj.oneSigma*randn(1,4);
        end
        
        function [qEstimate] = offsetAttitudeAcquisition(obj, qActual)
            %%% offsetAttitudeAcquisition
            %       Offset Error Attitude Acquisition
            
            qEstimate = qActual + obj.offset;
        end
        
    end
end