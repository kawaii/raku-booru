unit package Booru::Upload;

use Cro::HTTP::Client;
use Cro::HTTP::Router;

sub upload() is export {
    route {
        get -> 'upload' {
            content 'text/html', 'This is the upload page! :D';
        }
    }
}
