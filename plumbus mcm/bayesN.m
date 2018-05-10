function [ CMu ] = bayesN( scores , X1 , X2)
    theta = chebfun('x',[0 1]); %chebfun function x over [0 1]
    E = @(f,prob) sum(f.*prob); %Expected value
    Var = @(f,prob) E( (f-E(f,prob)).^2, prob ); %Variance
    phi = @(mu,sigma) exp( -((theta-mu)./sigma).^2/2 ); %prior distribution to belief of theta
    prior = phi(X1,X2);  prior = prior/sum(prior); %Example  of prior distribution with expected value = 0.7 and variance = 0.3
    %     plot(prior,'linewidth',2); %Example graph of prior
    sigma = 0.25;
    q = chebfun( @(theta) sum( phi(theta,sigma) ), [0 1], 'vectorize' ); %use for normalization
    likelihood = @(x) phi(x,sigma)./q; % normalized phi function

    belief = prior;
    m = length(scores);

    for k = 1:m     %updating your belief function with given marks
        like = likelihood(scores(k));
        b = belief(:,k).*like;
        b = b / sum(b);

        belief(:,k+1) = b;
        Mu(k) = E(theta,b); % Expected value of updated belief function
        Sig2(k) = Var(theta,b); % Variance of updated belief function
        
        
    end
    CMu = Mu(m);

end

