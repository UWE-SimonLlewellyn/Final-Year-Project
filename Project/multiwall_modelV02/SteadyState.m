% Name:         Simon Llewellyn
% Student No.:  04971824
% Project:      Optimisation of Wireless Network Access Point Positioning Using Artificial Intelligence

function [parentPop,bestOfChildren] = SteadyState(parentPop,currentPlanDetails,MaxNoTx, mutationRate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% selection
parent1 = tournement(parentPop);
parent2 = tournement(parentPop);
child1 = parent1;
child2 = parent2;

%% Crossover
% % Generates radnom number to crossover point
% x_over = randi([1,MaxNoTx]);
% % Loop start at crossove and continues to the end
% for i = x_over:MaxNoTx
%     child1.tableOfCoOrdinates(i,:) = parent2.tableOfCoOrdinates(i,:);
%     child2.tableOfCoOrdinates(i,:) = parent1.tableOfCoOrdinates(i,:);
% end

count = MaxNoTx * 2;
x_over = randi([1,count]);
k = 1;
child1gene = zeros(count,1);
child2gene = zeros(count,1);
for i = 1:MaxNoTx
    child1gene(k,1) = parent1.tableOfCoOrdinates(i,1);
    child2gene(k,1) = parent2.tableOfCoOrdinates(i,1);
    k=k+1;
    child1gene(k,1) = parent1.tableOfCoOrdinates(i,2);
    child2gene(k,1) = parent2.tableOfCoOrdinates(i,2);
    k=k+1;
end

for i = x_over:count
    temp =  child1gene(i,1);
     child1gene(i,1) =  child2gene(i,1);
      child2gene(i,1) = temp;
end

k=1;
for i = 1:MaxNoTx
    parent1.tableOfCoOrdinates(i,1)= child1gene(k,1);
    parent2.tableOfCoOrdinates(i,1) = child2gene(k,1);
    k=k+1;
    parent1.tableOfCoOrdinates(i,2) = child1gene(k,1);
    parent2.tableOfCoOrdinates(i,2) = child2gene(k,1);
    k=k+1;
end



%% Mutation
% CHILD 1
for i = 1:MaxNoTx      
    for j = 1:2
    c = rand(1);
        if c <= mutationRate
           if  child1.tableOfCoOrdinates(i,j) == currentPlanDetails.gridSize
               child1.tableOfCoOrdinates(i,j) = child1.tableOfCoOrdinates(i,j) -1;
           elseif child1.tableOfCoOrdinates(i,j) == 0
               child1.tableOfCoOrdinates(i,j) = child1.tableOfCoOrdinates(i,j) +1;
           else
               d = randi([1,2]);
               if d ==1
                    child1.tableOfCoOrdinates(i,j) = child1.tableOfCoOrdinates(i,j) + 1;
               else
                   child1.tableOfCoOrdinates(i,j) = child1.tableOfCoOrdinates(i,j) - 1;
               end
           end
        end 
    end 
end

% CHILD 2
for i = 1:MaxNoTx    
    for j = 1:2
    c = rand(1);
        if c == mutationRate
           if  child2.tableOfCoOrdinates(i,j) == currentPlanDetails.gridSize
               child2.tableOfCoOrdinates(i,j) = child2.tableOfCoOrdinates(i,j) - 1;
           elseif child2.tableOfCoOrdinates(i,j) == 0
               child2.tableOfCoOrdinates(i,j) = child2.tableOfCoOrdinates(i,j) + 1;
           else
               d = randi([1,2]);
               if d ==1
                    child2.tableOfCoOrdinates(i,j) = child2.tableOfCoOrdinates(i,j) + 1;
               else
                   child2.tableOfCoOrdinates(i,j) = child2.tableOfCoOrdinates(i,j) - 1;
               end
           end
        end 
    end 
end


%% Score fitness of children 
child1 = Fitness(child1,currentPlanDetails,MaxNoTx);
child2 = Fitness(child2,currentPlanDetails,MaxNoTx);


if child1.dualFitness > child2.dualFitness
    bestOfChildren = child2;
else
    bestOfChildren = child1;
end

%% replace worst in population with best new soltuion
% worset solution  = largest value 
index = 0;
testValue = 0;
for i = 1:numel(parentPop)
    if parentPop(i).dualFitness > testValue
        testValue = parentPop(i).dualFitness;
        index = i;
    end
end

parentPop(index) = bestOfChildren;

end

