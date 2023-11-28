#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;+
my $cgi = new CGI;

print "Content-type: text/html\n\n";
print<<HTML;
<html>
	<head>
		<title>Listado</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<h1 class="titulo">Nuestras paginas de wiki</h1>
		<table class="tabla">
HTML
my $directorio = "Paginas";

opendir(DIR, $directorio) or die "No se pudo abrir el directorio: $!";
while (my $archivo = readdir(DIR)) {
	next if ($archivo =~ /^\.\.?$/);
    my $titulo = $archivo;
    $titulo =~ s/\.txt$//;
	print "<tr>";
    print "<td><a class='enlaceNombre' href='view.pl?titulo=$titulo'>$titulo</a></td>";
	print "<td><a class='enlaceBoton' href='delete.pl?titulo=$titulo'>X</a></td>";
	print "<td><a class='enlaceBoton' href='edit.pl?titulo=$titulo'>E</a></td>";
	print "</tr>";
}
closedir(DIR);

print<<HTML;
		</table>
		<br>
		<a class="enlace" href='../new.html'>Nueva Pagina</a><br><br>
		<a class="enlace" href='../index.html'>Volver al Inicio</a>
	</body>
</html>
HTML