clc
clear

% Header text
disp('This script numerically differentiates the following functions:')
disp('[1] x^2 + x + 5')
disp('[2] cos(x)')
disp('[3] (sin(x) - 1)^4')
fprintf('\n')


% Input
choice = input("ENTER <1>, <2> or <3>: ");

if ~ismember(choice, [1,2,3])
    disp('ERROR: Invalid input. Terminating script.')
end

x0 = input("ENTER DESIRED X: ");
tol = input("ENTER ERROR TOLERANCE: ");


% Functions 1 2 3 and their analytic derivatives
f1 = @(x) x^2 + x + 5;
diff_f1 = @(x) 2*x + 1;

f2 = @(x) cos(x);
diff_f2 = @(x) -sin(x);

f3 = @(x) (sin(x) - 1)^4;
diff_f3 = @(x) 4*(sin(x) - 1)^3 * cos(x);

% Differentiation techniques
leftDiff = @(f, x, h) (f(x) - f(x - h))/h;
rightDiff = @(f, x, h) (f(x + h) - f(x))/h;
centerDiff = @(f, x, h) (f(x + h) - f(x - h))/(2*h);


% Actual numerical differentiation
function result = findDiff(numericalWay, analyticSoln, f, x, tol)
    err = 1;
    h0 = 0.1;
    while (err > tol)
        result = numericalWay(f, x, h0);
        err = abs(result - analyticSoln(x));

        h0 = h0/10;
    end
end

% Display results Function
function displayResults(ansL, ansR, ansC)
    fprintf('\nLeft differentiation method: %f', ansL)
    fprintf('\nRight differentiation method: %f', ansR)
    fprintf('\nCenter differentiation method: %f', ansC)
    fprintf('\n')
end


% Results

switch choice
    case 1
        left = findDiff(leftDiff, diff_f1, f1, x0, tol);
        right = findDiff(rightDiff, diff_f1, f1, x0, tol);
        center = findDiff(centerDiff, diff_f1, f1, x0, tol);
        
        displayResults(left, right, center)
    case 2
        left = findDiff(leftDiff, diff_f2, f2, x0, tol);
        right = findDiff(rightDiff, diff_f2, f2, x0, tol);
        center = findDiff(centerDiff, diff_f2, f2, x0, tol);
        
        displayResults(left, right, center)
    case 3
        left = findDiff(leftDiff, diff_f3, f3, x0, tol);
        right = findDiff(rightDiff, diff_f3, f3, x0, tol);
        center = findDiff(centerDiff, diff_f3, f3, x0, tol);
        
        displayResults(left, right, center)
    otherwise
end