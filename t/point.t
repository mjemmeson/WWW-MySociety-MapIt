# point.t

use Test::Most;

use WWW::MySociety::MapIt::UK;

my $pkg = 'WWW::MySociety::MapIt::UK';

ok my $uk = $pkg->new(), "new";


dies_ok { $uk->point() } "dies with no args";
dies_ok { $uk->point( x => -4.28620 ) } "dies with no y";
dies_ok { $uk->point( y => 55.61420 ) } "dies with no x";


my $point;

ok $point = $uk->point( x => -4.28620, y => 55.61420 ),
    "point w/ wgs84 default";
is_deeply $point, ka17_0dg(), "point data ok";

ok $point = $uk->point( x => -4.28620, y => 55.61420, srid => 'wgs84' ),
    "point - wgs84 name";
is_deeply $point, ka17_0dg(), "point data ok";

ok $point = $uk->point( x => -4.28620, y => 55.61420, srid => 4326 ),
    "point - wgs84 id";
is_deeply $point, ka17_0dg(), "point data ok";

ok $point = $uk->point( x => 256107, y => 638041, srid => 'national_grid' ),
    "point - national_grid name";
is_deeply $point, ka17_0dg(), "point data ok";

# TODO /box tests

done_testing();

sub ka17_0dg {
    return {
        11808 => {
            all_names => {},
            codes     => {
                gss     => "S15000001",
                ons     => 11,
                unit_id => 41429
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 1,
            id              => 11808,
            name            => "Scotland",
            parent_area     => undef,
            type            => "EUR",
            type_name       => "European region"
        },
        134945 => {
            all_names => {},
            codes     => {
                gss     => "S16000126",
                unit_id => 41310
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 15,
            id              => 134945,
            name            => "Kilmarnock and Irvine Valley",
            parent_area     => 135008,
            type            => "SPC",
            type_name       => "Scottish Parliament constituency"
        },
        135008 => {
            all_names => {},
            codes     => {
                gss     => "S17000015",
                unit_id => 41544
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 15,
            id              => 135008,
            name            => "South Scotland",
            parent_area     => undef,
            type            => "SPE",
            type_name       => "Scottish Parliament region"
        },
        14436 => {
            all_names => {},
            codes     => {
                gss     => "S14000040",
                unit_id => 34349
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 2,
            id              => 14436,
            name            => "Kilmarnock and Loudoun",
            parent_area     => undef,
            type            => "WMC",
            type_name       => "UK Parliament constituency"
        },
        20693 => {
            all_names => {},
            codes     => {
                gss     => "S13002558",
                ons     => "00QKMF",
                unit_id => 43524
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 9,
            id              => 20693,
            name            => "Irvine Valley",
            parent_area     => 2574,
            type            => "UTW",
            type_name       => "Unitary Authority ward (UTW)"
        },
        2574 => {
            all_names => {},
            codes     => {
                gss     => "S12000008",
                ons     => "00QK",
                unit_id => 43393
            },
            country         => "S",
            country_name    => "Scotland",
            generation_high => 20,
            generation_low  => 1,
            id              => 2574,
            name            => "East Ayrshire Council",
            parent_area     => undef,
            type            => "UTA",
            type_name       => "Unitary Authority"
        }
    };
}


