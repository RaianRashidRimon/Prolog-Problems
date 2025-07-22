:- use_module(library(random)).

% Main entry point to solve the N-Queens problem
solve_n_queens(N, Solution) :-
    initialize_random_board(N, InitialState),
    hill_climbing(InitialState, Solution).

% Initialize a random placement of queens (one per row)
initialize_random_board(N, Board) :-
    length(Board, N),
    initialize_board(N, Board).

initialize_board(_, []).
initialize_board(N, [X|Xs]) :-
    N1 is N + 1,  % Calculate N+1 first, then pass to random/3
    random(1, N1, X),  % Generate a random column (1 to N)
    initialize_board(N, Xs).

% Hill climbing search algorithm
hill_climbing(CurrentState, Solution) :-
    conflicts(CurrentState, CurrentConflicts),
    (CurrentConflicts =:= 0 ->
        % No conflicts, we found a solution
        Solution = CurrentState
    ;
        % Find the best neighbor
        find_best_neighbor(CurrentState, 1, BestNeighbor, BestConflicts),
        % If best neighbor is better than current state, continue hill climbing
        (BestConflicts < CurrentConflicts ->
            hill_climbing(BestNeighbor, Solution)
        ;
            % If we're stuck in a local minimum, restart with a new random state
            length(CurrentState, N),
            initialize_random_board(N, NewState),
            hill_climbing(NewState, Solution)
        )
    ).

% Find the best neighbor by trying to move each queen to a better position
find_best_neighbor(State, RowIdx, BestNeighbor, BestConflicts) :-
    length(State, N),
    (RowIdx > N ->
        % We've checked all rows, return the current state as best
        BestNeighbor = State,
        conflicts(State, BestConflicts)
    ;
        % Try all possible positions for the queen in the current row
        conflicts(State, StateConflicts),
        find_best_position(State, RowIdx, 1, State, StateConflicts, N, CurrentBestState, _CurrentBestConflicts),
        % Continue with the next row
        NextRowIdx is RowIdx + 1,
        find_best_neighbor(CurrentBestState, NextRowIdx, BestNeighbor, BestConflicts)
    ).

% Find the best position for the queen in the specified row
find_best_position(OriginalState, RowIdx, ColIdx, CurrentBestState, CurrentBestConflicts, N, BestState, BestConflicts) :-
    (ColIdx > N ->
        % We've checked all columns, return the current best
        BestState = CurrentBestState,
        BestConflicts = CurrentBestConflicts
    ;
        % Create a new state with the queen moved to the current column
        replace_nth(OriginalState, RowIdx, ColIdx, NewState),
        conflicts(NewState, NewConflicts),
        
        % Keep the state with fewer conflicts
        (NewConflicts < CurrentBestConflicts ->
            NextBestState = NewState,
            NextBestConflicts = NewConflicts
        ;
            NextBestState = CurrentBestState,
            NextBestConflicts = CurrentBestConflicts
        ),
        
        % Try the next column
        NextColIdx is ColIdx + 1,
        find_best_position(OriginalState, RowIdx, NextColIdx, NextBestState, NextBestConflicts, N, BestState, BestConflicts)
    ).

% Replace the Nth element of a list
replace_nth(List, N, Value, NewList) :-
    replace_nth(List, 1, N, Value, NewList).

replace_nth([_|T], N, N, Value, [Value|T]) :- !.
replace_nth([H|T], Acc, N, Value, [H|NewT]) :-
    NextAcc is Acc + 1,
    replace_nth(T, NextAcc, N, Value, NewT).

% Count the number of conflicts in a board state
conflicts(Board, Conflicts) :-
    pairs(Board, Pairs),
    count_attacking_pairs(Pairs, Conflicts).

% Generate all pairs of queens
pairs(Board, Pairs) :-
    findall((Row1, Col1, Row2, Col2),
            (nth1(Row1, Board, Col1),
             nth1(Row2, Board, Col2),
             Row1 < Row2),  % Avoid duplicates and self-pairs
            Pairs).

% Count how many pairs of queens are attacking each other
count_attacking_pairs([], 0).
count_attacking_pairs([(Row1, Col1, Row2, Col2)|Rest], Count) :-
    count_attacking_pairs(Rest, RestCount),
    (attacking(Row1, Col1, Row2, Col2) ->
        Count is RestCount + 1
    ;
        Count = RestCount
    ).

% Check if two queens are attacking each other
attacking(Row1, Col1, Row2, Col2) :-
    Col1 =:= Col2;  % Same column
    Row1 - Col1 =:= Row2 - Col2;  % Same diagonal (/)
    Row1 + Col1 =:= Row2 + Col2.  % Same diagonal (\)

% Utility predicates for displaying the solution
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

% Example usage:
% ?- solve_n_queens(8, Solution), print_solution(Solution).