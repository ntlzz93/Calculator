%{
/**********************************************************************
* calculator in flex
* To make this file, "flex clac.l " let you make file into lex.yy.c
* and "gcc lex.yy.c y.tab.c -lfl -o thangdn" to generate an executable file
* You can run ./thangdn and enter an regular expression. EX: "max(2+(2+3)*3-2**5,pow(5,6)-log 15/2+sin 30)".
* To finish up, you can use "dot -Tpdf tree.dot -o outfile.pdf" to generate an grapviz dot is pdf file
* version: 2.0
* January, 26, 2016
*
* This lib was written by thangdn
* Contact:thangdn.tlu@outlook.com
*
* Every comment would be appreciated.
*
* If you want to use parts of any code of mine:
* let me know and
* use it!
**********************************************************************/
	//yacc -d clac.y
	//flex clac.l 
	//gcc lex.yy.c y.tab.c -lfl -o thang
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
	enum bifs {Khong=0,Add,Sub,Mul,Div,Pow,Abs,Factorial,Nega,Mod,T_sin,T_cos,T_tan,T_cot,T_abs,T_pow,T_log,T_logab,T_log10,T_log2,T_round,T_sqrt,T_sqr,T_max,T_min};
%}
%option noyywrap
%%
[0-9]+(\.[0-9]+)?([eE][0-9]+)?	{yylval.f=atof(yytext);return NUM;}
"**"							{return POW; }
[-+()*/%!|{^}\[\],]				{return yytext[0];}
"sin"							{ yylval.fc = T_sin; return FUNC1; }
"cos"							{ yylval.fc = T_cos; return FUNC1; }
"tan"							{ yylval.fc = T_tan; return FUNC1; }
"cot"							{ yylval.fc = T_cot; return FUNC1; }
"abs"							{ yylval.fc = T_abs; return FUNC1; }
"pow"							{ yylval.fc = T_pow; return FUNC2; }
"log"							{ yylval.fc = T_log; return FUNC1; }
"logab"							{ yylval.fc = T_logab; return FUNC2; }
"log10"							{ yylval.fc = T_log10; return FUNC1; }
"log2"							{ yylval.fc = T_log2; return FUNC1; }
"round"							{ yylval.fc = T_round; return FUNC1; }
"sqr"							{ yylval.fc = T_sqr; return FUNC1; }
"sqrt"							{ yylval.fc = T_sqrt; return FUNC1; }
"max"							{ yylval.fc = T_max; return FUNC2; }
"min"							{ yylval.fc = T_min; return FUNC2; }
\n      						{ return EOL; }
[\t\f\v]						{;}
%%
int main()
{
	printf("> ");
	yyparse();
	return 0;
}