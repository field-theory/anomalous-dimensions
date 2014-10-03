(*

	Diagon_rat v1.0

	Diagonalizes the BL evolution kernel to extract the anomalous
	dimensions on the diagonal
	This version uses the ouput from the "ad_rat" program. The output
	files must be named "rr.out" and "rb.out".

	(c) 1997-2002 by W. Schroers
	Published in Phys.Lett.B458:109-116,1999

	For academical use ONLY

	NOTE: The numerical precision in this program is fixed to ACCURACY!
	If this turns out to be too small for your purposes, alter this
	value below!

*)

ACCURACY = 500; (* Accuracy for calculation *)

(* Load in the input parameters *)
Print["Loading the matrices ..."];
temp = ReadList["rr.out",Expression];
ca   = Sqrt[Length[temp]];
rr   = Table[N[temp[[(i-1)*ca+j]],ACCURACY],{i,1,ca},{j,1,ca}];
Print["Transposing rr!"];
rr   = Transpose[rr];
temp = ReadList["rb.out",Expression];
If[Length[temp]!=ca*ca,
	Print["Different sizes of rr and rb found!"];];
Print["Now processing rb ..."];
rb   = Table[N[temp[[(i-1)*ca+j]],ACCURACY],{i,1,ca},{j,1,ca}];

(* Compute the final result *)
Print["Now computing <F|V|F> ..."];
res = Table[0,{i,1,ca},{j,1,ca}];
For[k=1,k<=ca,k++,
        Print["k = ",k];
	res[[k]] = LinearSolve[rr,rb[[k]]]];
Print["Now diagonalizing V ..."];
rka = Eigenvalues[N[res,ACCURACY]];
Print["Total time consumed: ",TimeUsed[]];
N[rka]

