#!raku

use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Red:api<2>;

use Booru::Schema::Post;
use Booru::Schema::User;
use Booru::Upload;

my $*RED-DEBUG = True;
my $GLOBAL::RED-DB = database "Pg", :host<localhost>, :database<rakubooru>, :user<rakubooru>, :password<password>;

Post.^create-table;
User.^create-table;

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
