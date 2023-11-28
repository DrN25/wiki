#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');

print "Content-type: text/html\n\n";
print<<HTML;
<html>
    <head>
        <title>Editar Página</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
    </head>
    <body>
HTML

my $archivo = "Paginas/$titulo.txt";
if ($cgi->param('cuerpo')) {
    my $contenido = $cgi->param('cuerpo');
    open(my $doc, '>', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
    print $doc $contenido;
    close $doc;
	print "Se han modificado los cambios"."<br>";
}

open(my $doc2, '<', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
my @lineas = <$doc2>;
close $doc2;

print<<HTML;
		<table>
			<form method='post' action='edit.pl'>
				<input type='hidden' name='titulo' value='$titulo'>
				<h1 class="titulo">$titulo</h1>
				<tr>
					<td>Texto</td>
					<td><textarea name='cuerpo' cols='50' rows='10'>
HTML
foreach my $linea (@lineas) {
	print "$linea";
}

print<<HTML;
					</textarea><br></td>
				</tr>
				<tr><td><input class="boton" type='submit' value='Enviar'></tr></td>
				<tr><td><a class="enlace" href="list.pl">Cancelar</a></tr></td>
			</form>
		</table>
		<br>
	</body>
</html>
HTML