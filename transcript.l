%option noyywrap

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "transcript.tab.h"
%}

%%

"CALC_GPA"          { return CMD_GPA; }
"CALC_FINAL_CG"     { return CMD_CGPA; }
"SEMESTER"          { return KEY_SEM; }
"GPA"               { return KEY_GPA; }
"CREDITS"           { return KEY_CREDIT; }


\"[^"]*\"           { yylval.str = strdup(yytext); return STRING_LIT; }

   
[A-Z]{3}[0-9]{3}    { yylval.str = strdup(yytext); return COURSE_CODE; }

   
[A-D][\+\-]?|F      { yylval.str = strdup(yytext); return GRADE; }

  
[0-9]+(\.[0-9]+)?   { yylval.fval = atof(yytext); return NUMBER; }

 
"{"                 { return L_BRACE; }
"}"                 { return R_BRACE; }
":"                 { return COLON; }
";"                 { return SEMICOLON; }


[ \t\n]+            ;

 
.                   { printf("Unknown Character: %s\n", yytext); }

%%