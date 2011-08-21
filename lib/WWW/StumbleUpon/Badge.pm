# ABSTRACT: Perl interface to the StumbleUpon Badge API
package WWW::StumbleUpon::Badge;

=haed1 SYNOPSIS

    use WWW::StumbleUpon::Badge;

    my $url_info = WWW::StumbleUpon::Badge->get_info({ url => $url });

=head1 DESCRIPTION

Simple Perl interface to the StumbleUpon Badge API, which can be used to generate
"badges" for displaying on pages or can be used to grab the information
StumbleUpon holds for a URL, like the number of views it has had.

=head1 METHODS

=cut

use strict;
use warnings;

use Carp;
use JSON;

our $VERSION = 0.01;
my $API_BASE = 'http://www.stumbleupon.com/services/1.01/badge.getinfo?url=';

=head2 C<get_info>

    my $url_info = WWW::StumbleUpon::Badge->get_info({ url => $url });

Returns a hash reference containing the data returned from the StumbleUpon API,
or croaks on failure.

=cut

sub get_info {
    my ( $class, $args ) = @_;

    my $url = delete $args->{url};
    croak "URL argument required" unless $url;
    croak "Unknown arguments passed" if %{$args};

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    
    my $response = $ua->get( $API_BASE . $url );

    if ( $response->is_success ) {
        return decode_json $response->content;
    }
    else {
        croak $response->status_line;
    }

}

=head1 SEE ALSO

L<http://www.stumbleupon.com/help/badge-api-documentation/>

=head1 AUTHOR

Adam Taylor <ajct@cpan.org>

=cut

1;
