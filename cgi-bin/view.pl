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
		<h1 class="titulo">$titulo</h1>
HTML

$titulo = $titulo.".txt";

if ($titulo) {
		my $archivo = "Paginas/$titulo";
    open(my $doc, '<', $archivo) or die "No se pudo abrir el archivo '$archivo' $!";
    while (my $linea = <$doc>) {
        # print "<p>$linea</p>";

				# Cabeceras
    		if ($linea =~ /^(#{1,6}) (.*?)$/) {
      			print '<h'.length($1).' class="fondo-texto">'.$2.'</h'.length($1).'>';
    		}

   		 	# Negrita y cursiva
    		elsif ($linea =~ /\*\*\*(.*?)\*\*\*/) {
      			print '<p class="fondo-texto"><strong><em>'.$1.'</em></strong></p>';
    		}

    		# Negrita y cursiva condicional
    		elsif ($linea =~ /\*\*(.*?)\*\*/) {
      			my $text = $1;

      			# Negrita y cursiva dentro
      			if ($text =~ /^(.*?)_([^_]+)_(.*?)$/) {
        				print "<p class='fondo-texto'><strong>$1<em>$2</em>$3</strong></p>";
      			} 
      			else {
        				# Solo Negrita
        				print "<p class='fondo-texto'><strong>$text</strong></p>";
      			}
    		}

    		# Listas
    		elsif ($linea =~ /^(\*|\+|\-) (.*?)$/) {
      			print '<li class="fondo-texto">'.$2.'</li>';
    		}

    		# Cursiva
    		elsif ($linea =~ /\*(.*?)\*(?!\*)/) {
      			print '<p class="fondo-texto"><em>'.$1.'</em></p>';
    		}

    		# Texto tachado
    		elsif ($linea =~ /~~(.*?)~~/) {
      			print '<p class="fondo-texto"><del>'.$1.'</del></p>';
    		}

    		# Enlaces
    		elsif ($linea =~ /\[(.*?)\]\((.*?)\)/) {
      			print '<a class="fondo-texto" href="'.$2.'">'.$1.'</a>';
    		}

    		# Bloque de codigo 
    		elsif ($linea =~ /```/) {

      			# si encuentra otro ```, significa que acabo el bloque de codigo
      			# resetea $contenido_bloque_codigo y $es_bloque_codigo = 0 (false)
      			if ($es_bloque_codigo) {
       					print '<pre class="fondo-texto"><code>'.$contenido_bloque_codigo.'</code></pre>';
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
          					print "<p class='fondo-texto'>".$linea."</p>";
        				}
      			}
    		}

    }
    close $doc;
}

print<<HTML;
		<br><br>
		<a class="enlace" href="list.pl">Regresar al Listado</a>
	</body>
</html>
HTML