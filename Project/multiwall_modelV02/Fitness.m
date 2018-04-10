% Name:         Simon Llewellyn
% Student No.:  04971824
% Project:      Optimisation of Wireless Network Access Point Positioning Using Artificial Intelligence


function [solution] = Fitness(solution,currentPlanDetails,MaxNumTx)
%FITNESS Scored and populates the fitness of a solution
% VARS Imported:
%       solution - orignal solution on hold grid refrences for AP placement
%       currentPlanDetails - all the infomration required for prop.m about
%                            the problem space
%       maxNumTx - Total possible amount of Tx in a solution.
%
% Takes soltuion holding the grid references of APs
% Converts to pixel coords
% Solution passed through propagation simulator and returns db reading
% Fitness is calculated using a weighted formula
% fitness, meanDB, noTx, pixel coords, all node dB readings are added to
% solution and passed back. 

solution.pixelCoOrds  =  zeros(MaxNumTx,2);
 %Coversts the soltuions grid cordinate eg [1,9] to pixel coordinates
 %[120.45,395.00]
    noOfTx = 0;
    for i = 1:MaxNumTx
        if  solution.tableOfCoOrdinates(i,1) ~= 0 && solution.tableOfCoOrdinates(i,2) ~= 0
            noOfTx = noOfTx + 1;
            solution.pixelCoOrds(i,:) = [currentPlanDetails.TxGridCentre(:,2,solution.tableOfCoOrdinates(i,1),...
                solution.tableOfCoOrdinates(i,2)),currentPlanDetails.TxGridCentre(:,1,solution.tableOfCoOrdinates(i,1),...
                solution.tableOfCoOrdinates(i,2))];
        end
    end

    % tests AP placement in simulator to gain all dB readings for each node
    [meandB,mindB,nodedBresults] = prop(solution.pixelCoOrds,currentPlanDetails,MaxNumTx);

    % fitness calculation 
    weight1 = 0.7;  weight2 = 0.2;  weight3 = 0.1;
    dualFitness =  (weight1 * noOfTx) - (weight2 * meandB)  -  (weight3 * mindB);

    % return populated solution with fitness, dB reading and pixel coords
    solution = solution.add(noOfTx, meandB, nodedBresults,solution.pixelCoOrds, dualFitness);
    
end

