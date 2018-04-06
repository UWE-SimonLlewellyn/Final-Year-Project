function [population, solutionLen, bestSolution] = createPop(gaMode,MaxNumTx,popSize,grid, cellSpace,currentPlanDetails)
%This is for creating a full non binary solutions.
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
    % geneLen : (MaxNumTx * 2) = allows for X & Y coords for each Tx then
    % + 1 for fitness

    population = Solution.empty(popSize,0);
    % creates a empty array of Solutions the size of popsize

%% population Gene 
    % populated using the grid spacing funtion
    bestSolution = Solution;
   % k = 1;
    for  i = 1:popSize
        if gaMode == 1
            population(i).tableOfCoOrdinates = TxGridSpacing(MaxNumTx, grid(1,1), cellSpace);
        else
            noTx = randi([1,MaxNumTx]);
            tempTable = zeros(MaxNumTx,2);
            for j = 1:noTx
                tempTable(j,1) = randi([1,grid(1,1)]); 
                tempTable(j,2) = randi([1,grid(1,1)]); 
            end
            population(i).tableOfCoOrdinates = tempTable;
        end
        population(i) = PopSolution(population(i),currentPlanDetails,MaxNumTx);
        bestSolution = bestSolution.compare(population(i)); %scores durrent fittest
    end

end

