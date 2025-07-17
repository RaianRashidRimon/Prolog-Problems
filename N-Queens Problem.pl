% Main predicate to solve the N-Queens problem
n_queens(N, Solution) :-
    range(1, N, Columns),           % Generate list of columns [1..N]
    permutation(Columns, Solution), % Generate a permutation (each queen in a different column)
    safe(Solution).                 % Check if the arrangement is safe

% Generate a range of numbers from Start to End
range(N, N, [N]).
range(Start, End, [Start|Rest]) :-
    Start < End,
    Next is Start + 1,
    range(Next, End, Rest).

% Check that no two queens attack each other
safe([]).
safe([Q|Others]) :-
    safe(Others),
    no_attack(Q, Others, 1).

% Check that Q doesn't attack any other queen diagonally
no_attack(_, [], _).
no_attack(Q, [Q1|Others], D) :-
    Q =\= Q1 + D,
    Q =\= Q1 - D,
    D1 is D + 1,
    no_attack(Q, Others, D1).
