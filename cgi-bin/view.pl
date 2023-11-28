#!"C:/xampp/perl/bin/perl.exe"
use strict;
use CGI;
my $cgi = new CGI;

my $titulo = $cgi->param('titulo');
my $es_bloque_codigo = 0;
my $contenido_bloque_codigo = '';

print "Content-type: text/html\n\n";
print<<HTML;
<html>
	<head>
		<title>Visualizar Pagina</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<h1>Contenido de la Pagina</h1>
HTML

if ($titulo) {
		my $archivo = "Paginas/$titulo";
    open(my $doc, '<', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
    while (my $linea = <$doc>) {
        # print "<p>$linea</p>";

				# Cabeceras
    		if ($linea =~ /^(#{1,6}) (.*?)$/) {
      			print '<h'.length($1).'>'.$2.'</h'.length($1).'>';
    		}

   		 	# Negrita y cursiva
    		elsif ($linea =~ /\*\*\*(.*?)\*\*\*/) {
      			print '<p><strong><em>'.$1.'</em></strong></p>';
    		}

    		# Negrita y cursiva condicional
    		elsif ($linea =~ /\*\*(.*?)\*\*/) {
      			my $text = $1;

      			# Negrita y cursiva dentro
      			if ($text =~ /^(.*?)_([^_]+)_(.*?)$/) {
        				print "<p><strong>$1<em>$2</em>$3</strong></p>";
      			} 
      			else {
        				# Solo Negrita
        				print "<p><strong>$text</strong></p>";
      			}
    		}

    		# Listas
    		elsif ($linea =~ /^(\*|\+|\-) (.*?)$/) {
      			print '<li>'.$2.'</li>';
    		}

    		# Cursiva
    		elsif ($linea =~ /\*(.*?)\*(?!\*)/) {
      			print '<p><em>'.$1.'</em></p>';
    		}

    		# Texto tachado
    		elsif ($linea =~ /~~(.*?)~~/) {
      			print '<p><del>'.$1.'</del></p>';
    		}

    		# Enlaces
    		elsif ($linea =~ /\[(.*?)\]\((.*?)\)/) {
      			print '<a href="'.$2.'">'.$1.'</a>';
    		}

    		# Bloque de codigo 
    		elsif ($linea =~ /```/) {

      			# si encuentra otro ```, significa que acabo el bloque de codigo
      			# resetea $contenido_bloque_codigo y $es_bloque_codigo = 0 (false)
      			if ($es_bloque_codigo) {
       					print '<pre><code>'.$contenido_bloque_codigo.'</code></pre>';
        				$es_bloque_codigo = 0;
        				$contenido_bloque_codigo = '';
      			} 
						else {        
        				# Primera vez que encuentra ```, cambia el valor de $es_bloque_codigo por 1 (true)
        				# para captura el texto de las siguiente lineas
        				$es_bloque_codigo = 1;
      			}
    		}
				else {
      			# Si $es_bloque_codigo es 1 (true) agrega las lineas
      			if ($es_bloque_codigo) {
        				$contenido_bloque_codigo .= $linea;
      			}
      			# Texto normal
      			else {
        				$linea =~ s/^\s*|\s*$//g;
        				if ($linea ne '') {
          					print "<p>".$linea."</p>";
        				}
      			}
    		}

    }
    close $doc;
}

print<<HTML;
		<br>
		<a href="list.pl">Regresar al Listado</a>
	</body>
</html>
HTML