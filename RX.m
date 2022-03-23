function D = RX(X)
x=X';
[N M] = size(x);

X_mean = mean(x.').';

x= x - repmat(X_mean, [1 M]);

Sigma = (x* x')/M;

Sigma_inv = inv(Sigma);
for m = 1:M
 D(m) = x(:, m)' * Sigma_inv * x(:, m);
end
