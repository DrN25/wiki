#!"C:/xampp/perl/bin/perl.exe"
use strict;
use warnings;
use DBI;
use CGI;

my $cgi = new CGI;
print $cgi->header(-charset=>'utf-8');

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $dbh  = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

my $title = $cgi->param('title');
my $username = $cgi->param('username');
my $es_bloque_codigo = 0;
my $contenido_bloque_codigo = '';

print <<HTML;
<html>
	<head>
		<title>Visualizar Pagina</title>
		<link rel="stylesheet" type="text/css" href="../Estilos.css">
	</head>
	<body>
		<center>
			<div class="fondo-titulo">
				<h1 class="titulo">$title</h1>
			</div>
			<br></br>
			<div class="fondo">
HTML

# Prepara la DB pa
my $query = $dbh->prepare("SELECT * FROM articles WHERE title = ? ");
$query->execute($title);

# If demas creo, solo extrae el objeto
if (my $article_data = $query->fetchrow_hashref) {

		# Extrae los datos del Objeto
    my $content = $article_data->{Content};

		# Separa el contenido en lineas cuando hay salto de linea, lo almacena en un arreglo
    my @lines = split (/\n/, $content);
		# Lee cada linea del arreglo
    foreach my $line (@lines) {

			### CONVERSION MARKDOWN
        # Cabeceras
        if ($line =~ /^(#{1,6}) (.*?)$/) {
            print '<h'.length($1).'>'.$2.'</h'.length($1).'>';
        }

        # Negrita y cursiva
        elsif ($line =~ /\*\*\*(.*?)\*\*\*/) {
            print '<p><strong><em>'.$1.'</em></strong></p>';
        }

        # Negrita y cursiva condicional
        elsif ($line =~ /\*\*(.*?)\*\*/) {
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
        elsif ($line =~ /^(\*|\+|\-) (.*?)$/) {
            print '<li>'.$2.'</li>';
        }

        # Cursiva
        elsif ($line =~ /\*(.*?)\*(?!\*)/) {
            print '<p><em>'.$1.'</em></p>';
        }

        # Texto tachado
        elsif ($line =~ /~~(.*?)~~/) {
            print '<p><del>'.$1.'</del></p>';
        }

        # Enlaces
        elsif ($line =~ /\[(.*?)\]\((.*?)\)/) {
            print '<a href="'.$2.'">'.$1.'</a>';
        }

        # Bloque de codigo 
        elsif ($line =~ /```/) {
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
                $contenido_bloque_codigo .= $line;
            }
            # Texto normal
            else {
                $line =~ s/^\s*|\s*$//g;
                if ($line ne '') {
                    print "<p>".$line."</p>";
                }
            }
        }
				### FIN CONVERSION MARKDOWN
    }
}

print "<form method='get' action='list.pl'>",
	  "<input type='hidden' name='username' value='$username'>",
      "<input type='submit' class='boton' value='Volver'>",
	  "</form>",
	  "</div>",
	  "</center>",
	  "</body></html>";
