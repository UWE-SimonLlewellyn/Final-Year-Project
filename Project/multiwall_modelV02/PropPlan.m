classdef PropPlan
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        floorMesh
        pathUnit
        thinFloorPlanBW
        floorPlanGray 
        wallAt
        TxGridCentre
    end
    
    
   methods
        function obj = add(obj,floorMesh, pathUnit,thinFloorPlanBW,floorPlanGray, wallAt, TxGridCentre)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
            obj.floorMesh = floorMesh;
            obj.pathUnit = pathUnit;
            obj.thinFloorPlanBW = thinFloorPlanBW;
            obj.floorPlanGray = floorPlanGray;
            obj.wallAt = wallAt;
            obj.TxGridCentre = TxGridCentre;
        end
   end
end
