#!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;
use CGI;
use DBI;

my $db_host = "localhost";
my $db_name = "wikipedia";
my $db_user = "root";
my $db_pass = "";

my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_pass) or die "Couldn't connect to the database";

my $cgi = CGI->new;

print "Content-type: text/html\n\n",
      "<html><head>",
      "<meta charset=\"UTF-8\" />",
      "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />",
      "<title>Registro de Usuario</title></head><body>",
      "<h1>Registro de Usuario</h1>";


print "<form method='post' action='register.pl'>",
      "<p>Nombre de Usuario: <input type='text' name='username'></p>",
      "<p>Contraseña: <input type='password' name='password'></p>",
      "<p>Nombres: <input type='text' name='firstname'></p>",
      "<p>Apellidos: <input type='text' name='lastname'></p>",
      "<p><input type='submit' name='submit' value='Registrarse'></p>",
      "</form>";
      
if ($cgi->param('submit')) {
    my $username  = $cgi->param('username');
    my $password  = $cgi->param('password');
    my $firstname = $cgi->param('firstname');
    my $lastname  = $cgi->param('lastname');

    my $query_user = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
    $query_user->execute($username);

    if ($username =~ /\S/ && $password =~ /\S/ && $firstname =~ /\S/ && $lastname =~ /\S/) {
        my $check_user = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
        $check_user->execute($username);

        if ($check_user->fetchrow_array) {
            print "<p style='color:red;'>El nombre de usuario ya existe.</p>";
        } else {
            my $insert_user = $dbh->prepare("INSERT INTO Users (UserName, Password, FirstName, LastName) VALUES (?, ?, ?, ?)");
            $insert_user->execute($username, $password, $firstname, $lastname);

            print "<p style='color:green;'>Registro exitoso</p>";
        }
    } else {
        print "<p style='color:red;'>Todos los campos son obligatorios</p>";
    }
}
print "<p><a href='login.pl'>Volver al Inicio de Sesión</a></p>";

$dbh->disconnect;

print "</body></html>";
