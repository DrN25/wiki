#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;
my $dbh = DBI->connect("DBI:mysql:database=wikipedia;host=localhost", "root", "") or die "Couldn't connect to the database";

my $username = $cgi->param('username');

print "Content-type: text/html\n\n";
print <<HTML;
<html>
	<head>
		<title>Listado</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<h1 class="titulo">Bienvenido $username</h1>
HTML

# Prepara una solicitud para los artículos del usuario
my $query_articles = $dbh->prepare("SELECT * FROM Articles WHERE Owner = ?");
$query_articles->execute($username);

if (my $article_data = $query_articles->fetchrow_hashref) {
    print "<table>";
    do {
        my $title = $article_data->{Title};
        # Enlaces a view.pl, delete.pl y edit.pl con el título del artículo y el nombre de usuario como parámetros
        print "<tr>";
        print "<td><a class='enlaceNombre' href='view.pl?title=$title&username=$username'>$title</a></td>";
        print "<td><a class='enlaceBoton' href='delete.pl?title=$title&username=$username'>X</a></td>";
        print "<td><a class='enlaceBoton' href='edit.pl?title=$title&username=$username'>E</a></td>";
        print "</tr>";
    } while ($article_data = $query_articles->fetchrow_hashref);
    print "</table>";
} else {
    print "<p>No has creado ningún artículo aún.</p>";
}

print <<HTML;
		<br>
		<a class="enlace" href='new.pl?username=$username'>Nueva Pagina</a><br><br>
		<a class="enlace" href='../index.html'>Volver al Inicio</a>
	</body>
</html>
HTML

$dbh->disconnect;
$dbh->disconnect;