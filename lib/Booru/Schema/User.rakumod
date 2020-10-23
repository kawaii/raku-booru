unit package Booru::Schema;

use Red:api<2>;

model User is table<users> is rw is export {
    has Int $.id is serial;
    has Str $.username is unique;
    has DateTime $.registration-date is column{ :type<timestamptz> } = DateTime.now;
    has Bool $.disabled is column = False;
    has @.posts is relationship({ .author-id }, :model<Booru::Schema::Post>);
    method disable { $!disabled = True; self.^save }
}
