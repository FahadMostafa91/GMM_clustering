%Simulate Data from a Mixture of Gaussian Distributions
%Simulate data from a mixture of two bivariate Gaussian distributions using mvnrnd.
rng('default')  % For reproducibility

mu1 = [1 2.5]; % mean vector
sigma1 = [3 .2; .2 2.5]; % covariance matrix
mu2 = [-1 -2];  % mean vector
sigma2 = [2 0; 0 1.5]; % covariance matrix
X = [mvnrnd(mu1,sigma1,400); mvnrnd(mu2,sigma2,200)]; % data matrix
n = size(X,1);

figure
scatter(X(:,1),X(:,2),10,'ko')
%Fit the Simulated Data to a Gaussian Mixture Model
options = statset('Display','final'); 
gm = fitgmdist(X,2,'Options',options);
grid on
hold on
gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(gm,[x0,y0]),x,y);
fcontour(gmPDF,[-8,6])
title('Fitted GMM Contour and scatter plot')
hold off

%Cluster the Data Using the Fitted GMM

idx = cluster(gm,X);
cluster1 = (idx == 1); % |1| for cluster 1 membership
cluster2 = (idx == 2); % |2| for cluster 2 membership

figure
gscatter(X(:,1),X(:,2),idx,'rb','+o')
legend('Cluster 1','Cluster 2','Location','best')
grid on
%Fit a two-component Gaussian mixture model (GMM). Because there are two components, suppose that any data point with cluster membership posterior probabilities in the interval [0.4,0.6] can be a member of both clusters. 
gm = fitgmdist(X,2);
threshold = [3.5 0.7];

% find posterior pdfs
P = posterior(gm,X);
