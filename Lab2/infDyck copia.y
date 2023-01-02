%{
  import java.io.*;
%}

%token OPEN_PAREN;
%token CLOSE_PAREN;
%token <sval> SKIP;
%token EVENS;
%token ODDS;
%token OPEN_PARENQ;
%token CLOSE_PARENQ;
%token <sval> CAPS;

%start s

%%

parens  : OPEN_PAREN s CLOSE_PAREN
        | OPEN_PAREN CLOSE_PAREN
        | OPEN_PARENQ s CLOSE_PARENQ
        | OPEN_PARENQ CLOSE_PARENQ

exp     : parens

exps    : exp SKIP { System.out.println("S: "+$2); }
        | exp

s       : SKIP { System.out.println("txt: "+$1); }
        | exps
        | s exps
        | EVENS SKIP {System.out.println($2); }
        | ODDS SKIP {System.out.println(":"+$2); }
        | CAPS CAPS SKIP {if(!($1.equals($2))) System.out.println("Err: "+$3); else System.out.println("S: "+$3); } 
%%

void yyerror(String s)
{
 System.out.println("err:"+s);
 System.out.println("   :"+yylval.sval);
}

static Yylex lexer;
int yylex()
{
 try {
  return lexer.yylex();
 }
 catch (IOException e) {
  System.err.println("IO error :"+e);
  return -1;
 }
}

public static void main(String args[])
{
 System.out.println("[Quit with CTRL-D]");
 Parser par = new Parser();
 lexer = new Yylex(new InputStreamReader(System.in), par);
 par.yyparse();
}
