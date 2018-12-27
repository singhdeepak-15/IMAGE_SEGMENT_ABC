function val = Hgrey(sol,mat)
%for i = 1:length(sol)
[m,n,c] = size(sol);
for it = 1:m
    s = sol(it,1);
    t = sol(it,2);
    imq2 = im2double(mat(1:s,t:end));
    imq3 = im2double(mat(s:end,t:end));
    entro = 0;
    for i = 1:size(imq2,1)
        for j = 1:size(imq2,2)
            entro = entro - (imq2(i,j)*log(imq2(i,j) + eps));
         end
    end
    entro;
    entro2 = 0;
    for i = 1:size(imq3,1)
        for j = 1:size(imq3,2)
            entro2 = entro2 - (imq3(i,j)*log(imq3(i,j) + eps));
        end
    end
    Ho = entro;
    Hb = entro2;
    val(it) = (1/2)*(Ho + Hb);
end