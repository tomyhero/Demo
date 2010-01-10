use strict;
use warnings;
use Plack::Request;
use Plack::Builder;
use IO::Handle::Util qw(io_from_getline);

my $handler = sub {
    my $env = shift;
    my $req = Plack::Request->new($env);
    if ( $req->path eq '/push' ) {
        my $boundary = '|||';
        my $env = shift;
        my $body = io_from_getline sub {
            sleep 1;
            my $time = time;
            return "--$boundary\nContent-Type: text/html\n Hello $time\n"
        };

        return [ 200, [ "Content-Type" => qq{multipart/mixed; boundary="$boundary"} ], $body ];
    }
};

builder {
    enable "Plack::Middleware::Static",
        path => qr{\.(?:png|jpg|gif|css|txt|js|html)$},
            root => './htdocs/';
    $handler;
};
