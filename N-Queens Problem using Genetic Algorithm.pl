% N-Queens Problem Using Genetic Algorithm in Prolog

% Entry point to solve the N-Queens problem
solve_n_queens(N) :-
    generate_population(100, N, Population),
    max_generations(MaxGenerations),
    evolve(Population, 0, MaxGenerations, Solution),
    format('Solution found: ~w~n', [Solution]).

% Maximum generations to run the algorithm
max_generations(1000).

% Generate initial population of size Num
generate_population(0, _, []) :- !.
generate_population(Num, N, [Individual|Rest]) :-
    Num > 0,
    generate_individual(N, Individual),
    NewNum is Num - 1,
    generate_population(NewNum, N, Rest).

% Generate a random individual (a permutation of [1..N])
generate_individual(N, Individual) :-
    numlist(1, N, L),
    random_permutation(L, Individual).

% Fitness function: counts the number of non-attacking queen pairs
fitness(Individual, Score) :-
    findall((I, J),
            (nth1(I, Individual, Qi),
             nth1(J, Individual, Qj),
             I < J,
             abs(Qi - Qj) =\= abs(I - J)),
            SafePairs),
    length(SafePairs, Score).

% Evolution loop with max generation count
evolve(Population, _, _, Solution) :-
    member(Solution, Population),
    fitness(Solution, Score),
    length(Solution, N),
    MaxScore is N * (N - 1) // 2,
    Score =:= MaxScore, !.

evolve(_, Generation, MaxGeneration, _) :-
    Generation >= MaxGeneration,
    write('Maximum generations reached without solution.\n'), !.

evolve(Population, Generation, MaxGeneration, Solution) :-
    Generation < MaxGeneration,
    evaluate_population(Population, ScoredPopulation),
    select_parents(ScoredPopulation, Parents),
    crossover_population(Parents, Children),
    mutate_population(Children, MutatedChildren),
    NewGeneration is Generation + 1,
    evolve(MutatedChildren, NewGeneration, MaxGeneration, Solution).

% Evaluate each individual with fitness
evaluate_population([], []).
evaluate_population([Individual|Rest], [(Score, Individual)|EvaluatedRest]) :-
    fitness(Individual, Score),
    evaluate_population(Rest, EvaluatedRest).

% Select top 50% as parents
select_parents(ScoredPopulation, Parents) :-
    sort(0, @>=, ScoredPopulation, Sorted),
    length(Sorted, Len),
    Half is Len // 2,
    length(Parents, Half),
    append(Parents, _, Sorted).

% Crossover selected parents to create children
crossover_population([], []).
crossover_population([(_, P1), (_, P2)|Rest], [Child1, Child2|Children]) :-
    crossover(P1, P2, Child1),
    crossover(P2, P1, Child2),
    crossover_population(Rest, Children).
crossover_population(_, []).  % In case of odd number, ignore last

% Crossover operation (Order Crossover)
crossover(P1, P2, Child) :-
    length(P1, Len),
    random_between(1, Len, Start),
    random_between(Start, Len, End),
    extract_segment(P1, Start, End, Segment),
    subtract(P2, Segment, Remaining),
    insert_segment(Remaining, Segment, Start, Child).

extract_segment(List, Start, End, Segment) :-
    findall(Elem,
            (between(Start, End, I),
             nth1(I, List, Elem)),
            Segment).

insert_segment(Remaining, Segment, Start, Result) :-
    insert_segment_helper(Remaining, Segment, Start, 1, [], Result).

insert_segment_helper([], [], _, _, Acc, Acc).
insert_segment_helper(Remaining, Segment, Start, Index, Acc, Result) :-
    Index >= Start,
    Segment = [S|Ss],
    append(Acc, [S], NewAcc),
    NewIndex is Index + 1,
    insert_segment_helper(Remaining, Ss, Start, NewIndex, NewAcc, Result).
insert_segment_helper([R|Rs], Segment, Start, Index, Acc, Result) :-
    Index < Start,
    append(Acc, [R], NewAcc),
    NewIndex is Index + 1,
    insert_segment_helper(Rs, Segment, Start, NewIndex, NewAcc, Result).

% Mutation: swap two random positions
mutate_population([], []).
mutate_population([Ind|Rest], [Mutated|MutatedRest]) :-
    maybe_mutate(Ind, Mutated),
    mutate_population(Rest, MutatedRest).

maybe_mutate(Ind, Mutated) :-
    (   maybe(0.3)
    ->  mutate(Ind, Mutated)
    ;   Mutated = Ind
    ).

mutate(Ind, Mutated) :-
    length(Ind, Len),
    random_between(1, Len, I),
    random_between(1, Len, J),
    swap(Ind, I, J, Mutated).

swap(List, I, J, Swapped) :-
    nth1(I, List, ElemI),
    nth1(J, List, ElemJ),
    set_nth(List, I, ElemJ, Temp),
    set_nth(Temp, J, ElemI, Swapped).

set_nth([_|T], 1, X, [X|T]).
set_nth([H|T], N, X, [H|R]) :-
    N > 1,
    N1 is N - 1,
    set_nth(T, N1, X, R).

% maybe(P) is true with probability P
maybe(P) :-
    random(R),
    R < P.
