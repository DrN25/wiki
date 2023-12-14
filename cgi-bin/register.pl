#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
print $cgi->header(-charset=>'utf-8');

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";


print "<html><head>",
	  "<link rel='stylesheet' type='text/css' href='../Estilos.css'>",
	  "<meta charset=\"UTF-8\" />",
      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />",
      "<title>Registro de Usuario</title></head><body>",
      "<html><head>",
	  "<center>",
	  "<div class='fondo-titulo'>",
      "<h1>Crear Cuenta</h1>",
	  "</div>",
	  "<br></br>";
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

# Formulario
print "<div class=\"fondo\">",
	  "<form method='post' action='register.pl'>",
      "<p style='text-align: left;'>Usuario:</p>",
	  "<input type='text' class='campo' placeholder='Ingrese Usuario' name='username'>",
      "<p style='text-align: left;'>Contraseña:</p>",
	  "<input type='password' class='campo' placeholder='Ingrese Contraseña' name='password'>",
      "<p style='text-align: left;'>Nombres:</p>",
	  "<input type='text' class='campo' placeholder='Ingrese Nombres' name='firstname'>",
      "<p style='text-align: left;'>Apellidos:</p>",
	  "<input type='text' class='campo' placeholder='Ingrese Apellidos' name='lastname'>",
      "<p><input type='submit' name='submit' class='boton' value='Registrarse'></p>",
      "</form>";
      
# Verifica si se recibio el submit
if ($cgi->param('submit')) {
    # Parametros del formulario
    my $username  = $cgi->param('username');
    my $password  = $cgi->param('password');
    my $firstname = $cgi->param('firstname');
    my $lastname  = $cgi->param('lastname');

    # Solicitud a la DB
    my $query_user = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
    $query_user->execute($username);

    # Si los campos no estan vacios o estan repletos de solo espacios vacios
    if ($username =~ /\S/ && $password =~ /\S/ && $firstname =~ /\S/ && $lastname =~ /\S/) {
        my $check_user = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
        $check_user->execute($username);

        # Si encuentra un usuario con el mismo UserName 
        if ($check_user->fetchrow_array) {
            print "<p style='color:red;'>El nombre de usuario ya existe.</p>";
        } else {
            # Prepara la DB para inserta una fila
            my $insert_user = $dbh->prepare("INSERT INTO Users (UserName, Password, FirstName, LastName) VALUES (?, ?, ?, ?)");
            $insert_user->execute($username, $password, $firstname, $lastname);

            # Mensaje de exito
            print "<p style='color:green;'>Registro exitoso</p>";
        }
    # Mensaje de campos vacios
    } else {
        print "<p style='color:red;'>Todos los campos son obligatorios</p>";
    }
}
print "<p><a href='../index.html'>Volver a la Pagina Principal</a></p>";

$dbh->disconnect;

print "</body></html>";