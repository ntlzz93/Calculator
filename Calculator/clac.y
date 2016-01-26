%{
/**********************************************************************
* calculator in bison
* To make this file, "yacc -d clac.y" let you make file into y.tab.c & y.tab.h
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
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <math.h>
	#define PI 3.14159265
	enum bifs {Khong=0,Add,Sub,Mul,Div,Pow,Abs,Factorial,Nega,Mod,T_sin,T_cos,T_tan,T_cot,T_abs,T_pow,T_log,T_logab,T_log10,T_log2,T_round,T_sqrt,T_sqr,T_max,T_min};
	long factorial(int);

	struct sf{
		int functype;
		double f;
		struct sf *left;
		struct sf *right;
	};

	struct sf *allocatesf()
	{ 
		struct sf *b = (struct sf *)malloc(sizeof(struct sf));
	  	if (b == NULL) return NULL;
	  	b->functype=Khong;
		b->f = 0;
		b->left = NULL;
		b->right = NULL;
		return b;
	}

	struct sf *createNumber(double value)
	{
		struct sf *b = allocatesf();
		if (b == NULL) return NULL;
		b->functype=Khong;
		b->f = value;
		return b;
	}

	struct sf *createOperation(int functype, struct sf *left, struct sf *right)
	{
		struct sf *b = allocatesf();
		if (b == NULL) return NULL;
		b->functype=functype;
		b->left = left;
		b->right = right;
		return b;
	}

	double eval(struct sf *a)
	{
		double v;
		double x=PI/180;
		switch(a->functype) 
		{
			case Khong: v = a->f; break;
			case Add: v = eval(a->left) + eval(a->right); break;
			case Sub: v = eval(a->left) - eval(a->right); break;
			case Mul: v = eval(a->left) * eval(a->right); break;
			case Div: v = eval(a->left) / eval(a->right); break;
			case Mod: v = (int)eval(a->left) % (int)eval(a->right); break;
			case Abs: v = eval(a->left); if(v < 0) v = -v; break;
			case Factorial: v= factorial((int)eval(a->left)); break;
			case Nega: v = -eval(a->left); break;
			case Pow: v= pow(eval(a->left),eval(a->right));break;
			case T_sin: v= sin(eval(a->left)*x);break;
			case T_cos: v= cos(eval(a->left)*x);break;
			case T_tan: v= tan(eval(a->left)*x);break;
			case T_cot: v= 1/tan(eval(a->left)*x);break;
			case T_abs: v= abs(eval(a->left));break;
			case T_pow: v= pow(eval(a->left),eval(a->right));break;
			case T_log: v= log(eval(a->left));break;
			case T_logab: v= log(eval(a->left))/log(eval(a->right));break;
			case T_log10: v= log10(eval(a->left));break;
			case T_log2: v= log2(eval(a->left));break;
			case T_round: v= round(eval(a->left));break;
			case T_sqrt: v= sqrt(eval(a->left));break;
			case T_sqr: v= eval(a->left)*eval(a->left);break;
			case T_max: v= eval(a->left)>=eval(a->right)?eval(a->left):eval(a->right);break;
			case T_min: v= eval(a->left)<=eval(a->right)?eval(a->left):eval(a->right);break;
			default: printf("internal error: bad node %c\n", a->functype);break;
		}
		return v;
	}

	void deletesf(struct sf *b)
	{
		if (b == NULL) return;
		deletesf(b->left);
		deletesf(b->right);
		free(b);
	}
	char* node_name(struct sf  *e){
		char* name = (char *)malloc(16);
		switch (e->functype){
			case Khong:{
				if(e->f==(int)e->f)
				{
					sprintf(name, "%i", (int)e->f);
				}else
					sprintf(name, "%f", e->f);
				return name;
			}
			case Add: sprintf(name, "+");return name;
			case Sub: sprintf(name, "-");return name;
			case Mul: sprintf(name, "*");return name;
			case Div: sprintf(name, "/");return name;
			case Mod: sprintf(name, "%");return name;
			case Abs: sprintf(name, "||");return name;
			case Factorial: sprintf(name, "!");return name;
			case Nega: sprintf(name, "-");return name;
			case Pow: sprintf(name, "**");return name;
			case T_sin: sprintf(name, "sin");return name;
			case T_cos: sprintf(name, "cos");return name;
			case T_tan: sprintf(name, "tan");return name;
			case T_cot: sprintf(name, "cot");return name;
			case T_abs: sprintf(name, "abs");return name;
			case T_pow: sprintf(name, "pow");return name;
			case T_log: sprintf(name, "log");return name;
			case T_log2: sprintf(name, "log2");return name;
			case T_log10: sprintf(name, "log10");return name;
			case T_logab: sprintf(name, "logab");return name;
			case T_round: sprintf(name, "round");return name;
			case T_sqrt: sprintf(name, "sqrt");return name;
			case T_sqr: sprintf(name, "sqr");return name;
			case T_max: sprintf(name, "max");return name;
			case T_min: sprintf(name, "min");return name;
			default: sprintf(name, "???"); return name;
		}
	}
	void write_node(struct sf *e, FILE *dotfile, int node, int parent)
	{
		fprintf(dotfile, " %i -> %i;\n", parent, node);
		write_tree(e, dotfile, node);
	}

	void write_tree(struct sf *e, FILE *dotfile, int node)
	{
		fprintf(dotfile, " %i [label=\"%s\"];\n", node, node_name(e));
		if (e->left != NULL) write_node(e->left, dotfile, 2*node, node);
		if (e->right != NULL) write_node(e->right, dotfile, 2*node+1, node);
	}

	void write_graphviz(struct sf *e)
	{
		FILE *dotfile = fopen("tree.dot", "w");
		fprintf(dotfile, "digraph tree {\n");
		struct sf *b = allocatesf();
		b->f=eval(e);
		b->functype=Khong;
		b->left=e;
		write_tree(b, dotfile, 1);
		fprintf(dotfile, "}\n");
		fclose(dotfile);
	}

	extern int yylex();
	void yyerror(char *msg);
	
	double Function(int functype,double data1,double data2);
%}

%union {
	double f;
	int fc;
	struct sf *cal;
}

%token <f> NUM
%token <fc> FUNC1
%token <fc> FUNC2
%token <fc> POW
%token EOL

%type <cal> E T F P
%%
S :/* nothing */
  | S E	EOL		{ printf("= %4.4g\n", eval($2));
  					write_graphviz($2);
				    deletesf($2);
				    printf("> ");}
  | S EOL		{printf("> ");}
  ;

E : E '+' T		{$$ = createOperation(Add,$1 ,$3);}
  | E '-' T 	{$$ = createOperation(Sub,$1 ,$3);}
  | T       	{$$ = $1;}
  ;

T : T '*' P		{$$ = createOperation(Mul,$1 ,$3);}
  | T '/' P		{if($3->f==0){yyerror("Division by zero is undefined!");}else $$ = createOperation(Div,$1 ,$3);}
  | T '%' P		{
  					if($1->f==(int)$1->f && $3->f ==(int)$3->f)
  					{
  						$$ = createOperation(Mod,$1 ,$3);
  					}else 
  					{
  						yyerror("Modulus division is only defined for integers!");
  					}
  				}
  | P			{$$ = $1;}
  ;

P : F POW P 	{$$ = createOperation(Pow,$1 ,$3);}
  | F 			{$$ = $1;}
  ;

F : '(' E ')'	{$$ = $2;}
  | '|' E '|'	{$$ = createOperation(Abs,$2,NULL);}
  | '{' E '}'	{$$ = $2;}
  | '[' E ']'	{$$ = $2;}
  | F '!'		{
  					if($1->f==(int)$1->f)
	  				{
	  					if($1>=0)$$ = createOperation(Factorial,$1,NULL);
	  					else yyerror("Fail");
	  				}
	  				else yyerror("Allows to use float");
  				}
  | '-' F 		{$$ = createOperation(Nega,$2 ,NULL);}
  | FUNC2 '(' E ',' E ')'	{$$=createOperation((int)$1 ,$3 ,$5);}
  | FUNC1 '(' E ')'			{$$=createOperation((int)$1 ,$3 ,NULL);}
  | FUNC1 F					{$$=createOperation((int)$1 ,$2 ,NULL);}
  | NUM			{$$ = createNumber($1);}
  ;	 
%%
void yyerror(char *msg){
	fprintf(stderr,"%s\n",msg);
}
long factorial(int i)
{
	if(i==1)return 1;
	return i*factorial(i-1); 
}
