n_queens(N, Solution) :-
    range(1, N, Columns),          
    permutation(Columns, Solution), 
    safe(Solution).  




range(N, N, [N]).
range(Start, End, [Start|Rest]) :-
    Start < End,
    Next is Start + 1,
    range(Next, End, Rest).

safe([]).
safe([Q|Others]) :-
    safe(Others),
    no_attack(Q, Others, 1).





no_attack(_, [], _).
no_attack(Q, [Q1|Others], D) :-
    Q =\= Q1 + D,
    Q =\= Q1 - D,
    D1 is D + 1,
    no_attack(Q, Others, D1).
