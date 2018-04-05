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
    [meandB,nodedBresults,mindb,maxdb] = prop(solution.pixelCoOrds,currentPlanDetails,MaxNumTx);
    %meandB = round(meandB);

    
    %normalalise the objectives
%     noramlisedMeandB = abs(meandB)./100;
%     normalisedNoOfTx = 1./noOfTx;
     normalisedNoOfTx = noOfTx/MaxNumTx;
    noramlisedMeandB = (meandB - mindb)/(maxdb - mindb);


     dualFitness = abs(noramlisedMeandB - normalisedNoOfTx);
%     if dualFitness < 0
%        dualFitness = abs(dualFitness) ;
%     end
    
 %   dualFitness = abs(dualFitness./noramlisedMeandB);

%     multiValue = normalisedNoOfTx .* noramlisedMeandB;
%     divValue = normalisedNoOfTx ./ noramlisedMeandB;
%     dualFitness = (multiValue - divValue);


    solution = solution.add(noOfTx, meandB, nodedBresults,solution.pixelCoOrds, dualFitness);

    
end

