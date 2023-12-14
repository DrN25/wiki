#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;

print $cgi->header('text/html');

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
my $mensaje = "";

if ($cgi->param('cuerpo')) {
    my $contenido = $cgi->param('cuerpo');
    $query = $dbh->prepare("UPDATE articles SET Content = ? WHERE Title = ? AND Owner = ?");
    if ($query->execute($contenido, $titulo, $username)) {
        $content = $contenido;
        $mensaje = "Se han modificado los cambios correctamente.";
    } else {
        $mensaje = "Hubo un error al modificar los cambios.";
    }
}

print <<HTML;
<!DOCTYPE HTML>
<html>
<head>
    <title>Editar Página</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/edit.css">
</head>
<body>
    <h1 class="titulo">$titulo</h1>
HTML

if ($mensaje) {
    my $clase_mensaje = ($mensaje =~ /correctamente/) ? 'mensaje-exito' : 'mensaje-error';
    print "<p class='mensaje $clase_mensaje'>$mensaje</p>";
}

print <<HTML;
    <form method='post' action='edit.pl' class='formulario-edit'>
        <input type='hidden' name='title' value='$titulo'>
        <input type='hidden' name='username' value='$username'>
        <label for='cuerpo' class='label-edit'>Texto:</label>
        <textarea class='textarea-edit' name='cuerpo' cols='50' rows='10'>$content</textarea><br>
        <input class="boton" type='submit' value='Enviar'>
        <div class="volver">
            <a href='list.pl?username=$username'>Volver al listado</a>
        </div>
    </form>
    <br>
</body>
</html>
HTML

$dbh->disconnect;

