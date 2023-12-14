#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
use DBI;

my $cgi = CGI->new;
my $username = $cgi->param('username');
print $cgi->header(-charset=>'utf-8');

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
    print <<HTML;
    <!DOCTYPE HTML>
    <html>
    <head>
        <title>Pagina Creada</title>
        <link rel="stylesheet" type="text/css" href="../Estilos.css">
    </head>
    <body>
		<div class="fondo-titulo">
			<h1 class="titulo">La página "$titulo" ha sido creada correctamente</h1>
		</div>
		<br></br>
		<div class="fondo">
			<h3>Pagina grabada</h3>
		</div>
		<br></br>
        <form method='get' action='list.pl'>
			<input type='hidden' name='username' value='$username'>
			<button type='submit' class='boton'>Listado de Paginas</button>
		</form>
		<br>
		<form method='get' action='view.pl'>
			<input type='hidden' name='title' value='$titulo'>
			<input type='hidden' name='username' value='$username'>
			<button type='submit' class='boton'>Visualizar</button>
		</form>
    </body>
    </html>
HTML
	$dbh->disconnect;
} else {
    print <<HTML;
    <!DOCTYPE HTML>
    <html>
    <head>
        <title>Crear Nueva Pagina</title>
        <link rel="stylesheet" type="text/css" href="../Estilos.css">
    </head>
    <body>
		<center>
			<div class="fondo-titulo">
				<h1 class="titulo">Crea tu Pagina Web</h1>
			</div>
			<br></br>
			<div class="fondo">
				<form method="post" action="new.pl">
					<input type="hidden" name="username" value="$username">
					<p style='text-align: left;'><strong>Titulo de la Página:</strong></p>
					<input type="text" class='campo' name="titulo">
					<p style='text-align: left;'><strong>Contenido:</strong></p>
					<textarea name="cuerpo" cols='50' rows='15'></textarea>
					<br></br>
					<input type="submit" class="boton" value="Enviar">
				</form>
			</div>
		</center>
    </body>
    </html>
HTML
}