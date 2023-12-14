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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/list.css">
</head>
<body>
    <h1 class="titulo">Bienvenido $username</h1>
HTML

# Prepara una solicitud para los artículos del usuario
my $query_articles = $dbh->prepare("SELECT * FROM Articles WHERE Owner = ?");
$query_articles->execute($username);

if (my $article_data = $query_articles->fetchrow_hashref) {
    print "<table class='tabla-articulos'>";
    print "<tr><th>Titulo</th><th>Acciones</th></tr>";
    do {
        my $title = $article_data->{Title};
        print "<tr>";
        print "<td><a class='enlaceNombre' href='view.pl?title=$title&username=$username'>$title</a></td>";
        print "<td><a class='enlaceBoton' href='delete.pl?title=$title&username=$username'>Eliminar</a>   | ";
        print "<a class='enlaceBoton' href='edit.pl?title=$title&username=$username'>Editar</a></td>";
        print "</tr>";
    } while ($article_data = $query_articles->fetchrow_hashref);
    print "</table>";
} else {
    print "<p>No has creado ningún artículo aún.</p>";
}

print <<HTML;
    <br>
    <a class="enlace" href='new.pl?username=$username'>Nuevo Articulo</a><br><br>
    <a class="enlace" href='login.pl'>Cerrar Sesión</a>
</body>
</html>
HTML

$dbh->disconnect;
    