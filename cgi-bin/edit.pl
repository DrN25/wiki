#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header(-charset=>'utf-8');

print <<HTML;
<html>
    <head>
        <title>Editar Página</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
    </head>
    <body>
HTML

my $titulo = $cgi->param('title');
my $username = $cgi->param('username');

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

my $query = $dbh->prepare("SELECT Content FROM articles WHERE Title = ? AND Owner = ?");
$query->execute($titulo, $username);

my ($content) = $query->fetchrow_array();
if ($cgi->param('cuerpo')) {
    my $contenido = $cgi->param('cuerpo');
    $query = $dbh->prepare("UPDATE articles SET Content = ? WHERE Title = ? AND Owner = ?");
    $query->execute($contenido, $titulo, $username);
    print "<div class='fondo'>",
		  "<p>Se han modificado los cambios</p>",
		  "</div><br>";
    $content = $contenido;
}

print <<HTML;
		<center>
			<div class="fondo-titulo">
				<h1 class="titulo">$titulo</h1>
			</div>
			<br></br>
			<div class="fondo">
				<table>
					<form method='post' action='edit.pl'>
						<input type='hidden' name='title' value='$titulo'>
						<input type='hidden' name='username' value='$username'>
						<tr><td><strong>Texto</strong></td></tr>
						<tr><td><textarea name='cuerpo' cols='50' rows='10'>$content</textarea><br></td></tr>
						<tr><td><input class="boton" type='submit' value='Enviar'></tr></td>
					</form>
					<br></br>
				</table>
				<form method='get' action='list.pl'>
					<input type='hidden' name='username' value='$username'>
					<button type='submit' class='boton'>Volver</button>
				</form>
			</div>
			<br>
		</center>	
    </body>
</html>
HTML

$dbh->disconnect;