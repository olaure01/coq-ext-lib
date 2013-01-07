Require Import ExtLib.Structures.Monads.
Require Import ExtLib.Structures.Reducible.
Require Import ExtLib.Data.Graph.Graph.
Require Import ExtLib.Data.Monads.FuelMonad.
Require Import ExtLib.Data.Monads.IdentityMonad.
Require Import ExtLib.Data.Lists.
Require Import ExtLib.Core.RelDec.
Require Import List.

Set Implicit Arguments.
Set Strict Implicit.

Section GraphAlgos.
  Variable V : Type.
  Variable RelDec_V : RelDec (@eq V).
  Variable G : Type.

  Context {graph : Graph V G}.

  Section Traverse.
    Variable g : G.

    Fixpoint list_in_dec v (ls : list V) : bool :=
      match ls with
        | nil => false
        | l :: ls =>
          if eq_dec l v then true
          else list_in_dec v ls
      end.

    Section monadic.
      Variable m : Type -> Type.
      Context {Monad_m : Monad m} {MonadFix_m : MonadFix m}.

      Definition dfs' : V -> list V -> m (list V) :=
        mfix_multi (V :: list V :: nil) (list V) (fun rec from seen =>
          if list_in_dec from seen
          then ret seen
          else
            foldM (fun v acc =>
              if list_in_dec v acc
              then ret acc
              else rec v acc) (ret seen) (successors g from)).

    End monadic.

    Require Import BinPos.
    Definition dfs (from : V) : list V :=
      let count := Npos (List.fold_left (fun acc _ => BinPos.Psucc acc) (verticies g) 1%positive) in
      let res := unIdent (runGFixT (m := ident) (dfs' from nil) count) in
      match res with
        | None => (** This should never happen! **)
          verticies g
        | Some v => v
      end.

  End Traverse.
End GraphAlgos.
