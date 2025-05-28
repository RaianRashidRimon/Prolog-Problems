% Division program
division(X, Y, Result) :-
    Y =\= 0,  % Ensure no division by 0
    Result is X / Y.
