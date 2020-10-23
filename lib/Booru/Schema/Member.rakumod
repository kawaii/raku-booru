unit package Booru::Schema::Member;

use Red:api<2>;

model Member is rw {
    has Int $.id is serial;
    has Str $.username is column;
    has DateTime $.registration-date is column{ :type<timestamptz> } = DateTime.now;
    has Bool $.disabled is column = False;
    has @.posts is relationship( *.author-id, :model<Post>);
    method disable { $!disabled = True; self.^save }
}
