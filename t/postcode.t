# postcode.t

use Test::Most;

use WWW::MySociety::MapIt::UK;

my $pkg = 'WWW::MySociety::MapIt::UK';

ok my $uk = $pkg->new(), "new";

note "partial postcode";
ok my $pc = $uk->postcode("SE1"), "get";

is_deeply $pc,
    {
    coordsyst => "G",
    easting   => 532647,
    northing  => 179477,
    postcode  => "SE1",
    wgs84_lat => "51.4986760331873",
    wgs84_lon => "-0.0904352926992089"
    },
    "data for SE1 ok";

note "full postcode";
ok $pc = $uk->postcode("KA17 0DG"), "get";

delete $pc->{areas};

is_deeply $pc,
    {
    coordsyst => "G",
    easting   => 256107,
    northing  => 638041,
    postcode  => "KA17 0DG",
    shortcuts => {
        WMC     => 14436,
        council => 2574,
        ward    => 20693
    },
    wgs84_lat => "55.6146201313498",
    wgs84_lon => "-4.28620027561392"
    },
    "data for KA17 0DG ok";

done_testing();

