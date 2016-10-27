package parser;

import java_cup.runtime.Symbol;
import java.util.*;
import java.io.*;

%%

%unicode
%line
%column
%class Lexer
%cupsym Tokens
%cup
%implements Tokens

%{:

	public static List<Symbol> tokens(Reader input) throws IOException {
		Lexer lexer = new Lexer(input);
		List<Symbol> result = new ArrayList<Symbol>();
		for (Symbol token = lexer.next_token(); token.sym != Tokens.EOF; token = lexer.next_token()) {
			result.add(token);
		}
		return result;
	}

	public static void main(String[] args) throws IOException {
		Lexer lexer;
		if (args.length < 1) args = new String[]{ "" };
		for (int i = 0; i < args.length; ++i) {
			lexer = new Lexer(new InputStreamReader(args[i].length() > 0 ? new FileInputStream(args[i]) : System.in, "UTF8"));
			System.out.println(args[i] +":");
			for (Symbol token = lexer.next_token(); token.sym != Tokens.EOF; token = lexer.next_token()) {
				System.out.println("\t#"+ token.sym +" "+ token.value);
			}
		}
	}

%}

%%
"{"
	{ return new Symbol(LLAVE_IZQUIERDA, yyline, yycolumn, yytext()); }
"}"
	{ return new Symbol(LLAVE_DERECHA, yyline, yycolumn, yytext()); }  
[ \t\r\n\f\v]+
	{ /* Ignorar */ }
\/\*+([^\*]|\*+[^\/])*\*+\/
	{ /* Ignorar */ }
\/\/[^\n]*\n
	{ /* Ignorar */ }
.
	{ return new Symbol(error, yyline, yycolumn, "Entrada Inesperada <"+ yytext() +">!"); }