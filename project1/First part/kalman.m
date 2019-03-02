function [x_hat] = kalman(A,B,C,Rn,Qn,eta,xsi,K,alfa,sigma,T)
    
    N = length(T) - 1;
    I = eye(size(A, 1));
    
    x_hat_minus(:, 1) = alfa;
    P_minus(:, :, 1) = sigma;
    
    Kf(:, :, 1) = P_minus(:, :, 1)*C'*inv(C*P_minus(:, :, 1)*C' + Qn);
    y(:, 1) = C*x_hat_minus(:, 1) + eta(:, 1);
    
    x_hat(:, 1) = x_hat_minus(:, 1) + Kf(:, :, 1)*(y(:, 1) - C*x_hat_minus(:, 1));
    P(:, :, 1) = (I - Kf(:, :, 1)*C)*P_minus(:, :, 1);
    
    u(:, 1) = K(:, :, 1)*x_hat(:, 1);
    
    for i = 2 : N
        
        % predizione
        x_hat_minus(:, i) = A*x_hat(:, i-1) + B*u(:, i-1);
        P_minus(:, :, i) = A*P(:, :, i-1)*A' + Rn;
        
        % guadagno di correzione
        Kf(:, :, i) = P_minus(:, :, i)*C'*inv(C*P_minus(:, :, i)*C' + Qn);
        
        y(:, i) = C*x_hat_minus(:, i) + eta(:, i);
       
        % stima
        x_hat(:, i) = x_hat_minus(:, i) + Kf(:, :, i)*(y(:, i) - C*x_hat_minus(:, i));
        P(:, :, i) = (I - Kf(:, :, i)*C)*P_minus(:, :, i);
        
        % controllo
        u(:, i) = K(:, :, i)*x_hat(:, i);
        
    end
end

