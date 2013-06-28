package WWW::MySociety::MapIt::UK;

use Moo;

use Carp;
use REST::Client;
use JSON qw/ decode_json /;

use constant URL => 'http://mapit.mysociety.org';

has client => (is => 'ro', default => sub { REST::Client->new( host => URL ) } );

sub get {
    my ( $self, $uri ) = @_;

    my $json = $self->client->GET($uri)->responseContent
        or croak "No response from '$uri'";

    return decode_json($json);
}

1;

