%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

float local_points = 0;
float local_credits = 0;
float global_points = 0;
float global_credits = 0;

char grade_history[50][5];
int grade_count = 0;

//Feature 1: complex function
const char* analyze_performance(float gpa) {
    if (gpa >= 3.80) return "Highest Distinction (Summa Cum Laude)";
    else if (gpa >= 3.50) return "High Distinction (Magna Cum Laude)";
    else if (gpa >= 3.00) return "Distinction (Cum Laude)";
    else if (gpa >= 2.00) return "Good Standing";
    else if (gpa >= 1.00) return "Academic Probation";
    else return "Failing Standing";
}

// Feature 2: file logging 
void log_to_file(char* semester, float gpa) {
    FILE *fptr = fopen("academic_log.txt", "a"); // "a" = append (update) mode
    
    if (fptr == NULL) {
        printf("Error: Could not open log file.\n");
        return;
    }
    
    fprintf(fptr, "Semester: %s | GPA: %.2f | Status: %s\n", 
            semester, gpa, analyze_performance(gpa));
    
  // Additional analysis: Count of 'A' grades
    int a_count = 0;
    for(int i = 0; i < grade_count; i++) {
    
        if(grade_history[i][0] == 'A') {
            a_count++;
        }
    }
    
    fprintf(fptr, "   -> Performance Analysis: You achieved %d 'A' grade(s) this semester.\n", a_count);
    fprintf(fptr, "------------------------------------------------------\n");
    
    fclose(fptr);
    printf(">> Successfully logged report to 'academic_log.txt'\n");
}


float get_grade_point(char* g) {
  
    if(grade_count < 50) {
        strcpy(grade_history[grade_count], g);
        grade_count++;
    }

    if(strcmp(g, "A+")==0) return 4.00;
    if(strcmp(g, "A") ==0) return 3.75;
    if(strcmp(g, "A-")==0) return 3.50;
    if(strcmp(g, "B+")==0) return 3.25;
    if(strcmp(g, "B") ==0) return 3.00;
    if(strcmp(g, "B-")==0) return 2.75;
    if(strcmp(g, "C+")==0) return 2.50;
    if(strcmp(g, "C") ==0) return 2.25;
    if(strcmp(g, "D") ==0) return 2.00;
    return 0.00; // F
}

void yyerror(char *s);
int yylex();
%}

%union {
    float fval;
    char* str;
}

%token <fval> NUMBER
%token <str> COURSE_CODE GRADE STRING_LIT
%token CMD_GPA CMD_CGPA KEY_SEM KEY_GPA KEY_CREDIT
%token L_BRACE R_BRACE COLON SEMICOLON

%%

program:
      program statement
    |
    ;

statement:
      mode_gpa_calculation
    | mode_cgpa_calculation
    ;


mode_gpa_calculation:
    CMD_GPA STRING_LIT L_BRACE {
      
        local_points = 0;
        local_credits = 0;
        grade_count = 0; 
        
        printf("\n============================================\n");
        printf(" TRANSCRIPT REPORT: %s\n", $2);
        printf("============================================\n");
        printf(" %-10s | %-10s | %-10s\n", "SUBJECT", "CREDIT", "GRADE");
        printf("--------------------------------------------\n");
    }
    course_list 
    R_BRACE {
        if(local_credits > 0) {
            float gpa = local_points / local_credits;
            
            printf("--------------------------------------------\n");
            printf(" TOTAL CREDITS : %.2f\n", local_credits);
            printf(" SEMESTER GPA  : %.2f\n", gpa);
            printf(" STATUS        : %s\n", analyze_performance(gpa));
            printf("============================================\n\n");
            
            
            log_to_file($2, gpa); 
        }
    }
    ;

course_list:
      course_list course_line
    | course_line
    ;

course_line:
    COURSE_CODE COLON NUMBER COLON GRADE SEMICOLON {
        float gp = get_grade_point($5); 
        local_credits += $3;
        local_points  += (gp * $3);
        
        printf(" %-10s | %-10.1f | %s (%.2f)\n", $1, $3, $5, gp);
    }
    ;


mode_cgpa_calculation:
    CMD_CGPA L_BRACE {
        global_points = 0;
        global_credits = 0;
        printf("\n############################################\n");
        printf(" CUMULATIVE DEGREE CALCULATION\n");
        printf("############################################\n");
    }
    semester_list
    R_BRACE {
        if(global_credits > 0) {
            float cgpa = global_points / global_credits;
            printf("############################################\n");
            printf(" TOTAL CREDITS : %.2f\n", global_credits);
            printf(" FINAL CGPA    : %.2f\n", cgpa);
            printf("############################################\n\n");
        }
    }
    ;

semester_list:
      semester_list semester_line
    | semester_line
    ;

semester_line:
    KEY_SEM NUMBER COLON KEY_GPA NUMBER COLON KEY_CREDIT NUMBER SEMICOLON {
        float sem_points = $5 * $8;
        global_credits += $8;
        global_points  += sem_points;
        printf(" > Semester %.0f Added: GPA %.2f (%.1f Cr)\n", $2, $5, $8);
    }
    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "\nERROR: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}