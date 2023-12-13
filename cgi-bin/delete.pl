#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;

my $titulo = $cgi->param('title');
my $username = $cgi->param('username');

print "Content-type: text/html\n\n";
print <<HTML;
<html>
    <head>
        <title>Eliminar Página</title>
        <link rel="stylesheet" type="text/css" href="../Estilos.css">
    </head>
    <body>
HTML

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

if ($titulo) {

    my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

    # Eliminar el artículo de la tabla 'articles'
    my $query_eliminar_articulo = $dbh->prepare("DELETE FROM articles WHERE Title = ?");
    $query_eliminar_articulo->execute($titulo);

    print "<p>Se ha eliminado el artículo '$titulo' y su contenido asociado de la base de datos correctamente.</p>";
	$dbh->disconnect;
}
print <<HTML;
        <br>
        <a class="enlace" href="list.pl?username=$username">Regresar al Listado</a>
    </body>
</html>

HTML