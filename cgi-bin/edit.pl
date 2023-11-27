#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');

print "Content-type: text/html\n\n";
print<<HTML;
<html>
    <head>
        <title>Editar Página</title>
    </head>
    <body>
        <h1>Editar $titulo</h1>
HTML

my $archivo = "Paginas/$titulo.txt";
if ($cgi->param('cuerpo')) {
    my $contenido = $cgi->param('cuerpo');
    open(my $doc, '>', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
    print $doc $contenido;
    close $doc;
	print "Se han modificado los cambios";
}

open(my $doc2, '<', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
my @lineas = <$doc2>;
close $doc2;

print "<form method='post' action='edit.pl'>";
print "<input type='hidden' name='titulo' value='$titulo'>";
print "<textarea name='cuerpo' cols='50' rows='10'>";
foreach my $linea (@lineas) {
    print "$linea";
}
print "</textarea><br>";
print "<input type='submit' value='Guardar Cambios'>";
print "</form>";

print<<HTML;
        <br>
        <a href="list.pl">Regresar al Listado</a>
    </body>
</html>
HTML