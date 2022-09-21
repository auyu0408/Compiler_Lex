/* Definition section */
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #define print_token(token) \
        printf("%-8s \t %s\n", strcmp(token, "NEWLINE")? yytext: "", token)

    int total = 0;
    int comment = 0;
%}


/* Define regular expression label */
letter          [a-zA-Z_]
digit           [0-9]

string          \"[^\n"]+\"
ws              [ \t]+
id              {letter}+({letter}|{digit})*
inumber         {digit}+
fnumber         ({digit}*\.{digit}+)
cpp_comment     "//"[^\n]*

%x m_str endq c_comment
/* Rules section */
%%

 /* String state */
{string}                { 
                            yyless(yyleng-yyleng+1);
                            print_token("QUOTA"); 
                            BEGIN(m_str); 
                        }

<m_str>[^"]*          {
                                print_token("STRING_LIT");
                                BEGIN(endq);
                        }

<endq>\"                {
                                print_token("QUOTA");
                                BEGIN(0);
                        }

 /* Comment */
 /* C type comment */
"/*"                    { printf("%s", yytext); BEGIN(c_comment); }

<c_comment>"*/"         {
                            printf("%-8s \t C Comment\n", yytext);
                            comment++;
                            BEGIN(0);
                        }

<c_comment>\n           {
                            printf("%-8s \t C Comment\n", yytext);
                            comment++;
                            total++;
                        }

 /* C++ type Comment */
{cpp_comment}           { print_token("C++ Comment"); comment++; }

 /* Arithmetic */
"+"                     { print_token("ADD"); }
"-"                     { print_token("SUB"); }
"*"                     { print_token("MUL"); }
"/"                     { print_token("QUO"); }
"%"                     { print_token("REM"); }
"++"                    { print_token("INC"); }
"--"                    { print_token("DEC"); }

 /* Relational */
">"                     { print_token("GTR"); }
"<"                     { print_token("LSS"); }
">="                    { print_token("GEQ"); }
"<="                    { print_token("LEQ"); }
"=="                    { print_token("EQL"); }
"!="                    { print_token("NEQ"); }

 /* Assignment */
"="                     { print_token("ASSIGN"); }
"+="                    { print_token("ADD_ASSIGN"); }
"-="                    { print_token("SUB_ASSIGN"); }
"*="                    { print_token("MUL_ASSIGN"); }
"/="                    { print_token("QUO_ASSIGN"); }
"%="                    { print_token("REM_ASSIGN"); }

 /* Logical */
"&&"                    { print_token("LAND"); }
"||"                    { print_token("LOR"); }
"!"                     { print_token("NOT"); }

 /* Parentheses */
"("                     { print_token("LPAREN"); }
")"                     { print_token("RPAREN"); }
"["                     { print_token("LBRACK"); }
"]"                     { print_token("RBRACK"); }
"{"                     { print_token("LBRACE"); }
"}"                     { print_token("RBRACE"); }

 /* Keywords */
 /* Print */	
"print"                 { print_token("PRINT"); }
"println"               { print_token("PRINTLN"); }

 /* Condition and Loop */
"if"                    { print_token("IF"); }
"else"                  { print_token("ELSE"); }
"for"                   { print_token("FOR"); }

 /* Data type*/
"int32"                 { print_token("INT"); }
"float32"               { print_token("FLOAT"); }
"string"                { print_token("STRING"); }
"bool"                  { print_token("BOOL"); }
"true"                  { print_token("TRUE"); }
"false"                 { print_token("FALSE"); }

 /* Variable declaration */
"var"                   { print_token("VAR"); }

 /* Functional */
"func"                  { print_token("FUNC"); }
"package"               { print_token("PACKAGE"); }
"return"                { print_token("RETURN"); }

 /* switch */
"switch"                { print_token("SWITCH"); }
"case"                  { print_token("CASE"); }
"default"               { print_token("DEFAULT"); }

 /*Number costant*/
{inumber}               { print_token("INT_LIT"); }
{fnumber}               { print_token("FLOAT_LIT"); }

 /* identifier */
{id}                    { print_token("IDENT"); }

 /* Others */
{ws}                    { /*skip it*/ }
";"                     { print_token("SEMICOLON"); }
","                     { print_token("COMMA"); }
\"                      { print_token("QUOTA"); }
"\n"                    { print_token("NEWLINE"); total++; }
":"                     { print_token("COLON"); }
<<EOF>>                 { total++; yyterminate(); }
.                       {;}
%%

/*  C Code section */
int yywrap(void)
{
    return 1;
}

int main(int argc, char *argv[])
{
    if (argc == 2) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }
    yylex();
    printf("\nFinish scanning,\n");
    printf("total line: %d\n", total);
    printf("comment line: %d\n", comment);
    fclose(yyin);
    return 0;
}
