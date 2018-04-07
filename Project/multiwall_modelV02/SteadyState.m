function [parentPop,bestOfChildren] = SteadyState(parentPop,currentPlanDetails,MaxNoTx, mutationRate)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% selection
parent1 = tournement(parentPop);
parent2 = tournement(parentPop);
child1 = parent1;
child2 = parent2;

%X-over
x_over = randi([1,MaxNoTx]);

for i = x_over:MaxNoTx
    child1.tableOfCoOrdinates(i,:) = parent2.tableOfCoOrdinates(i,:);
    child2.tableOfCoOrdinates(i,:) = parent1.tableOfCoOrdinates(i,:);
end


%%%     Mutation
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


%Score fitness of children 
child1 = PopSolution(child1,currentPlanDetails,MaxNoTx);
child2 = PopSolution(child2,currentPlanDetails,MaxNoTx);

temp = Solution;
% %Compare children to parents
% for i = 1:2
%     if parent1.dualFitness > parent2.dualFitness
%         if child1.dualFitness < child2.dualFitness
%             if parent1.dualFitness > child1.dualFitness
%                 temp = parent1;
%                 parent1 = child1;
%                 child1 = temp;
%             end
%         else 
%             if parent1.dualFitness > child2.dualFitness
%                 temp = parent1;
%                 parent1 = child2;
%                 child2 = temp;
%             end
%         end    
% 
%     elseif parent1.dualFitness < parent2.dualFitness
%         if child1.dualFitness > child2.dualFitness
%             if parent2.dualFitness > child1.dualFitness
%                 temp = parent2;
%                 parent2 = child1;
%                 child1 = temp;
%             end         
%         else 
%             if parent2.dualFitness > child2.dualFitness
%                 temp = parent2;
%                 parent2 = child2;
%                 child2 = temp;
%             end
%         end
% 
%     end
% end
% 
% parentPop(a) = parent1;
% parentPop(b) = parent2;

if child1.dualFitness > child2.dualFitness
    bestOfChildren = child2;
else
    bestOfChildren = child1;
end

%replace worst with new soltuion
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

