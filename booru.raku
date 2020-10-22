#!raku

use Cro::HTTP::Router;
use Cro::HTTP::Server;

use Booru::Upload;

my $application = route {
    get -> {
        content 'text/html', 'Hello World!';
    }
    include upload();
}

my Cro::Service $service = Cro::HTTP::Server.new(:host('localhost'), :port(2314), :$application);

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}
