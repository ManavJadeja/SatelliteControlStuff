classdef starTracker < handle
    %%% starTracker
    %       Star Tracker (Object)
    %
    %   Created by Manav Jadeja on 20220519
    
    properties
        pixelsLength
        starsTracked
        kcentroid
        
        tempError
        
        h
    end
    
    methods
        function obj = starTracker(tempError, starsTracked, kcentroid)
            %%% starTracker
            %       Create a star tracker
            obj.tempError = tempError;
            obj.starsTracked = starsTracked;
            obj.kcentroid = kcentroid;
        end
        
        function [qEstimate] = lostAttitudeAcquisition(obj, qActual)
            %%% lostAttitudeAcquisition
            %   	Lost Mode (Initial) Attitude Acquisition
            
            qEstimate = 1;
        end
        
        function [qEstimate] = trackingAttitudeAcquisitions(obj, qActual, qEstimate)
            %%% trackingAttitudeAcquisitions
            %       Tracking Mode (Continuous) Attitude Acquisition
            
            qEstimate = 1;
        end
        
    end
end
