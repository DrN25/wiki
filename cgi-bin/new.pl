#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;+
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');
my $cuerpo = $cgi->param('cuerpo');

my $archivo = "Paginas/$titulo.txt";

open(my $txt, '>', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
print $txt "$cuerpo";
close $txt;

$cuerpo =~ s/\n/<br>/g;
print "Content-type: text/html\n\n";
print<<HTML;
<html>
	<head>
		<title>Pagina Creada</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<h1 class="titulo">La pagina " $titulo " ha sido creada correctamente</h1>
		<p>$cuerpo</p>
		<h3>Pagina grabada<h3>
		<a class="enlace" href='list.pl'>Listado de Paginas<br><br></a>
		<a class="enlace" href='view.pl?titulo=$titulo'>Visualizar</a>
	</body>
</html>
HTML
 