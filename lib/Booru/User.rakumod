unit package Booru::User;

use Cro::HTTP::Client;
use Cro::HTTP::Router;
use Cro::WebApp::Form;
use Cro::WebApp::Template;

class Register does Cro::WebApp::Form {
    has Str $.username is required is validated(/^<[A..Za..z0..9]>+$/, 'Only alphanumerics are allowed.') is minlength(3) is maxlength(16);
    has Str $.email is email is required;
    has Str $.password is password is required is minlength(8);
    has Str $.repeat-password is password is required is minlength(8);
}

sub user-routes() is export {
    route {
        get -> 'register' {
            template 'templates/register.crotmp', { form => Register.empty }
        }
        post -> 'register' {
            form-data -> Register $form {
                if $form.is-valid {
                    note "Got form data: $form.raku()";
                    content 'text/plain', 'Account registered!';
                }
            }
        }
        get -> 'login' {
            content 'text/html', 'Please log in.';
        }
        get -> 'logout' {
            content 'text/html', 'You are logged out.';
        }
    }
}