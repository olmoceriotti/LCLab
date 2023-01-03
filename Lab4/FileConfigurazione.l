%%
%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%state OBJREC
%state PROPNAME
%state VALUE

COLON = ":"
STARTOBJECT = "{"
ENDOBJECT = "}"
SEMICOLON = ";"
ENDVALUE = \n | \r
%%

<YYINITIAL> {
  [\s]+ {}
  [^:\{\n\r]+ {COLON} {
    String string = yytext();
    yyparser.yylval = new ParserVal(string.substring(0, string.length() - 1));
    yybegin(OBJREC);
    return Parser.OBJNAME;
  }
}

<OBJREC> {
  [\s]+ {}
  {STARTOBJECT} {yybegin(PROPNAME);}
}

<PROPNAME> {
  [\s]+ {}
  [^\s]+ [^\n\r\;\:]* {COLON} {
    String string = yytext();
    yyparser.yylval = new ParserVal(string.substring(0, string.length() - 1));
    yybegin(VALUE);
    return Parser.PROPNAME;
  }
  {ENDOBJECT}{SEMICOLON} {yybegin(YYINITIAL);}
}

<VALUE>{
  [\s]+ {}
  [^\s]+[^\n\r]* {ENDVALUE} {
    String string = yytext();
    yyparser.yylval = new ParserVal(string.substring(0, string.length() -1));
    yybegin(PROPNAME);
    return Parser.VALUE;
  }
}