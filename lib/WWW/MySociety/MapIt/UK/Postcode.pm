package WWW::MySociety::MapIt::UK::Postcode;

use Moo;
extends 'WWW::MySociety::MapIt::UK';

use Carp;
use Geo::UK::Postcode::Regex;

around get => sub {
    my ( $orig, $self, $pc ) = @_;

    my $parsed
        = Geo::UK::Postcode::Regex->parse( $pc, { valid => 1, partial => 1 } )
        or croak "Invalid postcode";

    my $uri = $parsed->{partial} ? '/postcode/partial/' : '/postcode/';

    return $self->$orig("$uri$pc");
};

1;

