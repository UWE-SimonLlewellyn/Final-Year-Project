classdef Solution
    %SOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        noTx
        meandB
        tableOfCoOrdinates
        bestDualFitness
    end
    
    methods
        function obj = compare(obj,inputSolution)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
            if inputSolution.bestDualFitness > obj.bestDualFitness
                obj.noTx = inputSolution.noTx;
                obj.meandB = inputSolution.meandB;
                obj.tableOfCoOrdinates = inputSolution.tableOfCoOrdinates;
                obj.bestDualFitness = inputSolution.bestDualFitness;
            
            end
                      
        end
        
        function obj =  add(obj,inputNoOfTx,inputMeandB,inputTableOfTxPixelCoords,inputDualFitness)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
                obj.noTx = inputNoOfTx;
                obj.meandB = inputMeandB;
                obj.tableOfCoOrdinates = inputTableOfTxPixelCoords;
                obj.bestDualFitness = inputDualFitness;
                       
        end
       
        
    end
end

