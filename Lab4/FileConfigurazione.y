%{
  import java.io.*;
%}

/*TOKENS*/
%start end
%token <sval> OBJNAME
%token <sval> PROPNAME
%token <sval> VALUE
%type <sval> property
%type <sval> properties
%type <sval> object
%type <sval> file
%%
end : file {System.out.println($1);}

file : file object {$$ = $1 + "\n" + $2;}
| object {$$ = $1;}
;

object : OBJNAME properties {$$ = "[" + $1 + "]\n" + $2;};

properties : properties property {$$ = $1 + $2;}|
property {$$ = $1;};

property: PROPNAME VALUE {$$ = $1 + "=" + $2 + "\n";}
%%

private Yylex lexer;


  private int yylex () {
    int yyl_return = -1;
    try {
      yylval = new ParserVal(0);
      yyl_return = lexer.yylex();
    }
    catch (IOException e) {
      System.err.println("IO error :"+e);
    }
    return yyl_return;
  }


  public void yyerror (String error) {
    System.err.println ("Error: " + error);
  }


  public Parser(Reader r) {
    lexer = new Yylex(r, this);
  }


  static boolean interactive; 

  public static void main(String args[]) throws IOException {
    Parser yyparser;
    if ( args.length > 0 ) {
      // parse a file
      yyparser = new Parser(new FileReader(args[0]));
    }
    else {
      // interactive mode
      interactive = true;
	    yyparser = new Parser(new InputStreamReader(System.in));
    }
    yyparser.yyparse();
  }