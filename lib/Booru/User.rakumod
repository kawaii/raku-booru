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

sub user-routes() is export {
    route {
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
                my $subject = User.^load(email => $form.email);
                if $subject.?verify-password($form.password) {
                    $user.email = $form.email;
                    redirect '/', :see-other;
                } else {
                    content 'text/html', "Bad username/password";
                }
            }
        }
        post -> UserSession $user, 'logout' {
            $user.email = Nil;
            redirect '/', :see-other;
        }
    }
}
