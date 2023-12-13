#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $cgi  = CGI->new;
my $dbh  = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

# Verifica si se recibio el submit
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
        show_user_data($user_data->{UserName}, $dbh);
        print "<p><a href='login.pl?logout=1'>Cerrar Sesión</a></p>";
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

print "</body></html>";

# FIN HTML
####################################################################
sub show_login_form {
    print "Content-type: text/html\n\n",
          "<html><head>",
          "<meta charset=\"UTF-8\" />",
          "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />",
          "<title>Iniciar Sesión</title></head><body>",
          "<h1>Iniciar Sesión</h1>";

    print "<form method='post' action='login.pl'>",
          "<p>Nombre de Usuario: <input type='text' name='username'></p>",
          "<p>Contraseña: <input type='password' name='password'></p>",
          "<p><input type='submit' name='submit' value='Iniciar Sesión'></p>",
          "</form>";
    # Si se mandoron parametros (errores) los muestra
    my $error_message = shift;
    if ($error_message) {
        print "<p style='color: red;'>$error_message</p>";
    }
    print "<p><a href='register.pl'>Registrarse</a></p>",
          "</body></html>";
}

sub show_user_data {
    # Parametros
    my ($username, $dbh) = @_;

    # Prepara la solicitud
    my $query = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
    $query->execute($username);

    # Creo que este if esta demas, porque ya se hizo la verificacion si existe en la DB
    # Captura el objeto
    if (my $user_data = $query->fetchrow_hashref) {
		
        print $cgi->redirect("list.pl?username=$username");
        print "</body></html>";
    }
}
#####
sub redirect_to_login {
    print $cgi->redirect("login.pl");
}
