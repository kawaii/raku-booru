unit package Booru::Schema::Post;

use LibUUID;
use Red:api<2>;

model Post is table<posts> is rw is export {
    has Str $.uuid is column{ :id } = UUID.new;
    has Int $!author-id is referencing{ :column<id>, :model<User>, :require<Booru::Schema::User> };
    has $.author is relationship({ .id }, :model<User>);
    has Bool $.deleted is column = False;
    has DateTime $.created is column{ :type<timestamptz> } = DateTime.now;
    has Set $.tags is column{
        :type<string>,
        :deflate{ .keys.join: "," },
        :inflate{ set(.split: ",") }
    } = set();
    method delete { $!deleted = True; self.^save }
}
