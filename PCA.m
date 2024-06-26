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
data.Fips_code = []
data.COUNTRY = []

%% Descriptive statistics
%summary(data)

%% PCA
% Original matrix
temp = data;
temp(:, 1) = [];
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

% diagonal matrix of eigenvalues (U is the change of basis matrix)
[U, L] = eig(R);
L

% matrix of principal components (coordinates of individuals in the new basis)
F = Xs * U

% Compute the saturation matrix (coordinates of variables in the new basis)
S = Xs' * F * L^(-1/2)
%writematrix(S,'S.xls')

%% Plot
% Find the eigenvalues of the correlation matrix
E = eig(R);

% Find the oqe (number of axes needed)
E = sort(E, 'descend')
oqe = (E(1)+E(2)+E(3)+E(4))*100 / columns

% axis 1 col 153
% axis 2 col 152
% axis 3 col 151
% axis 4 col 150

% Find the coordinates of the individuals in the new basis
disp("Main componants table:")
disp("Axis 1, Axis 2, Axis 3, Axis 4")
coord = [F(1:end,153:-1:150)]

% Compute the qlt
temp = coord.^2;
temp = sum(temp);

qlt = coord;
for i=1:4
    for j=1:rows
        qlt(j,i) = (qlt(j,i)^2) / temp(i);
    end
end
clearvars i j
qlt

%% Graphical presentation plan 1-2
col1 = 1;
col2 = 2;
style = 'r+';

% Find indices where values of qlt(:, 1) are greater than 0.1
% Indices represent the countries well represented by axis 1
indices = qlt(:, col1) > 0.01;  % We consider the first column of 'qlt'
% Filter rows from 'coord' using the indices where 'qlt' > 0.1
filtered_coord = coord(indices, :);
% Plot the values with x component from the 1st column and y component from the 2nd column
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);
hold on

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% Same for indices where values of qlt(:, 2) are greater than 0.001
% Indices represent the countries well represented by axis 2
indices = qlt(:, col2) > 0.001;
filtered_coord = coord(indices, :);
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);% 'bo');

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

title(sprintf('Graphical presentation plan %d-%d', col1, col2));
grid on
xlim([-max(abs(filtered_coord(:, col1))), max(abs(filtered_coord(:, col1)))]);
ylim([-max(abs(filtered_coord(:, col2))), max(abs(filtered_coord(:, col2)))]);
hold off

%% Graphical presentation plan 1-3
col1 = 1;
col2 = 3;
style = 'b+';

% Find indices where values of qlt(:, 1) are greater than 0.1
% Indices represent the countries well represented by axis 1
indices = qlt(:, col1) > 0.01;  % We consider the first column of 'qlt'
% Filter rows from 'coord' using the indices where 'qlt' > 0.1
filtered_coord = coord(indices, :);
% Plot the values with x component from the 1st column and y component from the 2nd column
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);
hold on

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% Same for indices where values of qlt(:, 2) are greater than 0.001
% Indices represent the countries well represented by axis 2
indices = qlt(:, col2) > 0.001;
filtered_coord = coord(indices, :);
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);% 'bo');

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

title(sprintf('Graphical presentation plan %d-%d', col1, col2));
grid on
xlim([-max(abs(filtered_coord(:, col1))), max(abs(filtered_coord(:, col1)))]);
ylim([-max(abs(filtered_coord(:, col2))), max(abs(filtered_coord(:, col2)))]);
hold off

%% Graphical presentation plan 2-3
col1 = 2;
col2 = 3;
style = 'g+';

% Find indices where values of qlt(:, 1) are greater than 0.1
% Indices represent the countries well represented by axis 1
indices = qlt(:, col1) > 0.001;  % We consider the first column of 'qlt'
% Filter rows from 'coord' using the indices where 'qlt' > 0.1
filtered_coord = coord(indices, :);
% Plot the values with x component from the 1st column and y component from the 2nd column
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);
hold on

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

% Same for indices where values of qlt(:, 2) are greater than 0.001
% Indices represent the countries well represented by axis 2
indices = qlt(:, col2) > 0.001;
filtered_coord = coord(indices, :);
plot(filtered_coord(:, col1), filtered_coord(:, col2), style);% 'bo');

% Plot text labels for each point
country_names = data.ISO3v10(indices);
for i = 1:length(country_names)
    text(filtered_coord(i, col1), filtered_coord(i, col2), country_names{i}, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
end

title(sprintf('Graphical presentation plan %d-%d', col1, col2));
grid on
xlim([-max(abs(filtered_coord(:, col1))), max(abs(filtered_coord(:, col1)))]);
ylim([-max(abs(filtered_coord(:, col2))), max(abs(filtered_coord(:, col2)))]);
hold off
