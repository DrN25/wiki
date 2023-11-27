#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');

print "Content-type: text/html\n\n";
print<<HTML;
<html>
    <head>
        <title>Eliminar Página</title>
    </head>
    <body>
HTML

my $archivo = "Paginas/$titulo.txt";

unlink $archivo;
print "<p>El archivo '$titulo.txt' ha sido eliminado correctamente.</p>";

print<<HTML;
        <br>
        <a href="list.pl">Regresar al Listado</a>
    </body>
</html>
HTML