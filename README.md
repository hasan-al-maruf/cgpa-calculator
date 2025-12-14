this projects inputs are case sensetive.
course codes are all of uppercase, course code consist of three alphabate and three digits.
grades are tipical academic grades.

open project folder in cmd and run these commands respectively.

lex transcript.l 
bison -d transcript.y 
gcc lex.yy.c transcript.tab.c -o transcript



syntex for calculating cgp for individual semester.


CALC_GPA "Fall 2024" { 
CSE110 : 3.0 : A+ ; 
MAT101 : 3.0 : B ; 
ENG101 : 1.5 : A- ; 
} 


syntex for calculating multiple semesters cgpa.

CALC_FINAL_CG { 
SEMESTER 1 : GPA 3.50 : CREDITS 12.0 ; 
SEMESTER 2 : GPA 3.80 : CREDITS 15.0 ; 
} 
