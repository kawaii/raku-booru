#!raku

use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::WebApp::Form;
use Cro::WebApp::Template;
use Red:api<2>;

use Booru::Session;
use Booru::Schema::Favorite;
use Booru::Schema::Post;
use Booru::Schema::User;
use Booru::Upload;
use Booru::User;

my $*RED-DEBUG = True;
my $GLOBAL::RED-DB = database "Pg", :host<localhost>, :database<rakubooru>, :user<rakubooru>, :password<password>;

User.^create-table: :if-not-exists;
Post.^create-table: :if-not-exists;
Favorite.^create-table: :if-not-exists;

my $routes = route {
    subset LoggedIn of UserSession where *.logged-in;
    get -> UserSession $s {
        template 'resources/themes/default/templates/home/home.crotmp', $s.user-data;
    }
    include upload-routes();
    include user-routes();
}

sub routes() is export {
    route {
        before Cro::HTTP::Session::InMemory[UserSession].new;
        delegate <*> => $routes;
    }
}

my Cro::Service $service = Cro::HTTP::Server.new(:host('localhost'), :port(2314), application => routes());

$service.start;

react whenever signal(SIGINT) {
    $service.stop;
    exit;
}
