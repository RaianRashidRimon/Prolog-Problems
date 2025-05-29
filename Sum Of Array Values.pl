sum([], 0).



sum([Head|Tail], Sum) :-
    sum(Tail, TailSum),
    Sum is Head + TailSum.
