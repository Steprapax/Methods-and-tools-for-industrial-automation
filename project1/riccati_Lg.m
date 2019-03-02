function [K, Lg, g] = riccati_Lg(A, B, C, Q, Qf, R, T, x_ref)

    N = length(T)-1;
    I = eye(length(A(:, 1)));

    % calcolo P
    V = C' * Q * C;
    E = B * inv(R) * B';
    P(:, :, N+1) = C' * Qf * C;
    for i = N : -1 : 1
        P(:,:,i) = A'*P(:, :, i+1)*inv(I + E*P(:, :, i+1))*A + V;
    end

    % calcolo g
    W = C' * Q;
    g(:, N+1) = C' * Qf * x_ref(:, N+1);
    for i = N : -1 : 1
        g(:, i) = A' * (I - (inv(inv(P(:, :, i+1)) + E))*E) * g(:, i+1) + W*x_ref(:, i);
    end

    % calcolo K
    for i = 1 : N
        K(:, :, i) = inv(R + B'*P(:, :, i+1)*B)*B'*P(:, :, i+1)*A;
    end

    % calcolo Lg
    for i = 1 : N
        Lg(:, :, i) = inv(R + B'*P(:, :, i+1)*B)*B';
    end
    
end