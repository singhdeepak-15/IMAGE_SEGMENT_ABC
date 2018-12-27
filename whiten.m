function [X] = whiten(X,fudgefactor)
X = bsxfun(@minus, X, uint8(mean(X)));
A = X'.*X;
[V,D] = eig(double(A));
X = X*V*diag(1./(diag(D)+fudgefactor).^(1/2))*V';
end