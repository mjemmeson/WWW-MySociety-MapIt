# nearest_postcode.t

use Test::Most;

use WWW::MySociety::MapIt::UK;

my $pkg = 'WWW::MySociety::MapIt::UK';

ok my $uk = $pkg->new(), "new";

dies_ok { $uk->nearest_postcode() } "dies with no args";
dies_ok { $uk->nearest_postcode( x => -4.28620 ) } "dies with no y";
dies_ok { $uk->nearest_postcode( y => 55.61420 ) } "dies with no x";


my $nearest;

ok $nearest = $uk->nearest_postcode( x => -4.28620, y => 55.61420 ),
    "nearest_postcode w/ wgs84 default";

is_deeply $nearest, ka17_0dg(), "nearest_postcode data ok";

ok $nearest = $uk->nearest_postcode( x => -4.28620, y => 55.61420, srid => 'wgs84' ),
    "nearest_postcode - wgs84 name";
is_deeply $nearest, ka17_0dg(), "nearest_postcode data ok";

ok $nearest = $uk->nearest_postcode( x => -4.28620, y => 55.61420, srid => 4326 ),
    "nearest_postcode - wgs84 id";
is_deeply $nearest, ka17_0dg(), "nearest_postcode data ok";

ok $nearest = $uk->nearest_postcode( x => 256107, y => 638041, srid => 'national_grid' ),
    "nearest_postcode - national_grid name";
is_deeply $nearest, ka17_0dg(0), "nearest_postcode data ok";

# TODO /box tests

done_testing();

sub ka17_0dg {
    return {
        postcode => {
            coordsyst => "G",
            distance  => shift // 47,
            easting   => 256107,
            northing  => 638041,
            postcode  => "KA17 0DG",
            wgs84_lat => "55.6146201313498",
            wgs84_lon => "-4.28620027561392",
        }
    };
}


