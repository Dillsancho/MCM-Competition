function [belief,TFinal,FMu,WFinal] = bayes(scores) 
    
    theta = chebfun('x',[0 1]); %chebfun function x over [0 1]
    E = @(f,prob) sum(f.*prob); %Expected value
    Var = @(f,prob) E( (f-E(f,prob)).^2, prob ); %Variance
    phi = @(mu,sigma) exp( -((theta-mu)./sigma).^2/2 ); %prior distribution to belief of theta
    prior = phi(.7,.3);  prior = prior/sum(prior); %Example  of prior distribution with expected value = 0.7 and variance = 0.3
%     plot(prior,'linewidth',2); %Example graph of prior
    m = length(scores);
    Traditional = cumsum(scores) ./ (1:m);
    sump = 0;
    for p = 1:m
        sump = sump + (scores(p)-Traditional).^2;
    end    
    sigma = 0.6; %sqrt((1/n-1.5) * sump); % GET BAYENSIAN ESTIMATOR RATHER THAN SET VALUE FOR SIGMA
    q = chebfun( @(theta) sum( phi(theta,sigma) ), [0 1], 'vectorize' ); %use for normalization
    likelihood = @(x) phi(x,sigma)./q; % normalized phi function

    belief = prior;
     %Traditional way of calculating final with equal weights  
    for k = 1:m     %updating your belief function with given marks
        like = likelihood(scores(k));
        b = belief(:,k).*like;
        b = b / sum(b);

        belief(:,k+1) = b;
        Mu(k) = E(theta,b); % Expected value of updated belief function
        Sig2(k) = Var(theta,b); % Variance of updated belief function
        [~,Mode(k)] = max(b);
        
        
    end

%     fprintf('Method       %6s %6s %6s %6s\n','m-3','m-2','m-1','m');
%     fprintf('------------------------------------------------\n');
%     fprintf('Traditional     %6.3f %6.3f %6.3f %6.3f\n',Traditional(m-3:m));
%     fprintf('Bayes Mode      %6.3f %6.3f %6.3f %6.3f\n',Mode(m-3:m));
%     fprintf('Bayes Mean      %6.3f %6.3f %6.3f %6.3f\n',Mu(m-3:m));
%     fprintf('Std dev         %6.3f %6.3f %6.3f %6.3f\n',sqrt(Sig2(m-3:m)));
%       std_dev = sqrt(Sig2(m-3:m));
%       T = table;
%       T.Traditional = Traditional';
%       T.Mu = Mu';
%       T.Mode = Mode';
%       T.std_dev = std_dev'
    TFinal = Traditional(m);
    FMu = Mu(m);
    Tuts = (cumsum(scores(1:m-2)))/(m-2);
    (1/3)*Tuts(length(Tuts));
    (2/3)*(scores(m) + scores(m-1));
    WFinal = (1/3)*Tuts(length(Tuts)) + (2/6)*(scores(m) + scores(m-1));
    
    
end

