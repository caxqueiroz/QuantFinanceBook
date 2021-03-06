function CEV_ImpliedVolatility
close all; clc;

% Market ZCB

P0T       = @(t)exp(-0.05*t);
T         = 1.0;

% Choose between call and put option

CP = 'c';
K = linspace(0.4,1.7,22);

% CEV parameters

beta  = 0.25;
sigma = 0.2;

% Forward rate 

frwd = 1.0/P0T(T);

% Effect of sigma

sigmaV = [0.1, 0.2, 0.3, 0.4];
ivM = zeros(length(K),length(sigmaV));
argLegend = cell(4,1);
idx = 1;
for i=1:length(sigmaV)
    sigmaTemp = sigmaV(i);
    optPrice  = CEVModel_CallPrice(CP,K,P0T,beta,sigmaTemp,frwd,T);
    for j = 1:length(K)    
        optPriceFrwd = optPrice(j)/P0T(T);
        ivM(j,i)  = ImpliedVolatilityBlack76(CP,optPriceFrwd,K(j),T,frwd,0.3)*100;
    end
    argLegend{idx} = sprintf('sigma=%.2f',sigmaTemp);
    idx = idx + 1;
end
MakeFigure(K, ivM,argLegend,'Effect of \sigma on implied volatility')
xlim([min(K),max(K)])

% Effect of beta

betaV = [0.1,0.3,1.3, 1.5];
ivM = zeros(length(K),length(betaV));
argLegend = cell(4,1);
idx = 1;
for i=1:length(betaV)
    betaTemp = betaV(i);
    optPrice  = CEVModel_CallPrice(CP,K,P0T,betaTemp,sigma,frwd,T);
    for j = 1:length(K)    
        optPriceFrwd = optPrice(j)/P0T(T);
        ivM(j,i)  = ImpliedVolatilityBlack76(CP,optPriceFrwd,K(j),T,frwd,0.3)*100;
    end
    argLegend{idx} = sprintf('beta=%.2f',betaTemp);
    idx = idx + 1;
end
MakeFigure(K, ivM,argLegend,'Effect of \beta on implied volatility')
xlim([min(K),max(K)])


function impliedVol = ImpliedVolatilityBlack76(CP,frwdMarketPrice,K,T,frwdStock,initialVol)
func = @(sigma) (BS_Call_Put_Option_Price(CP,frwdStock,K,sigma,T,0.0) - frwdMarketPrice).^1.0;
impliedVol = fzero(func,initialVol);
 
% Closed-form expression of European call/put option with Black-Scholes formula

function value=BS_Call_Put_Option_Price(CP,S_0,K,sigma,tau,r)

% Black-Scholes call option price

d1 = (log(S_0 ./ K) + (r + 0.5 * sigma^2) * tau) / (sigma * sqrt(tau));
d2 = d1 - sigma * sqrt(tau);
if lower(CP) == 'c' || lower(CP) == 1
 value =normcdf(d1) * S_0 - normcdf(d2) .* K * exp(-r * tau);
elseif lower(CP) == 'p' || lower(CP) == -1
 value =normcdf(-d2) .* K*exp(-r*tau) - normcdf(-d1)*S_0;
end

function value = CEVModel_CallPrice(CP,K,P0T,beta,sigma,frwd,T)
a=K.^(2*(1-beta))./((1-beta)^2*sigma^2*T);
b=1/(1-beta);
c=frwd^(2*(1-beta))/((1-beta)^2*sigma^2*T);

if beta<1 && CP=='c' 
    value=frwd*P0T(T)*(1-ncx2cdf(a,b+2,c))- K*P0T(T).*ncx2cdf(c,b,a);
elseif beta<1 && CP=='p'
    value=K*P0T(T).*(1-ncx2cdf(c,b,a))-frwd*P0T(T)*ncx2cdf(a,b+2,c);
elseif beta>1 && CP== 'c'
    value=frwd*P0T(T)*(1-ncx2cdf(c,2-b,a))- K*P0T(T).*ncx2cdf(a,-b,c);
elseif beta>1 && CP== 'p' 
    value=K*P0T(T).*(1-ncx2cdf(a,2-b,c))-frwd*P0T(T)*ncx2cdf(c,-b,a);
end

function MakeFigure(X1, YMatrix1, argLegend,titleIn)

%CREATEFIGURE(X1,YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 16-Jan-2012 15:26:40

% Create figure

figure1 = figure('InvertHardcopy','off',...
    'Colormap',[0.061875 0.061875 0.061875;0.06875 0.06875 0.06875;0.075625 0.075625 0.075625;0.0825 0.0825 0.0825;0.089375 0.089375 0.089375;0.09625 0.09625 0.09625;0.103125 0.103125 0.103125;0.11 0.11 0.11;0.146875 0.146875 0.146875;0.18375 0.18375 0.18375;0.220625 0.220625 0.220625;0.2575 0.2575 0.2575;0.294375 0.294375 0.294375;0.33125 0.33125 0.33125;0.368125 0.368125 0.368125;0.405 0.405 0.405;0.441875 0.441875 0.441875;0.47875 0.47875 0.47875;0.515625 0.515625 0.515625;0.5525 0.5525 0.5525;0.589375 0.589375 0.589375;0.62625 0.62625 0.62625;0.663125 0.663125 0.663125;0.7 0.7 0.7;0.711875 0.711875 0.711875;0.72375 0.72375 0.72375;0.735625 0.735625 0.735625;0.7475 0.7475 0.7475;0.759375 0.759375 0.759375;0.77125 0.77125 0.77125;0.783125 0.783125 0.783125;0.795 0.795 0.795;0.806875 0.806875 0.806875;0.81875 0.81875 0.81875;0.830625 0.830625 0.830625;0.8425 0.8425 0.8425;0.854375 0.854375 0.854375;0.86625 0.86625 0.86625;0.878125 0.878125 0.878125;0.89 0.89 0.89;0.853125 0.853125 0.853125;0.81625 0.81625 0.81625;0.779375 0.779375 0.779375;0.7425 0.7425 0.7425;0.705625 0.705625 0.705625;0.66875 0.66875 0.66875;0.631875 0.631875 0.631875;0.595 0.595 0.595;0.558125 0.558125 0.558125;0.52125 0.52125 0.52125;0.484375 0.484375 0.484375;0.4475 0.4475 0.4475;0.410625 0.410625 0.410625;0.37375 0.37375 0.37375;0.336875 0.336875 0.336875;0.3 0.3 0.3;0.28125 0.28125 0.28125;0.2625 0.2625 0.2625;0.24375 0.24375 0.24375;0.225 0.225 0.225;0.20625 0.20625 0.20625;0.1875 0.1875 0.1875;0.16875 0.16875 0.16875;0.15 0.15 0.15],...
    'Color',[1 1 1]);

% Create axes
%axes1 = axes('Parent',figure1,'Color',[1 1 1]);

axes1 = axes('Parent',figure1);
grid on

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[45 160]);
% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[19 26]);
% Uncomment the following line to preserve the Z-limits of the axes
% zlim(axes1,[-1 1]);

box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
% plot1 = plot(X1,YMatrix1,'Parent',axes1,'MarkerEdgeColor',[0 0 0],...
%     'LineWidth',1,...
%     'Color',[0 0 0]);

plot1 = plot(X1,YMatrix1,'Parent',axes1,...
    'LineWidth',1.5);
set(plot1(1),'Marker','diamond','DisplayName',argLegend{1});
set(plot1(2),'Marker','square','LineStyle','-.',...
    'DisplayName',argLegend{2});
set(plot1(3),'Marker','o','LineStyle','-.','DisplayName',argLegend{3});
set(plot1(4),'DisplayName',argLegend{4});

% Create xlabel

xlabel({'K'});

% Create ylabel

ylabel({'implied volatility [%]'});

% Create title

title(titleIn);

% Create legend

legend1 = legend(axes1,'show');
set(legend1,'Color',[1 1 1]);
