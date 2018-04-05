function [tempSolution] = Fitness(tableOfTxGridCoords,currentPlanDetails,MaxNumTx)
%FITNESS Summary of this function goes here
%   Detailed explanation goes here

tableOfTxPixelCoords =  zeros(MaxNumTx,2);
 %
    noOfTx = 0;
    for i = 1:MaxNumTx
        if  tableOfTxGridCoords(i,1) ~= 0
            noOfTx = noOfTx + 1;
            tableOfTxPixelCoords(i,:) = [currentPlanDetails.TxGridCentre(:,2,tableOfTxGridCoords(i,1),...
                tableOfTxGridCoords(i,2)),currentPlanDetails.TxGridCentre(:,1,tableOfTxGridCoords(i,1),...
                tableOfTxGridCoords(i,2))];
        else
            break;
        end
    end

    % End point of the Algorithm 
    [meandB,nodedBresults] = prop(tableOfTxPixelCoords,currentPlanDetails,MaxNumTx);
    %meandB = round(meandB);
    
    %normalalise the objectives
    noramlisedMeandB = abs(meandB)./100;
    normalisedNoOfTx = 1./noOfTx;
    
    dualFitness = (normalisedNoOfTx - noramlisedMeandB);
    if dualFitness < 0
       dualFitness = abs(dualFitness) ;
    end
    
    tempSolution = Solution;

    tempSolution = tempSolution.add(noOfTx, meandB, nodedBresults,tableOfTxPixelCoords, dualFitness);

    
end

