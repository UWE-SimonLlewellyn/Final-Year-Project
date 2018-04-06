classdef Solution
    %SOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        noTx
        meandB
        nodedBresults
        tableOfCoOrdinates
        pixelCoOrds
        dualFitness = 1000
    end
    
    methods
        function obj = compare(obj,inputSolution)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
            if inputSolution.dualFitness < obj.dualFitness 
                obj.noTx = inputSolution.noTx;
                obj.meandB = inputSolution.meandB;
                obj.nodedBresults = inputSolution.nodedBresults;
                obj.tableOfCoOrdinates = inputSolution.tableOfCoOrdinates;
                obj.pixelCoOrds = inputSolution.pixelCoOrds;
                obj.dualFitness = inputSolution.dualFitness;
            
            end
                      
        end
        
        function obj =  add(obj,inputNoOfTx,inputMeandB,inputNodedBresults,inputTableOfTxPixelCoords,inputDualFitness)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
                obj.noTx = inputNoOfTx;
                obj.meandB = inputMeandB;
                obj.nodedBresults = inputNodedBresults;
                obj.pixelCoOrds = inputTableOfTxPixelCoords;
                obj.dualFitness = inputDualFitness;
                       
        end
       
        
    end
end

