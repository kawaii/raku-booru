unit package Booru::User;

use Cro::HTTP::Client;
use Cro::HTTP::Router;
use Cro::WebApp::Form;
use Cro::WebApp::Template;
use Crypt::Argon2;

use Booru::Form;
use Booru::Schema::User;
use Booru::Session;

sub create-user($form) {
    User.^create: :username($form.username), :email($form.email), :password(hash-password($form.password));
}

sub hash-password(Str() $password) {
    return argon2-hash($password);
}

sub verify-password($username, $password) {
    my $user-query = User.check: :$username;
    argon2-verify($user-query.password, $password)
}

sub user-routes() is export {
    route {
        subset LoggedIn of UserSession where *.logged-in;
        get -> 'register' {
            template 'resources/themes/default/templates/register/register-form.crotmp', { registration-form => Register.empty }
        }
        post -> 'register' {
            form-data -> Register $form {
                if $form.is-valid {
                    note "Got form data: $form.raku()";
                    create-user($form);
                    template 'resources/themes/default/templates/register/register-success.crotmp';
                }
            }
        }
        get -> UserSession $user, 'login' {
            template 'resources/themes/default/templates/login/login-form.crotmp', { login-form => Login.empty }
        }
        post -> UserSession $user, 'login' {
            form-data -> Login $form {
                if verify-password($form.username, $form.password) {
                    $user.username = $form.username;
                    redirect '/', :see-other;
                } else {
                    content 'text/html', "Bad username/password";
                }
            }
        }
        get -> 'logout' {
            content 'text/html', 'You are logged out.';
        }
    }
}
