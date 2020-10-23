unit package Booru::Schema::Post;

use LibUUID;
use Red:api<2>;

model Post is rw {
    has Str $.uuid is column{ :id } = UUID.new;
    has Int $!author-id is referencing( *.uuid, :model<Member> );
    has $.author is relationship( *.author-id, :model<Member>);
    has Bool $.deleted is column = False;
    has DateTime $.created is column{ :type<timestamptz> } = DateTime.now;
    has Set $.tags is column{
        :type<string>,
        :deflate{ .keys.join: "," },
        :inflate{ set(.split: ",") }
    } = set();
    method delete { $!deleted = True; self.^save }
}
