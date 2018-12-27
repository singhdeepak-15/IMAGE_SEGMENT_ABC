
function [Colony Obj Fit oBas]=GreedySelection(Colony1,Colony2,ObjEmp,ObjEmp2,FitEmp,FitEmp2,fbas,ABCOpts,i)

oBas=fbas;
Obj=ObjEmp;
Fit=FitEmp;
Colony=Colony1;
if (nargin==8)
for ind=1:size(Colony1,1)
    if (FitEmp2(ind)<FitEmp(ind))
        oBas(ind)=fbas(ind)+1;
        Fit(ind)=FitEmp(ind);
        Obj(ind)=ObjEmp(ind);
        Colony(ind,:)=Colony1(ind,:);
    else
        oBas(ind)=0;
        Fit(ind)=FitEmp2(ind);
        Obj(ind)=ObjEmp2(ind);
        Colony(ind,:)=Colony2(ind,:);
    end;
end; %for
end; %if
if(nargin==9)
    ind=i;
    if (FitEmp2(ind)< FitEmp(ind))
        oBas(ind)=0;
        Fit(ind)=FitEmp2(ind);
        Obj(ind)=ObjEmp2(ind);
        Colony(ind,:,:)=Colony2(ind,:,:);
    else
        oBas(ind)=fbas(ind)+1;
        Fit(ind)=FitEmp(ind);
        Obj(ind)=ObjEmp(ind);
        Colony(ind,:,:)=Colony1(ind,:,:);
    end;
end; 
    