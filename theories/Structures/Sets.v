Require Import ExtLib.Structures.Monoid.

Set Implicit Arguments.
Set Strict Implicit.

Section Sets.
  Variable S : Type.
  Context {T : Type}.

  Class CSet (R : T -> T -> Prop) : Type :=
  { contains   : T -> S -> bool
  ; empty      : S
  ; singleton  : T -> S 
  ; union      : S -> S -> S
  ; filter     : (T -> bool) -> S -> S
  ; intersect  : S -> S -> S
  ; difference : S -> S -> S
  ; subset     : S -> S -> bool
    (** point-wise **)
  ; add        : T -> S -> S
  ; remove     : T -> S -> S
  }.

  Variable R : T -> T -> Prop.
  Variable DS : CSet R.

  Class CSep_Laws : Type :=
  { empty_not_contains : forall t, contains t empty = false
  ; singleton_contains : forall t u, contains t (singleton u) = true <-> R t u
  ; union_contains     : forall s s',
    forall x, orb (contains x s) (contains x s') = contains x (union s s')
  ; intersect_contains : forall s s',
    forall x, andb (contains x s) (contains x s') = contains x (intersect s s')
  ; difference_contains : forall s s',
    forall x, andb (contains x s) (negb (contains x s')) = contains x (difference s s')
  ; subset_contains    : forall s s', subset s s' = true <-> 
    (forall x, contains x s = true -> contains x s' = true)
  ; add_contains       : forall s x, contains x (add x s) = true
  ; add_contains_not   : forall s x y, ~R x y -> contains x (add y s) = contains x s 
  ; remove_contains    : forall s x, contains x (remove x s) = false
  ; remove_contains_not : forall s x y, ~R x y -> contains x (remove y s) = contains x s
  }.

End Sets.

Arguments contains {S} {T} {R} {_} _ _.
Arguments empty {S} {T} {R} {_}.
Arguments singleton {S} {T} {R} {_} _.
Arguments union {S} {T} {R} {_} _ _.
Arguments intersect {S} {T} {R} {_} _ _.
Arguments difference {S} {T} {R} {_} _ _.
Arguments subset {S} {T} {R} {_} _ _.
Arguments add {S} {T} {R} {_} _ _.
Arguments remove {S} {T} {R} {_} _ _.
Arguments filter {S} {T} {R} {_} _ _.

Section monoid.
  Variable S : Type.
  Context {T : Type}.
  Variable R : T -> T -> Prop.
  Context {set : CSet S R}. 

  Definition Monoid_set_union : Monoid S :=
  {| monoid_plus := union
   ; monoid_unit := empty
  |}.
End monoid.