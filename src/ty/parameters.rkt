#lang racket
(require redex/reduction-semantics
         "grammar.rkt"
         "hook.rkt"
         "../logic/env.rkt"
         )
(provide apply-variance
         variances-for
         generic-parameters-for
         generics-for
         )

(define-metafunction formality-ty
  ;; Returns the variances for each generic parameter on `RigidName`.
  variances-for : Env RigidName -> (Variance ...)

  [(variances-for Env RigidName)
   (Variance ...)
   (where/error ((_ (_ Variance)) ...) (generic-parameters-for Env RigidName))]

  )

(define-metafunction formality-ty
  ;; Returns the "generic parameters" (i.e., parameter name, kind, and variance) for
  ;; a `RigidName`.
  generic-parameters-for : Env RigidName -> GenericParameters

  [(generic-parameters-for Env RigidName)
   GenericParameters
   (where/error (GenericParameters WhereClauses) (generics-for Env RigidName))
   ]

  )

(define-metafunction formality-ty
  ;; Returns the "generics" (i.e., parameters + where-clauses required to be WF) for
  ;; a `RigidName`.
  generics-for : Env RigidName -> Generics

  [(generics-for Env AdtId) (env-adt-generics Env AdtId)]
  [(generics-for Env ScalarId) (() ())]
  [(generics-for Env (Ref ())) (((TheLt (LtKind +)) (TheTy (TyKind +))) (TheTy >= TheLt))]
  [(generics-for Env (Ref (mut))) (((TheLt (LtKind +)) (TheTy (TyKind =))) (TheTy >= TheLt))]

  [; Tuples are covariant in their elements P1...Pn
   (generics-for Env (Tuple number_arity))
   (((VarId (TyKind Variance)) ...) ())
   (where/error (VarId ...) (unique-names number_arity))
   (where/error ((TyKind Variance) ...) (repeat-n-times (TyKind +) number_arity))
   ]

  [; Functions are contravariant in the arguments P1...Pn and covariant in their return type P(n+1)
   (generics-for Env (Fn number_arity))
   (((VarId_arg (TyKind Variance)) ... (VarId_ret (TyKind +))) ())
   (where/error (VarId_arg ... VarId_ret) (unique-names ,(+ (term number_arity) 1)))
   (where/error ((TyKind Variance) ...) (repeat-n-times (TyKind -) number_arity))
   ]
  )

(define-metafunction formality-ty
  ;; Returns N unique variable ids like `P`, `P1`, `P2`, etc.
  ;; There is no guarantee of "freshness" relative to other terms, though.
  ;; Useful for making up the generics for generic parameters to tuples, function types, etc.
  unique-names : number -> VarId

  [(unique-names number)
   ,(variables-not-in '() (term (repeat-n-times P number)))
   ]

  )

(define-metafunction formality-ty
  apply-variance : Variance RelationOp -> RelationOp

  [(apply-variance + RelationOp) RelationOp]
  [(apply-variance = RelationOp) ==]
  [(apply-variance - >=) <=]
  [(apply-variance - <=) >=]
  [(apply-variance - ==) ==]
  )