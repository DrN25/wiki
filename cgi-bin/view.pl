#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');

print "Content-type: text/html\n\n";
print<<HTML;
<html>
	<head>
		<title>Visualizar Página</title>
	</head>
	<body>
		<h1>Contenido de la Pagina</h1>
HTML

if ($titulo) {
    my $archivo = "Paginas/$titulo";
    open(my $doc, '<', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
    while (my $linea = <$doc>) {
        print "<p>$linea</p>";
    }
    close $doc;
}

print<<HTML;
		<br>
		<a href="list.pl">Regresar al Listado</a>
	</body>
</html>
HTML