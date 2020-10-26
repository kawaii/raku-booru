unit package Booru::Upload;

use Cro::HTTP::Client;
use Cro::HTTP::Router;
use Cro::WebApp::Form;
use Cro::WebApp::Template;

use Booru::Form;
use Booru::Session;

sub upload-routes() is export {
    route {
        subset LoggedIn of UserSession where *.logged-in;
        get -> UserSession $s, 'upload' {
            if $s.logged-in {
                template 'resources/themes/default/templates/upload/upload-form.crotmp';
            } else {
                forbidden;
                template 'resources/themes/default/templates/login/login-form.crotmp', { login-form => Login.empty }
            }
        }
    }
}
