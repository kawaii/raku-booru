unit package Booru::User;

use Cro::HTTP::Client;
use Cro::HTTP::Router;

sub user-routes() is export {
    route {
        get -> 'register' {
            content 'text/html', 'Register form.';
        }
        get -> 'login' {
            content 'text/html', 'Please log in.';
        }
        get -> 'logout' {
            content 'text/html', 'You are logged out.';
        }
    }
}