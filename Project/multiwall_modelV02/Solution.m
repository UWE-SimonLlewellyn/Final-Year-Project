classdef Solution
    %SOLUTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        noTx
        meandB
        nodedBresults
        tableOfCoOrdinates
        bestDualFitness = 1000
    end
    
    methods
        function obj = compare(obj,inputSolution)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
            if inputSolution.bestDualFitness < obj.bestDualFitness || ...
                    ((inputSolution.bestDualFitness == obj.bestDualFitness) && (inputSolution.noTx < obj.noTx))
                obj.noTx = inputSolution.noTx;
                obj.meandB = inputSolution.meandB;
                obj.nodedBresults = inputSolution.nodedBresults;
                obj.tableOfCoOrdinates = inputSolution.tableOfCoOrdinates;
                obj.bestDualFitness = inputSolution.bestDualFitness;
            
            end
                      
        end
        
        function obj =  add(obj,inputNoOfTx,inputMeandB,inputNodedBresults,inputTableOfTxPixelCoords,inputDualFitness)
            %SOLUTION Construct an instance of this class
            %   Detailed explanation goes here
            
                obj.noTx = inputNoOfTx;
                obj.meandB = inputMeandB;
                obj.nodedBresults = inputNodedBresults;
                obj.tableOfCoOrdinates = inputTableOfTxPixelCoords;
                obj.bestDualFitness = inputDualFitness;
                       
        end
       
        
    end
end

