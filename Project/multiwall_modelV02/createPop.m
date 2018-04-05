function [population, solutionLen, bestSolution] = createPop(MaxNumTx,popSize,grid, cellSpace,currentPlanDetails)
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
    % geneLen : (MaxNumTx * 2) = allows for X & Y corodunate for each Tx then
    % + 1 for fitness

    population = Solution.empty(popSize,0);
    % creates a empty array of Solutions the size of popsize

%% population Gene
    % populated using the grid spacing funtion
    bestSolution = Solution;
   % k = 1;
    for  i = 1:popSize
        population(i).tableOfCoOrdinates = TxGridSpacing(MaxNumTx, grid(1,1), cellSpace);
        population(i) = PopSolution(population(i),currentPlanDetails,MaxNumTx);
        fitness = @multiObjectiveFitness;
        nvars = 2;
        [x,fval] = gamultiobj(fitness,nvars);
  
        bestSolution = bestSolution.compare(population(i)); %scores durrent fittest
    end

end

