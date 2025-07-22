:- use_module(library(random)).

solve_n_queens(N, Solution) :-
    initialize_random_board(N, InitialState),
    hill_climbing(InitialState, Solution).

initialize_random_board(N, Board) :-
    length(Board, N),
    initialize_board(N, Board).

initialize_board(_, []).
initialize_board(N, [X|Xs]) :-
    N1 is N + 1,
    random(1, N1, X),
    initialize_board(N, Xs).

hill_climbing(CurrentState, Solution) :-
    conflicts(CurrentState, CurrentConflicts),
    (CurrentConflicts =:= 0 ->
        Solution = CurrentState
    ;
        find_best_neighbor(CurrentState, 1, BestNeighbor, BestConflicts),
        (BestConflicts < CurrentConflicts ->
            hill_climbing(BestNeighbor, Solution)
        ;
            length(CurrentState, N),
            initialize_random_board(N, NewState),
            hill_climbing(NewState, Solution)
        )
    ).

find_best_neighbor(State, RowIdx, BestNeighbor, BestConflicts) :-
    length(State, N),
    (RowIdx > N ->
        BestNeighbor = State,
        conflicts(State, BestConflicts)
    ;
        conflicts(State, StateConflicts),
        find_best_position(State, RowIdx, 1, State, StateConflicts, N, CurrentBestState, _),
        NextRowIdx is RowIdx + 1,
        find_best_neighbor(CurrentBestState, NextRowIdx, BestNeighbor, BestConflicts)
    ).

find_best_position(OriginalState, RowIdx, ColIdx, CurrentBestState, CurrentBestConflicts, N, BestState, BestConflicts) :-
    (ColIdx > N ->
        BestState = CurrentBestState,
        BestConflicts = CurrentBestConflicts
    ;
        replace_nth(OriginalState, RowIdx, ColIdx, NewState),
        conflicts(NewState, NewConflicts),
        (NewConflicts < CurrentBestConflicts ->
            NextBestState = NewState,
            NextBestConflicts = NewConflicts
        ;
            NextBestState = CurrentBestState,
            NextBestConflicts = CurrentBestConflicts
        ),
        NextColIdx is ColIdx + 1,
        find_best_position(OriginalState, RowIdx, NextColIdx, NextBestState, NextBestConflicts, N, BestState, BestConflicts)
    ).

replace_nth(List, N, Value, NewList) :-
    replace_nth(List, 1, N, Value, NewList).

replace_nth([_|T], N, N, Value, [Value|T]) :- !.
replace_nth([H|T], Acc, N, Value, [H|NewT]) :-
    NextAcc is Acc + 1,
    replace_nth(T, NextAcc, N, Value, NewT).

conflicts(Board, Conflicts) :-
    pairs(Board, Pairs),
    count_attacking_pairs(Pairs, Conflicts).

pairs(Board, Pairs) :-
    findall((Row1, Col1, Row2, Col2),
            (nth1(Row1, Board, Col1),
             nth1(Row2, Board, Col2),
             Row1 < Row2),
            Pairs).

count_attacking_pairs([], 0).
count_attacking_pairs([(Row1, Col1, Row2, Col2)|Rest], Count) :-
    count_attacking_pairs(Rest, RestCount),
    (attacking(Row1, Col1, Row2, Col2) ->
        Count is RestCount + 1
    ;
        Count = RestCount
    ).

attacking(Row1, Col1, Row2, Col2) :-
    Col1 =:= Col2;
    Row1 - Col1 =:= Row2 - Col2;
    Row1 + Col1 =:= Row2 + Col2.

print_solution(Board) :-
    length(Board, N),
    format("N-Queens Solution (N=~w):~n", [N]),
    print_board(Board, N, 1).

print_board(_, N, Row) :- Row > N, !.
print_board(Board, N, Row) :-
    print_row(Board, N, Row, 1),
    nl,
    NextRow is Row + 1,
    print_board(Board, N, NextRow).

print_row(_, N, _, Col) :- Col > N, !.
print_row(Board, N, Row, Col) :-
    nth1(Row, Board, QueenCol),
    (Col =:= QueenCol ->
        write('Q ')
    ;
        write('. ')
    ),
    NextCol is Col + 1,
    print_row(Board, N, Row, NextCol).
