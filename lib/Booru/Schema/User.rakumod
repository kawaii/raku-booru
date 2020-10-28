unit package Booru::Schema;

use Crypt::Argon2;
use Red:api<2>;

model User is table<users> is rw is export {
    has Int $.id is serial;
    has Str $.username is unique;
    has Str $.password is column;
    has Str $.email is unique;
    has DateTime $.registration-date is column{ :type<timestamptz> } = DateTime.now;
    has Bool $.disabled is column = False;
    has @.posts is relationship({ .author-id }, :model<Booru::Schema::Post>);

    method verify-password($password) {
        argon2-verify($!password, $password);
    }

    method disable {
        $!disabled = True; self.^save;
    }
}
