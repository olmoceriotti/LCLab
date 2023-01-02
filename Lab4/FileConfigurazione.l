%%
%byaccj

%{
  private Parser yyparser;

  public Yylex(java.io.Reader r, Parser yyparser) {
    this(r);
    this.yyparser = yyparser;
  }
%}

%state OBJNAME
%state PROPNAME
%state VALUE

COLON = ":"
STARTOBJECT = "{"
ENDOBJECT = "}"
SEMICOLON = ";"
ENDVALUE = \n | \r
ENDPROCESSING = "$$"
%%
<YYINITIAL> {
    "$$" {}
    [^] {yybegin(OBJNAME);}
}
<OBJNAME> {
    .* {COLON} .* {STARTOBJECT} {yyparser.yylval = new ParserVal(yytext().substring(0, yylength() - 2));yybegin(PROPNAME);return Parser.OBJNAME; }
}

<PROPNAME> {
    .* {COLON} {String s = yytext();
                yyparser.yylval = new ParserVal(s.substring(0, s.length() - 1));
                yybegin(VALUE);
                return Parser.PROPNAME; }
}

<VALUE> {
    .* {ENDVALUE} {yyparser.yylval = new ParserVal(yytext().substring(0, yylength() - 1));yybegin(PROPNAME);return Parser.VALUE; }
    .* {ENDOBJECT} {SEMICOLON} {yyparser.yylval = new ParserVal(yytext().substring(0, yylength() - 2));yybegin(YYINITIAL);return Parser.VALUE; }
}

