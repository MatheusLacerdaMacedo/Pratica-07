%%

%public
%class Scanner
%line
%column
%unicode
%standalone
%type void

%{
  private String codigoPatente = "";
  private String tituloPatente = "";
  private String dataPublicacao = "";
  private String textoResumo = "";
  private String textoReivindicacoes = "";
  private StringBuilder buffer = new StringBuilder();
%}

// Estados
%state ESTADO_CODIGO ESTADO_TITULO ESTADO_DATA ESTADO_RESUMO ESTADO_REIVINDICACOES

// Macros
PatenteInicial = "<TABLE WIDTH=\"100%\"><TR><TD ALIGN=\"LEFT\" WIDTH=\"50%\"><B>United States Patent </B></TD><TD ALIGN=\"RIGHT\" WIDTH=\"50%\"><B>"
PatenteFinal   = "</B></TD></TR><TR><TD ALIGN=\"LEFT\" WIDTH=\"50%\"><b>"

TituloInicial  = "<font size=\"+1\">"
TituloFinal    = "</font><BR>"

DataInicial    = "PCT PUB. Date: <B>"
DataFinal      = "</B>"

ResumoInicial  = "<CENTER><B>Abstract</B></CENTER><P>"
ResumoFinal    = "</P>"

ReivindicacoesInicial = "<CENTER><B><I>Claims</B></I></CENTER> <HR> <BR><BR>What is claimed is:<BR><BR>"
ReivindicacoesFinal   = "<HR> <CENTER><B><I> Description</B>"

// Qualquer caractere
ANYCHAR = (.|\n)

%%

// Número da patente
{PatenteInicial}        { yybegin(ESTADO_CODIGO); buffer.setLength(0); }
<ESTADO_CODIGO>{PatenteFinal} { yybegin(YYINITIAL); codigoPatente = buffer.toString().trim(); }
<ESTADO_CODIGO>{ANYCHAR}      { buffer.append(yytext()); }

// Título
{TituloInicial}         { yybegin(ESTADO_TITULO); buffer.setLength(0); }
<ESTADO_TITULO>{TituloFinal}   { yybegin(YYINITIAL); tituloPatente = buffer.toString().trim(); }
<ESTADO_TITULO>{ANYCHAR}       { buffer.append(yytext()); }

// Data
{DataInicial}           { yybegin(ESTADO_DATA); buffer.setLength(0); }
<ESTADO_DATA>{DataFinal}       { yybegin(YYINITIAL); dataPublicacao = buffer.toString().trim(); }
<ESTADO_DATA>{ANYCHAR}         { buffer.append(yytext()); }

// Resumo
{ResumoInicial}         { yybegin(ESTADO_RESUMO); buffer.setLength(0); }
<ESTADO_RESUMO>{ResumoFinal}   { yybegin(YYINITIAL); textoResumo = buffer.toString().trim(); }
<ESTADO_RESUMO>{ANYCHAR}       { buffer.append(yytext()); }

// Reivindicações
{ReivindicacoesInicial}       { yybegin(ESTADO_REIVINDICACOES); buffer.setLength(0); }
<ESTADO_REIVINDICACOES>{ReivindicacoesFinal} { yybegin(YYINITIAL); textoReivindicacoes = buffer.toString().trim(); }
<ESTADO_REIVINDICACOES>{ANYCHAR}             { buffer.append(yytext()); }

// Fim do arquivo
<<EOF>> {
  System.out.println("Número da Patente: " + codigoPatente);
  System.out.println("Título: " + tituloPatente);
  System.out.println("Data de Publicação: " + dataPublicacao);
  System.out.println("Resumo:\n" + textoResumo);
  System.out.println("Reivindicações:\n" + textoReivindicacoes);
  return;
}

// Ignorar fora de estados
.  { }
\n { }
