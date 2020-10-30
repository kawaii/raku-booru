unit package Booru::Schema;

use Red:api<2>;

model Favorite is table<favorites> is rw is export {
    has Int $!user-id is referencing( *.id, :model<Booru::Schema::User> );
    has Str $!post-uuid is referencing( *.uuid, :model<Booru::Schema::Post> );
}
