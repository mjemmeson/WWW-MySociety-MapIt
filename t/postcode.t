# postcode.t

use Test::Most;

use WWW::MySociety::MapIt::UK::Postcode;

my $pkg = 'WWW::MySociety::MapIt::UK::Postcode';

ok my $pc = $pkg->new(), "new";

note "partial postcode";
ok my $pc_data = $pc->get("SE1"), "get";

is_deeply $pc_data,
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
ok $pc_data = $pc->get("KA17 0DG"), "get";

use Data::Dumper::Concise;
warn Dumper($pc_data);

done_testing();

