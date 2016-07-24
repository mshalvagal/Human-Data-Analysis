function xN = interpolate(x,N)

xN = zeros(N*(size(x)-1)+1);
xN(1:N:end) = x;
for i = 1:length(x)-1
    for j = 1:N
        xN(N*(i-1)+j) = x(i);
    end
end