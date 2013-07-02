package WWW::MySociety::MapIt::UK;

# VERSION

# ABSTRACT: Access to http://mapit.mysociety.org webservice

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

=head1 METHODS

=head2 area

=cut

sub area {
    my ($self,%args) = @_;

    my $id = $args{id} || $args->{ons_code};

    return $self->get("/area/$id");
}

sub area_example_postcode {
    my ($self,%args) = @_;

    my $id = $args{id};

    return $self->get("/area/$id/example_postcode");
}

sub area_geometry {
    my ($self,%args) = @_;

    my $id = $args{id};

    return $self->get("/area/$id/geometry");
}

sub area_polygon {
my ($self,%args) = @_;

my $id = $args{id};
my $output = $args{output} or croak "No output";l

croak "Invalid output" unless $output =~ m/^(?:xml|json|wkt)$/;
# /area/[area ID].[kml or geojson or wkt]
# /area/[SRID]/[area ID].[kml or json or wkt]

}

=head2 nearest_postcode

=cut

sub nearest_postcode {
    my ( $self, %args ) = @_;

    _point_args( \%args );

    return $self->get(
        sprintf( "/nearest/%s/%s,%s", $args{srid}, $args{x}, $args{y} ) );
}


=head2 point

=cut

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

=head2 postcode

=cut

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

