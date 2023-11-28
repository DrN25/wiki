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
		<h1>Nuestras paginas de wiki</h1>
HTML
my $directorio = "Paginas";

opendir(DIR, $directorio) or die "No se pudo abrir el directorio: $!";
while (my $archivo = readdir(DIR)) {
	next if ($archivo =~ /^\.\.?$/);
    my $titulo = $archivo;
    $titulo =~ s/\.txt$//;
    print "<a href='view.pl?titulo=$archivo'>$titulo</a><br>";
	print " <a href='edit.pl?titulo=$titulo'>Editar</a><br>";
	print " <a href='delete.pl?titulo=$titulo'>Eliminar</a><br>";
}
closedir(DIR);

print<<HTML;
		<form method="post" action="../new.html">
			<input type="submit" value="Crear">
		</form>
	</body>
</html>
HTML