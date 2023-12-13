#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;
my $username = $cgi->param('username');

if ($cgi->param('titulo')) {
    my $titulo = $cgi->param('titulo');
    my $cuerpo = $cgi->param('cuerpo');

    my $db_host = "localhost";
    my $db_name = "wikipedia";
    my $db_user = "root";
    my $db_pass = "";

    my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

    my $query = $dbh->prepare("INSERT INTO articles (Title, Content, Owner) VALUES (?, ?, ?)");
    $query->execute($titulo, $cuerpo, $username);

    # Mostrar el mensaje de confirmación con enlaces
    print $cgi->header('text/html');
    print <<HTML;
    <!DOCTYPE HTML>
    <html>
    <head>
        <title>Pagina Creada</title>
        <link rel="stylesheet" type="text/css" href="Estilos.css">
    </head>
    <body>
        <h1 class="titulo">La página "$titulo" ha sido creada correctamente</h1>
        <p>$cuerpo</p>
        <h3>Pagina grabada</h3>
        <a class="enlace" href='list.pl?username=$username'>Listado de Paginas<br><br></a>
        <a class="enlace" href='view.pl?title=$titulo&username=$username'>Visualizar</a>
    </body>
    </html>
HTML
	$dbh->disconnect;
} else {
	print $cgi->header('text/html');
    print <<HTML;
    <!DOCTYPE HTML>
    <html>
    <head>
        <title>Crear Nueva Pagina</title>
        <link rel="stylesheet" type="text/css" href="Estilos.css">
    </head>
    <body>
        <h1 class="titulo">Crea tu Pagina Web</h1>
        <form method="post" action="new.pl">
			<input type="hidden" name="username" value="$username">
            <label for="titulo">Titulo de la Página:</label>
            <input type="text" name="titulo">
            <br>
            <label for="cuerpo">Contenido:</label>
            <textarea name="cuerpo" cols='50' rows='10'></textarea>
            <br>
            <input type="submit" value="Enviar">
        </form>
    </body>
    </html>
HTML
}