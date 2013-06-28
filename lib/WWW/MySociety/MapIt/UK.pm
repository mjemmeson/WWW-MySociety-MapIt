package WWW::MySociety::MapIt::UK;

use Moo;

use Carp;
use Geo::UK::Postcode::Regex;
use JSON qw/ decode_json /;
use REST::Client;

use constant URL => 'http://mapit.mysociety.org';

has client => (is => 'ro', default => sub { REST::Client->new( host => URL ) } );

my %SRIDs = (
    national_grid       => 27700,
    wgs84               => 4326,    # default
    irish_national_grid => 29902,
);

sub nearest_postcode {
    my ( $self, %args ) = @_;

    _point_args( \%args );

    return $self->get(
        sprintf( "/nearest/%s/%s,%s", $args{srid}, $args{x}, $args{y} ) );
}

sub point {
    my ( $self, %args ) = @_;

    _point_args( \%args );

    return $self->get(
        sprintf(
            "/point/%s/%s,%s%s",
            $args{srid}, $args{x}, $args{y}, $args{box} ? '/box' : ''
        )
    );
}

sub postcode {
    my ($self,$pc) = @_;
    my $parsed
      = Geo::UK::Postcode::Regex->parse( $pc, { valid => 1, partial => 1 } )
        or croak "Invalid postcode";

    my $uri = $parsed->{partial} ? '/postcode/partial/' : '/postcode/';

    return $self->get("$uri$pc");
}



sub get {
    my ( $self, $uri ) = @_;

    my $json = $self->client->GET($uri)->responseContent
        or croak "No response from '$uri'";

    return decode_json($json);
}

sub _point_args {
    my $args = shift;

    $args->{srid} ||= $SRIDs{wgs84};

    if ( $args->{srid} =~ m/\D/ ) {
        $args->{srid} = $SRIDs{ lc $args->{srid} }
            or croak "Invalid srid name";
    }

    croak "Missing x and/or y"
        unless defined $args->{x} && defined $args->{y};
}

1;

