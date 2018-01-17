use strict;
use warnings;

use Test::More tests => 2;
use Parse;
use Plack::Test;
use HTTP::Request::Common;
use Ref::Util qw<is_coderef>;

my $app = Parse->to_app;
ok( is_coderef($app), 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( GET '/parse' );

ok( $res->is_success, '[GET /parse] successful' );

