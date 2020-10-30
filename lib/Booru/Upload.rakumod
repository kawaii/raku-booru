unit package Booru::Upload;

use Cro::HTTP::Client;
use Cro::HTTP::Router;
use Cro::WebApp::Form;
use Cro::WebApp::Template;

use Booru::Form;
use Booru::Session;

sub upload-routes() is export {
    route {
        get -> UserSession $s, 'upload' {
            if $s.logged-in {
                template 'resources/themes/default/templates/upload/upload-form.crotmp', { upload-form => Upload.empty };
            } else {
                redirect '/login', :see-other;
            }
        }
        post -> 'upload' {
            form-data -> Upload $form {
                if $form.is-valid {
                    say "Got form data: $form.raku()";
                }
            }
        }
    }
}
