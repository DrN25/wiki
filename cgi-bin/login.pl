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

if ($cgi->param('submit')) {
    my $username = $cgi->param('username');
    my $password = $cgi->param('password');

    my $error_message;
    if (!defined $username || $username =~ /^\s*$/) {
        $error_message .= "Por favor, ingrese un nombre de usuario.<br>";
    }

    if (!defined $password || $password =~ /^\s*$/) {
        $error_message .= "Por favor, ingrese una contraseña.<br>";
    }

    if ($error_message) {
        show_login_form($error_message);
        exit;
    }

    my $query = $dbh->prepare("SELECT * FROM Users WHERE UserName = ? AND Password = ?");
    $query->execute($username, $password);

    if (my $user_data = $query->fetchrow_hashref) {
        show_user_data($user_data->{UserName}, $dbh);
        print "<p><a href='login.pl?logout=1'>Cerrar Sesión</a></p>";
    } else {
        show_login_form("Datos de inicio de sesión incorrectos.");
    }
} elsif ($cgi->param('logout')) {
    redirect_to_login();
} else {
    show_login_form();
}

$dbh->disconnect;

print "</body></html>";

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
    my $error_message = shift;
    if ($error_message) {
        print "<p style='color: red;'>$error_message</p>";
    }
    print "<p><a href='register.pl'>Registrarse</a></p>",
          "</body></html>";
}

sub show_user_data {
    my ($username, $dbh) = @_;

    my $query = $dbh->prepare("SELECT * FROM Users WHERE UserName = ?");
    $query->execute($username);

    if (my $user_data = $query->fetchrow_hashref) {
        print "Content-type: text/html\n\n",
              "<html><head>",
              "<meta charset=\"UTF-8\" />",
              "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />",
              "<title>Datos del Usuario</title></head><body>",
              "<h1>Bienvenido $username</h1>";

        my $first_name = $user_data->{FirstName};
        my $last_name  = $user_data->{LastName};
        print "<p>Nombre: $first_name $last_name</p>";

        my $query_articles = $dbh->prepare("SELECT * FROM Articles WHERE Owner = ?");
        $query_articles->execute($username);

        if (my $article_data = $query_articles->fetchrow_hashref) {
            print "<p>Artículos:</p><ul>";
            do {
                my $title = $article_data->{Title};
                print "<li>$title</li>";
            } while ($article_data = $query_articles->fetchrow_hashref);
            print "</ul>";
        } else {
            print "<p>No has creado ningún artículo aún.</p>";
        }
        print "</body></html>";
    }
}

sub redirect_to_login {
    print $cgi->redirect("login.pl");
}
