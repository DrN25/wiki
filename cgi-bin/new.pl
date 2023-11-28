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

print "Content-type: text/html\n\n";
print<<HTML;
<html>
	<head>
		<title>Pagina Creada</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<h1>La pagina " $titulo "ha sido creada correctamente</h1>
		<form method="post" action="list.pl">
			<input type="submit" value="Regresar a la pagina de Listado">
		</form>
	</body>
</html>
HTML
 