//program koji proverava da li u zadatom nizu od N elemenata
//ima duplikata
//pronadjene duplikate upisati u novi niz u memoriji

#define ZERO(x) sub x, x, x
.data

0x0100				//ukupan broj elemenata niza koji imaju duplikate
0x0050				//niz gde upisujemo duplikat elemente		
20					//duzina niza od 20 clanova
2, -1, 2021, -2, 4,	//niz
5, 6, -3, 4, 31,
10, -2, -5, -6, 7,
15, -6, 17, 18, 2021

//A - R1 indeks elementa za koji se proverava 
//B - R2 indeks elementa sa kojim poredimo
//C - R3 brojac koliko duplikata (a[0])
//x - R4 element za koji se proverava
//y - R5 element sa kojim poredimo
//z - R6 razlika izmedju dva elementa (pri poredjenju)
//p_array - R7 niz u koji se upisuje
//N - R8 broj elemenata niza
.text

init:
	ZERO(R0)		//R0 = 0
	inc R0, R0		//R0 = 1
	mov R7, R0		//p_array = 1
	inc R0, R0		//R0 = 2
	mov R1, R0		//A = 2
	ld R8, R0		//N = 20
	ZERO(R3)		//C = 0
loop1:
	inc R1, R1		//A++
	sub R6, R1, R8	//z = A - N
	jz kraj_petlje	//ukoliko je doslo do kraja
	ld R4, R1		//x = a[A]
	inc R2, R1		//B = A + 1
loop2:
	inc R2, R2		//B++
	sub R6, R2, R8	//z = B - N
	jz loop1		//ukoliko je doslo do kraja
	ld R5, R2		//y = a[B]
	sub R6, R1, R2	//z = a[A] - a[B]
	jnz else		//ako nije duplikat skoci na else
then:
	st R1, R7		//upisujemo a[A] u niz duplikata
	inc R3, R3		//povecavamo brojac duplikata
	jmp loop1
else:
	jmp loop2
kraj_petlje:
	ZERO(R0)		//R0 = 0
	st R3, R0		//upisujemo C u p_result
kraj:
	jmp kraj
	
	
	

	