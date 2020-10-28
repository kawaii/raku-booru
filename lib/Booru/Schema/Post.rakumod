unit package Booru::Schema;

use LibUUID;
use Red:api<2>;

model Post is table<posts> is rw is export {
    has Str $.uuid is id = ~UUID.new;
    has Str $.title is column;
    has Int $!author-id is referencing( *.id, :model<Booru::Schema::User> );
    has $.author is relationship( *.author-id, :model<Booru::Schema::User> );
    has Str $.source is column;
    has Bool $.is-nsfw is column = False;
    has Bool $.deleted is column = False;
    has DateTime $.created is column{ :type<timestamptz> } = DateTime.now;
    has Set $.tags is column{
        :type<string>,
        :deflate{ .keys.join: "," },
        :inflate{ set(.split: ",") }
    } = set();
    method delete { $!deleted = True; self.^save }
}
