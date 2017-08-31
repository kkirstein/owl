(*
 * OWL - an OCaml numerical library for scientific computing
 * Copyright (c) 2016-2017 Liang Wang <liang.wang@cl.cam.ac.uk>
 *)

(** CBLAS interface: high-level interface  beween Owl and level-1, level-2,
  level-3 BLAS functions.
 *)

(** Please refer to: Intel Math Kernel Library in the CBLAS interface
  url: https://software.intel.com/en-us/mkl-developer-reference-c *)

open Bigarray


(** {6 Definition of basic types} *)

type ('a, 'b) t = ('a, 'b, Bigarray.c_layout) Bigarray.Array1.t

type s_t = (float, Bigarray.float32_elt) t
type d_t = (float, Bigarray.float64_elt) t
type c_t = (Complex.t, Bigarray.complex32_elt) t
type z_t = (Complex.t, Bigarray.complex64_elt) t

type cblas_layout = CblasRowMajor | CblasColMajor

type cblas_transpose = CblasNoTrans | CblasTrans | CblasConjTrans

type cblas_uplo = CblasUpper | CblasLower

type cblas_diag = CblasNonUnit | CblasUnit

type cblas_side = CblasLeft | CblasRight


(** {6 Level-1 BLAS: vector-vector operations} *)

val rotg : float -> float -> float * float * float * float
(** Computes the parameters for a Givens rotation. *)

val rotmg : ('a, 'b) Bigarray.kind -> float -> float -> float -> float -> float * float * float * ('a, 'b) t
(* Computes the parameters for a modified Givens rotation. *)

val rot : int -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> float -> float -> unit
(** Performs rotation of points in the plane. *)

val rotm : int -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> ('a, 'b) t -> unit
(** Performs modified Givens rotation of points in the plane *)

val swap : int -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> unit
(** Swaps a vector with another vector. *)

val scal : int -> 'a -> ('a, 'b) t -> int -> unit
(** Computes the product of a vector and a scalar. *)

val cszd_scal : int -> float -> (Complex.t, 'a) t -> int -> unit
(** Computes the product of a complex vector and a float number. *)

val copy : int -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> unit
(** Copies vector to another vector. *)

val axpy : int -> 'a -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> unit
(** Computes a vector-scalar product and adds the result to a vector. *)

val dot : ?conj:bool -> int -> ('a, 'b) t -> int -> ('a, 'b) t -> int -> 'a
(** Computes a vector-vector dot product. [conj] is for complex numbers, [true]
  indicates conjugated, [false] indicates unconjugated.
 *)

val sdsdot : int -> float -> (float, float32_elt) t -> int -> (float, float32_elt) t -> int -> float
(** Computes a vector-vector dot product extended precision accumulation. *)

val dsdot : int -> (float, float32_elt) t -> int -> (float, float32_elt) t -> int -> float
(** Computes a vector-vector dot product extended precision accumulation. *)

val nrm2 : int -> ('a, 'b) t -> int -> float
(** Computes the Euclidean norm of a vector. *)

val asum : int -> ('a, 'b) t -> int -> float
(** Computes the sum of magnitudes of the vector elements. *)

val amax : int -> ('a, 'b) t -> int -> int
(* Finds the index of the element with maximum absolute value. *)


(** {6 Level-2 BLAS: matrix-vector operations} *)


(* Computes a matrix-vector product using a general matrix *)

val sgemv : cblas_layout -> cblas_transpose -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dgemv : cblas_layout -> cblas_transpose -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit

val cgemv : cblas_layout -> cblas_transpose -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zgemv : cblas_layout -> cblas_transpose -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-vector product using a general band matrix *)

val sgbmv : cblas_layout -> cblas_transpose -> int -> int -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dgbmv : cblas_layout -> cblas_transpose -> int -> int -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit

val cgbmv : cblas_layout -> cblas_transpose -> int -> int -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zgbmv : cblas_layout -> cblas_transpose -> int -> int -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-vector product using a triangular matrix. *)

val strmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> s_t -> int -> s_t -> int -> unit

val dtrmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> d_t -> int -> d_t -> int -> unit

val ctrmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> c_t -> int -> c_t -> int -> unit

val ztrmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> z_t -> int -> z_t -> int -> unit


(* Computes a matrix-vector product using a triangular band matrix. *)

val stbmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> s_t -> int -> s_t -> int -> unit

val dtbmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> d_t -> int -> d_t -> int -> unit

val ctbmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> c_t -> int -> c_t -> int -> unit

val ztbmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> z_t -> int -> z_t -> int -> unit


(* Computes a matrix-vector product using a triangular packed matrix. *)

val stpmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> s_t -> s_t -> int -> unit

val dtpmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> d_t -> d_t -> int -> unit

val ctpmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> c_t -> c_t -> int -> unit

val ztpmv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> z_t -> z_t -> int -> unit


(* Solves a system of linear equations whose coefficients are in a triangular matrix. *)

val strsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> s_t -> int -> s_t -> int -> unit

val dtrsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> d_t -> int -> d_t -> int -> unit

val ctrsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> c_t -> int -> c_t -> int -> unit

val ztrsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> z_t -> int -> z_t -> int -> unit


(* Solves a system of linear equations whose coefficients are in a triangular band matrix. *)

val stbsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> s_t -> int -> s_t -> int -> unit

val dtbsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> d_t -> int -> d_t -> int -> unit

val ctbsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> c_t -> int -> c_t -> int -> unit

val ztbsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> z_t -> int -> z_t -> int -> unit


(* Solves a system of linear equations whose coefficients are in a triangular packed matrix. *)

val stpsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> s_t -> s_t -> int -> unit

val dtpsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> d_t -> d_t -> int -> unit

val ctpsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> c_t -> c_t -> int -> unit

val ztpsv : cblas_layout -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> z_t -> z_t -> int -> unit



(* Computes a matrix-vector product for a symmetric matrix. *)

val ssymv : cblas_layout -> cblas_uplo -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dsymv : cblas_layout -> cblas_uplo -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit


(* Computes a matrix-vector product using a symmetric band matrix. *)

val ssbmv : cblas_layout -> cblas_uplo -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dsbmv : cblas_layout -> cblas_uplo -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit


(* Computes a matrix-vector product using a symmetric packed matrix. *)

val sspmv : cblas_layout -> cblas_uplo -> int -> int -> float -> s_t -> s_t -> int -> float -> s_t -> int -> unit

val dspmv : cblas_layout -> cblas_uplo -> int -> int -> float -> d_t -> d_t -> int -> float -> d_t -> int -> unit


(* Performs a rank-1 update of a general matrix. *)

val sger : cblas_layout -> int -> int -> float -> s_t -> int -> s_t -> int -> s_t -> int -> unit

val dger : cblas_layout -> int -> int -> float -> d_t -> int -> d_t -> int -> d_t -> int -> unit


(* Performs a rank-1 update of a symmetric matrix. *)

val ssyr : cblas_layout -> cblas_uplo -> int -> float -> s_t -> int -> s_t -> int -> unit

val dsyr : cblas_layout -> cblas_uplo -> int -> float -> d_t -> int -> d_t -> int -> unit


(* Performs a rank-1 update of a symmetric packed matrix. *)

val sspr : cblas_layout -> cblas_uplo -> int -> float -> s_t -> int -> s_t -> unit

val dspr : cblas_layout -> cblas_uplo -> int -> float -> d_t -> int -> d_t -> unit


(* Performs a rank-2 update of symmetric matrix. *)

val ssyr2 : cblas_layout -> cblas_uplo -> int -> float -> s_t -> int -> s_t -> int -> s_t -> int -> unit

val dsyr2 : cblas_layout -> cblas_uplo -> int -> float -> d_t -> int -> d_t -> int -> d_t -> int -> unit


(* Performs a rank-2 update of a symmetric packed matrix. *)

val sspr2 : cblas_layout -> cblas_uplo -> int -> float -> s_t -> int -> s_t -> int -> s_t -> unit

val dspr2 : cblas_layout -> cblas_uplo -> int -> float -> d_t -> int -> d_t -> int -> d_t -> unit


(* Computes a matrix-vector product using a Hermitian matrix. *)

val chemv : cblas_layout -> cblas_uplo -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zhemv : cblas_layout -> cblas_uplo -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-vector product using a Hermitian band matrix. *)

val chbmv : cblas_layout -> cblas_uplo -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zhbmv : cblas_layout -> cblas_uplo -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-vector product using a Hermitian packed matrix. *)

val chpmv : cblas_layout -> cblas_uplo -> int -> Complex.t -> c_t -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zhpmv : cblas_layout -> cblas_uplo -> int -> Complex.t -> z_t -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Performs a rank-1 update (unconjugated) of a general matrix. *)

val cgeru : cblas_layout -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> c_t -> int -> unit

val zgeru : cblas_layout -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> z_t -> int -> unit


(* Performs a rank-1 update (conjugated) of a general matrix. *)

val cgerc : cblas_layout -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> c_t -> int -> unit

val zgerc : cblas_layout -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> z_t -> int -> unit


(* Performs a rank-1 update of a Hermitian matrix. *)

val cher : cblas_layout -> cblas_uplo -> int -> float -> c_t -> int -> c_t -> int -> unit

val zher : cblas_layout -> cblas_uplo -> int -> float -> z_t -> int -> z_t -> int -> unit


(* Performs a rank-1 update of a Hermitian packed matrix. *)

val chpr : cblas_layout -> cblas_uplo -> int -> float -> c_t -> int -> c_t -> unit

val zhpr : cblas_layout -> cblas_uplo -> int -> float -> z_t -> int -> z_t -> unit


(* Performs a rank-2 update of a Hermitian matrix. *)

val cher2 : cblas_layout -> cblas_uplo -> int -> Complex.t -> c_t -> int -> c_t -> int -> c_t -> int -> unit

val zher2 : cblas_layout -> cblas_uplo -> int -> Complex.t -> z_t -> int -> z_t -> int -> z_t -> int -> unit


(* Performs a rank-2 update of a Hermitian packed matrix. *)

val chpr2 : cblas_layout -> cblas_uplo -> int -> Complex.t -> c_t -> int -> c_t -> int -> c_t -> unit

val zhpr2 : cblas_layout -> cblas_uplo -> int -> Complex.t -> z_t -> int -> z_t -> int -> z_t -> unit



(** {6 Level-3 BLAS: matrix-matrix operations} *)


(* Computes a matrix-matrix product with general matrices. *)

val sgemm : cblas_layout -> cblas_transpose -> cblas_transpose -> int -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dgemm : cblas_layout -> cblas_transpose -> cblas_transpose -> int -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit

val cgemm : cblas_layout -> cblas_transpose -> cblas_transpose -> int -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zgemm : cblas_layout -> cblas_transpose -> cblas_transpose -> int -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-matrix product where one input matrix is symmetric. *)

val ssymm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dsymm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit

val csymm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zsymm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Performs a symmetric rank-k update. *)

val ssyrk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> s_t -> int -> float -> s_t -> int -> unit

val dsyrk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> d_t -> int -> float -> d_t -> int -> unit

val csyrk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zsyrk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Performs a symmetric rank-2k update. *)

val ssyr2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> s_t -> int -> s_t -> int -> float -> s_t -> int -> unit

val dsyr2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> d_t -> int -> d_t -> int -> float -> d_t -> int -> unit

val csyr2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zsyr2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Computes a matrix-matrix product where one input matrix is triangular. *)

val strmm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> float -> s_t -> int -> s_t -> int -> unit

val dtrmm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> float -> d_t -> int -> d_t -> int -> unit

val ctrmm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> unit

val ztrmm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> unit


(* Solves a triangular matrix equation. *)

val strsm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> float -> s_t -> int -> s_t -> int -> unit

val dtrsm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> float -> d_t -> int -> d_t -> int -> unit

val ctrsm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> unit

val ztrsm : cblas_layout -> cblas_side -> cblas_uplo -> cblas_transpose -> cblas_diag -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> unit


(* Computes a matrix-matrix product where one input matrix is Hermitian. *)

val chemm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> Complex.t -> c_t -> int -> unit

val zhemm : cblas_layout -> cblas_side -> cblas_uplo -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> Complex.t -> z_t -> int -> unit


(* Performs a Hermitian rank-k update. *)

val cherk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> c_t -> int -> float -> c_t -> int -> unit

val zherk : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> float -> z_t -> int -> float -> z_t -> int -> unit


(* Performs a Hermitian rank-2k update. *)

val cher2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> c_t -> int -> c_t -> int -> float -> c_t -> int -> unit

val zher2k : cblas_layout -> cblas_uplo -> cblas_transpose -> int -> int -> Complex.t -> z_t -> int -> z_t -> int -> float -> z_t -> int -> unit
