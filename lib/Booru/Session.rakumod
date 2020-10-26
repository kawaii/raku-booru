unit package Booru::Session;

use Cro::HTTP::Auth;
use Cro::HTTP::Session::InMemory;

class UserSession does Cro::HTTP::Auth is export {
    has $.username is rw;

    method logged-in() {
        defined $!username;
    }
}
