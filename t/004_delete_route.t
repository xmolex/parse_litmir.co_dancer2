use strict;
use warnings;

use Parse;
use Test::More tests => 2;
use Plack::Test;
use HTTP::Request::Common;
use Ref::Util qw<is_coderef>;

my $app = Parse->to_app;
ok( is_coderef($app), 'Got app' );

my $test = Plack::Test->create($app);
my $res  = $test->request( POST '/delete' );

ok( $res->is_success, '[POST /delete] successful' );

