function [solution] = PopSolution(solution,currentPlanDetails,MaxNumTx)
%FITNESS Summary of this function goes here
%   Detailed explanation goes here

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

    % End point of the Algorithm 
    [meandB,mindB,nodedBresults] = prop(solution.pixelCoOrds,currentPlanDetails,MaxNumTx);

    weight1 = 0.7;
    weight2 = 0.2;
    weight3 = 0.1;

    dualFitness =  (weight1 * noOfTx) - (weight2 * meandB)  -  (weight3 * mindB);

    solution = solution.add(noOfTx, meandB, nodedBresults,solution.pixelCoOrds, dualFitness);
    
end

