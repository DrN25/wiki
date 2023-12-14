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
    if ($query->execute($titulo, $cuerpo, $username)) {
        print $cgi->header('text/html');
        print <<HTML;
        <!DOCTYPE HTML>
        <html>
        <head>
            <title>Pagina Creada</title>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" type="text/css" href="../css/new.css">
        </head>
        <body>
            <div class="mensaje">El articulo "$titulo" ha sido creado correctamente</div>
            <div class="volver">
                <a href='list.pl?username=$username'>Volver al listado</a>
            </div>
            <a class="enlace-visualizar" href='view.pl?title=$titulo&username=$username'>Visualizar</a>

        </body>
        </html>
HTML
    } else {
        print "Content-type: text/html\n\n";
        print <<HTML;
        <!DOCTYPE HTML>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Crear Nueva Pagina</title>
            <link rel="stylesheet" type="text/css" href="../css/new.css">
        </head>
        <body>
            <div class="error">Error al crear el articulo</div>
            <div class="volver">
                <a href='list.pl?username=$username'>Volver al listado</a>
            </div>
        </body>
        </html>
HTML
    }
    $dbh->disconnect;
} else {
    print "Content-type: text/html\n\n";
    print <<HTML;
    <!DOCTYPE HTML>
    <html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Crear Nueva Pagina</title>
        <link rel="stylesheet" type="text/css" href="../css/new.css">
    </head>
    <body>
        <h1 class="titulo">Crea tu Articulo</h1>
        <form method="post" action="new.pl">
            <input type="hidden" name="username" value="$username">
            <label for="titulo">Titulo del Articulo:</label>
            <input type="text" name="titulo">
            <br>
            <label for="cuerpo">Contenido:</label>
            <textarea name="cuerpo" cols='50' rows='10'></textarea>
            <br>
            <input type="submit" value="Enviar">
        </form>
        <div class="volver">
            <a href='list.pl?username=$username'>Volver al listado</a>
        </div>
    </body>
    </html>
HTML
}
