unit package Booru::Session;

use Cro::HTTP::Auth;
use Cro::HTTP::Session::InMemory;

use Booru::Schema::User;

class UserSession does Cro::HTTP::Auth is export {
    has $.email is rw;

    method logged-in() {
        defined $!email;
    }

    method user-data() {
        my $u = User.^load(:$!email);
        return %(username => $u.username, email => $u.email, registration-date => $u.registration-date);
    }
}
