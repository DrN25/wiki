#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $cgi  = CGI->new;

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $dbh  = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

# Verifica si se recibió el submit
if ($cgi->param('submit')) {
    my $username = $cgi->param('username');
    my $password = $cgi->param('password');

    # Manejo de errores al ingresar los datos
    my $error_message;
    if (!defined $username || $username =~ /^\s*$/) {
        $error_message .= "Por favor, ingrese un nombre de usuario.<br>";
    }

    if (!defined $password || $password =~ /^\s*$/) {
        $error_message .= "Por favor, ingrese una contraseña.<br>";
    }
    # Sale del bloque if si hay al menos un error
    if ($error_message) {
        show_login_form($error_message);
        exit;
    }

    # Prepara la solicitud a la DB
    my $query = $dbh->prepare("SELECT * FROM Users WHERE UserName = ? AND Password = ?");
    $query->execute($username, $password);

    # Verifica si existe el usuario en la base de datos
    if (my $user_data = $query->fetchrow_hashref) {
        # Muestra los datos del usuario logeado
        print $cgi->redirect("list.pl?username=$username");
        exit;
    } else {
        # Error de datos incorrectos
        show_login_form("Datos de inicio de sesión incorrectos.");
    }
# Hacer el logOut del usuario logeado    
} elsif ($cgi->param('logout')) {
    redirect_to_login();
# Muestra el formulario
} else {
    show_login_form();
}

$dbh->disconnect;

sub show_login_form {
	print $cgi->header(-charset=>'utf-8');
    print "<html><head>",
          "<title>Iniciar Sesión</title>",
          "<link rel='stylesheet' type='text/css' href='../Estilos.css'>",
          "<meta charset='UTF-8'>",
          "<meta name='viewport' content='width=device-width, initial-scale=1.0'>",
          "</head><body>",
		  "<center>",
		  "<br></br><br></br><br></br>",
		  "<div class='fondo-titulo'>",
          "<h1>Iniciar Sesión</h1>",
		  "</div>",
		  "<br></br>";

    print "<div class=\"fondo\">",
		  "<form method='post' action='login.pl'>",
          "<p style='text-align: left;'><strong>Usuario:</strong></p>",
		  "<input type='text' class='campo' placeholder='Ingrese Usuario' name='username'>",
          "<p style='text-align: left;'><strong>Contraseña:</strong></p>",
		  "<input type='password' class='campo' placeholder='Ingrese Contraseña' name='password'>",
          "<p><input type='submit' class='boton' name='submit' value='Iniciar Sesión'></p>",
          "</form>";
    # Si se mandaron parámetros (errores), los muestra
    my $error_message = shift;
    if ($error_message) {
        print "<p style='color: red;'>$error_message</p>";
    }
    print "<p>¿No tienes una cuenta? <a href='register.pl'>Registrate</a></p>",
		  "</div>",
		  "</center>",
          "</body></html>";
}

sub redirect_to_login {
    print $cgi->redirect("login.pl");
}