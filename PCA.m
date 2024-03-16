%% Initalize
clear
clc

%% Import Data
% Define the Excel file and sheet index
excelFile = "./crops-yield-changes-hadcm3-sres.xls";
% If not working
%excelFile = "C:/Users/.../crops-yield-changes-hadcm3-sres.xls";

% Read the third table from the specified Excel sheet
data = readtable(excelFile, 'Sheet', 3);
clearvars excelFile

% Remove the duplicate name columns
data(:, [2, 3]) = [];
data.COUNTRY = []

%% Descriptive statistics
%summary(data)

%% PCA
% Original matrix
temp = data;
temp(:, 1) = [];   % remove all columns containing strings
X = table2array(temp);
X(isnan(X)) = 0;
X

rows = size(X); rows = rows(1)
columns = size(X); columns = columns(2)

% Center reduce the data
Xs = X;

r = sqrt(rows);
for i=1:columns
    m = mean(Xs(:,i));
    s = std(Xs(:,i));
    for j=1:rows
        Xs(j,i) = (Xs(j,i) - m) / (s*r);
    end
end
clearvars i j r m s
Xs

% Compute correlation matrix
R = Xs' * Xs

% Find its eigenvalues
E = eig(R);

% Find the oqe (number of axes needed)
E = sort(E, 'descend')
oqe = (E(1)+E(2)+E(3)+E(4))*100 / columns

% diagonal matrix of eigenvalues (U is the change of basis matrix)
[U, L] = eig(R);
L

% matrix of principal components
F = Xs * U

% Compute the saturation matrix (coordinates of variables in the new basis)
S = Xs' * F * L


