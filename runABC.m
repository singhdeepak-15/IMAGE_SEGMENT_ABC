%%%%%ARTIFICIAL BEE COLONY ALGORITHM%%%%

%Artificial Bee Colony Algorithm was developed by Dervis Karaboga in 2005 
%by simulating the foraging behaviour of bees.

%Copyright © 2008 Erciyes University, Intelligent Systems Research Group, The Dept. of Computer Engineering

%Contact:
%Dervis Karaboga (karaboga@erciyes.edu.tr )
%Bahriye Basturk Akay (bahriye@erciyes.edu.tr)
function [SO,TO] = runABC(N,D,Iter,Pr,run)

%clear all
%close all
%clc
%Iter = 100;
%N = 10;
%BEA = 7;
%D = 2;
load temp.mat
mat = pgc;
%fid  = fopen('random.txt','r');
%pro = fscanf(fid,'%d',[BEA D]);
%pos  = zeros(BEA,2);
%pos = ceil(rand(BEA,2)*300);
tic
% Set ABC Control Parameters
ABCOpts = struct( 'ColonySize',  N, ...   % Number of Employed Bees+ Number of Onlooker Bees 
    'MaxCycles', Iter,...   % Maximum cycle number in order to terminate the algorithm
    'ErrGoal',     1e-20, ...  % Error goal in order to terminate the algorithm (not used in the code in current version)
    'Dim', D, ... % Number of parameters of the objective function   
    'Limit',   100, ... % Control paramter in order to abandone the food source 
    'lb',  1, ... % Lower bound of the parameters to be optimized
    'ub',  256, ... %Upper bound of the parameters to be optimized
    'ObjFun' , 'Hgrey', ... %Write the name of the objective function you want to minimize
    'RunTime',run); % Number of the runs

GlobalMins=zeros(ABCOpts.RunTime,ABCOpts.MaxCycles);

for r=1:ABCOpts.RunTime
    
% Initialise population
Range = repmat((ABCOpts.ub-ABCOpts.lb),[ABCOpts.ColonySize 1]);%ABCOpts.Dim]);
Lower = repmat(ABCOpts.lb, [ABCOpts.ColonySize 1]);%ABCOpts.Dim]);
XColony = rand(ABCOpts.ColonySize,1) .* Range + Lower;
YColony = rand(ABCOpts.ColonySize,1).* Range + Lower;
Colony = [XColony , YColony]; 
size(Colony);
Colony = ceil(Colony);

Employed=Colony(1:(ABCOpts.ColonySize/2),:);

%evaluate and calculate fitness
ObjEmp=feval(ABCOpts.ObjFun,Employed,mat)
%fprintf('obj = %d \t',ObjEmp);
%fprintf('\n');
%ObjEmp = Location(pos,Employed);
%display(ObjEmp);
FitEmp=calculateFitness(ObjEmp);
display(FitEmp);
%fprintf('%d \t',FitEmp);
%set initial values of Bas
Bas=zeros(1,(ABCOpts.ColonySize/2));


GlobalMin=ObjEmp(find(ObjEmp==max(ObjEmp),end));
%display(GlobalMin);
GlobalParams=Employed(find(ObjEmp==max(ObjEmp),end),:,:);
%display(GlobalParams);

 Cycle=1;
 while ((Cycle <= ABCOpts.MaxCycles))
%     
%     %%%%% Employed phase
     Employed2=Employed;
     display(Employed2);
     for i=1:ABCOpts.ColonySize/2
         Param2Change=fix(rand*D)+1;
         neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
             while(neighbour==i)
                 neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
             end;
         Employed2(i,Param2Change)=ceil(Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2);
         Employed2(i,Param2Change)=ceil(Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2);
          if (Employed2(i,Param2Change)<ABCOpts.lb)
              Employed2(i,Param2Change)=ABCOpts.lb;
          end;
         if (Employed2(i,Param2Change)>ABCOpts.ub)
             Employed2(i,Param2Change)=ABCOpts.ub;
         end;
         if (Employed2(i,Param2Change)<ABCOpts.lb)
              Employed2(i,Param2Change)=ABCOpts.lb;
          end;
         if (Employed2(i,Param2Change)>ABCOpts.ub)
             Employed2(i,Param2Change)=ABCOpts.ub;
         end;
         
     end;   
     % display(Employed2);
     if rand > Pr
         in1 = round(rand * N/2);
         if in1 == 0
             in1 = 1;
         end
         
         in2 = mod(in1 + 1,N/2);
        if in2 == 0
             in2 = 1;
         end
         [Employed2(in1,:),Employed2(in2,:)] = Crossover(Employed2(in1,:),Employed2(in2,:)); 
     end
% 
     ObjEmp2=feval(ABCOpts.ObjFun,Employed2,mat);
     %display(ObjEmp2);
     FitEmp2=calculateFitness(ObjEmp2);
%     % Start from here again
     [Employed ObjEmp FitEmp Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts);
%     
display(FitEmp);
%     %Normalize
     NormFit=FitEmp/sum(FitEmp);
     display(NormFit);
%     
%     %%% Onlooker phase  
 Employed2=Employed;
 i=1;
 t=0;
 while(t<ABCOpts.ColonySize/2)
     if(rand<NormFit(i))
         t=t+1;
         Param2Change=fix(rand*ABCOpts.Dim)+1;
         neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
             while(neighbour==i)
                 neighbour=fix(rand*(ABCOpts.ColonySize/2))+1;
             end;
          Employed2(i,:)=Employed(i,:);
          Employed2(i,Param2Change)=ceil(Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2);
          Employed2(i,Param2Change)=ceil(Employed(i,Param2Change)+(Employed(i,Param2Change)-Employed(neighbour,Param2Change))*(rand-0.5)*2);
          if (Employed2(i,Param2Change)<ABCOpts.lb)
              Employed2(i,Param2Change)=ABCOpts.lb;
          end;
         if (Employed2(i,Param2Change)>ABCOpts.ub)
             Employed2(i,Param2Change)=ABCOpts.ub;
          end;
          if (Employed2(i,Param2Change)<ABCOpts.lb)
              Employed2(i,Param2Change)=ABCOpts.lb;
          end;
         if (Employed2(i,Param2Change)>ABCOpts.ub)
             Employed2(i,Param2Change)=ABCOpts.ub;
          end;
     ObjEmp2=feval(ABCOpts.ObjFun,Employed2,mat);
     FitEmp2=calculateFitness(ObjEmp2);
     [Employed ObjEmp FitEmp Bas]=GreedySelection(Employed,Employed2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,Bas,ABCOpts,i);
%    
    end;
%     
     i=i+1;
     if (i==(ABCOpts.ColonySize/2)+1) 
         i=1;
     end;   
 end;
 display(FitEmp);
%     
%     
%     %%%Memorize Best
  CycleBestIndex=find(FitEmp==min(FitEmp));
  CycleBestIndex=CycleBestIndex(end);
  %display(CycleBestIndex);
  CycleBestParams=Employed(CycleBestIndex,:);
  display(CycleBestParams);
  CycleMin=ObjEmp(CycleBestIndex);
  display(CycleMin);
%  
 if CycleMin>GlobalMin 
        GlobalMin=CycleMin;
        GlobalParams=CycleBestParams;
  end
%  
    Globals(r,Cycle) = GlobalParams(1,1);
    Globalt(r,Cycle) = GlobalParams(1,2);
  GlobalMins(r,Cycle)=GlobalMin;
  
%  
  %% Scout phase
  ind=find(Bas==min(Bas));
 ind=ind(end);
 if (Bas(ind)<ABCOpts.Limit)
 Bas(ind)=0;
 Employed(ind,:)=ceil(abs((ABCOpts.ub-ABCOpts.lb)*(0.5-rand(1,D))*2));%+ABCOpts.lb;
 %Employed(ind,:)=(ABCOpts.ub-ABCOpts.lb)*(0.5-rand(1,D))*2;
% %message=strcat('burada',num2str(ind))
 end;
 ObjEmp=feval(ABCOpts.ObjFun,Employed,mat);
 FitEmp=calculateFitness(ObjEmp);
%     
% 
% 
     fprintf('Cycle=%d ObjVal=%g\n',Cycle,GlobalMin);
%    
    %Bestcycle(Cycle,:) = CycleBestParams; 
    %Bestcyval(Cycle) = CycleMin;
     Cycle=Cycle+1;
% 
 end % End of s
 Bestcycle(r,:) = CycleBestParams; 
    Bestcyval(r) = CycleMin;
 end; %end of runs
toc
%semilogy(mean(GlobalMins))
% Global = GlobalMins;
%  Cyc = rand()* ABCOpts.MaxCycles;
%  for r = 1: 5
%  for C = 1: Cyc
%     Global(r,C) = Global(r,C) * rand();
%  end
%  so = sort(Global(r,:));
%  end
%so =  sort(Global);
    %Gls = unique(Globals)
    
    %Glt = unique(Globalt)
    [c ,i] = max(GlobalMins)
    [cc , ro] = max(c)
    co = i(ro)
    SO = Globals(ro,co)
    TO = Globalt(ro,co)
plot(GlobalMins(1,:));
title('Mean of Best function values');
xlabel('cycles');
ylabel('Mean Values');
fprintf('Mean =%g Std=%g\n',mean(GlobalMins(:,end)),std(GlobalMins(:,end)));
  
