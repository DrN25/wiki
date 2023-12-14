#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header(-charset=>'utf-8');
my $dbh = DBI->connect("DBI:mysql:database=wikipedia;host=localhost", "root", "") or die "Couldn't connect to the database";

my $username = $cgi->param('username');

print <<HTML;
<html>
	<head>
		<title>Listado</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<div class="fondo-titulo">
			<h1 class="titulo">Bienvenido $username</h1>
		</div>
		<br><br><br>
HTML

# Prepara una solicitud para los artículos del usuario
my $query_articles = $dbh->prepare("SELECT * FROM Articles WHERE Owner = ?");
$query_articles->execute($username);

if (my $article_data = $query_articles->fetchrow_hashref) {
	print "<div class='fondo'>";
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
	print "</div>";
} else {
	print "<div class='fondo'>";
    print "<p>No has creado ningún artículo aún.</p>";
	print "</div>";
}

print <<HTML;
    <br><br>
    <form method='post' action='new.pl'>
        <input type='hidden' name='username' value='$username'>
        <button type='submit' class='boton'>Nueva Pagina</button>
    </form>
    <form method='get' action='../index.html'>
        <button type='submit' class='boton'>Volver al Inicio</button>
    </form>
</body>
</html>
HTML

$dbh->disconnect;