function [tempSoltuion] = Fitness(tableOfTxGridCoords,currentPlanDetails,MaxNumTx)
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
    
    dualFitness = meandB ./ noOfTx
    meandB = round(meandB);
    tempSoltuion = Solution(noOfTx,meandB,tableOfTxPixelCoords,dualFitness);
    
    tempSoltuion.add(noOfTx,meandB,tableOfTxPixelCoords,dualFitness);
    

end

