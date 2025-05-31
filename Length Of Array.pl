
arraylength([], 0).




arraylength([_|Tail], Length) :-
    arraylength(Tail, TailLength),
    Length is TailLength + 1.
