

% N-Queens Solution With Genetic Algorithms
% Vahid Hallaji <vahid@hallaji.com>
% Copyright (c) 2005-2014, Vahid Hallaji
% http://hallaji.com


N = 8;
InitialPopulationNumber = 1000;
GenerationsNumber = 10;

MaximumFitness = (N*(N-1))/2;
BestPopulation = zeros(0, N);
FinalSolutions = zeros(0, N);

%Initial Population
InitialPopulation = zeros(InitialPopulationNumber, N); 
for i = 1:InitialPopulationNumber
    InitialPopulation(i,:) = randperm(N);
end;

%Generations
for Generation = 1:GenerationsNumber
    
    InitialPopulationFitness = zeros(InitialPopulationNumber,2);
    
    for i = 1:InitialPopulationNumber                                   
        FitnessCount = 0;
        for x = 1:(N-1)                                        
            for y = x+1:N                                      
                z = abs(InitialPopulation(i,x)-InitialPopulation(i,y));  
                if(z ~= 0 && z ~= (y-x))                     
                    FitnessCount = FitnessCount + 1;        
                end                                            
            end                                                
        end
        InitialPopulationFitness(i,1) = i;
        InitialPopulationFitness(i,2) = FitnessCount;
    end
    
    [row,col] = sort(InitialPopulationFitness(:,2),'descend');
    SortedPopulationFitness = InitialPopulationFitness(col,:);

    %Selection ---------------------------------------------------------
    BestSolutionCounter = 0;
    for i = 1:InitialPopulationNumber
        
        SolutionIndex = SortedPopulationFitness(i,1);
        if(SortedPopulationFitness(i,2) == MaximumFitness)
            NewFinalSolution = InitialPopulation(SolutionIndex,:);
            FinalSolutions = vertcat(FinalSolutions, NewFinalSolution);
        end

        BestSolutionCounter = BestSolutionCounter + 1;
        if BestSolutionCounter <= (InitialPopulationNumber/2)
            NewBestSolution = InitialPopulation(SolutionIndex,:);
            BestPopulation = vertcat(BestPopulation, NewBestSolution);
            NewInitialPopulationNumber = BestSolutionCounter;
        else
            break;
        end

    end
    
    InitialPopulationNumber = NewInitialPopulationNumber;
    InitialPopulation = BestPopulation;
    
    %CrossOver ---------------------------------------------------------
    for i = 1:InitialPopulationNumber
        if(mod(i,2) ~= 0)
            TempPopulation = InitialPopulation(i,:);
        else
            Point = randi([1, N]);
            if Point < (N/2)
                First = Point;
                Last = N;
            else
                First = 1;
                Last = Point;
            end
            for j = First:Last
                Temp = TempPopulation(1,Point);
                TempPopulation(1,Point) = InitialPopulation(i,Point);
                InitialPopulation(i,Point) = Temp;
            end
        end
    end    
    
    %Mutation ----------------------------------------------------------
    for i = 1:InitialPopulationNumber
        First = randi([1, N]);
        Second = randi([1, N]);
        Temp = InitialPopulation(i,First);
        InitialPopulation(i,First)=InitialPopulation(i,Second);
        InitialPopulation(i,Second) = Temp;
    end
   
end

unique(FinalSolutions,'rows')
