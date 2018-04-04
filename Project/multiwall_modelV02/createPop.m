function [population, geneLen] = createPop(MaxNumTx,popSize,grid, cellSpace,currentPlanDetails)
%FITNESS Summary of this function goes here)
%CREATEPOP inital random population to intitiate the GA
%   population will consist of multiple random solutions based upon the
%   passed parameters.
%   each solution will hold co-ordinats [x,y] for each Tx for as many Tx
%   are used in that solution along with the fitness of the solution.
%   If total number of Tx ussed is less that maxNumTx the space will be 
%   filled with 0's and these will not show with in soltuion. 
%   Co
%   ------------------------------
%   Parameteres:
%   MaxNumTx : total amount of transmitters allowsed in a solution
%   popSize  : the size of the population to create 
%   grid     : the problem space has been devided into a grid showing 
%              this var hold the size (X-by-Y) of the grid
%   cellSpace: the total space allow between Tx in the grid
%   eg : MaxNumTx = 3, popsize = 3, grid = [2,5]
%   population = [{{2,3},{1,1}, {0,0}, 45},{{2,1},{2,5},{2,4}, 40},
%   {{1,1},{0,0}, {0,0}, 60}]

%% create blank Gene
    solutionLen = ((MaxNumTx * 2) + 1);
    geneLen = (solutionLen * popSize );  
    % geneLen : (MaxNumTx * 2) = allows for X & Y corodunate for each Tx then
    % + 1 for fitness, this is then multipled for how many soltuions in the
    % popluation. 
    population = zeros(1,geneLen);

    % creates a zeroed table popsize X geneLen, each row is a solution with fitness

%% population Gene
    % populated using the grid spacing funtion
    bestSolution = Solution;
    k = 1;
    for  i = 1:popSize
        tempSolution = TxGridSpacing(MaxNumTx, grid(1,1), cellSpace);
        currentSolutionObj = Fitness(tempSolution,currentPlanDetails,MaxNumTx);
        for j =  1:MaxNumTx
            test = tempSolution(j,1);
            population(1,k) = test;
            k=k+1;
            test = tempSolution(j,2); 
            population(1,k) = test; % fails when tryin gto get the value out 
            %In an assignment  A(:) = B, the number of elements in A and B must be the same.
            k=k+1;
        end
        population(1,k) = currentSolutionObj.bestDualFitness;
        k = k+1;              
        bestSolution.compare(currentSolutionObj);

    end

end

