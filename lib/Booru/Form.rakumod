unit package Booru::Form;

use Cro::WebApp::Form;

class Register does Cro::WebApp::Form is export {
    has Str $.username is required is validated(/^<[A..Za..z0..9]>+$/, 'Only alphanumerics are allowed.') is minlength(3) is maxlength(16);
    has Str $.email is email is required;
    has Str $.password is password is required is minlength(8);
    has Str $.repeat-password is password is required is minlength(8);
}

class Login does Cro::WebApp::Form is export {
    has Str $.email is email is required;
    has Str $.password is password is required;
}
