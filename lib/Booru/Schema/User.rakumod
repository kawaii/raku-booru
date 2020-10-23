unit package Booru::Schema::User;

use Red:api<2>;

model User is table<users> is rw is export {
    has Int $.id is serial;
    has Str $.username is column;
    has DateTime $.registration-date is column{ :type<timestamptz> } = DateTime.now;
    has Bool $.disabled is column = False;
    has @.posts is relationship( *.author-id, :model<Post>);
    method disable { $!disabled = True; self.^save }
}
