# $Id$
package HTTP::Cookies::Omniweb;
use strict;

=head1 NAME

HTTP::Cookies::Omniweb - Cookie storage and management for Omniweb

=head1 SYNOPSIS

use HTTP::Cookies::Omniweb;

$cookie_jar = HTTP::Cookies::Omniweb->new;

# otherwise same as HTTP::Cookies

=head1 DESCRIPTION

This package overrides the load() and save() methods of HTTP::Cookies
so it can work with Omniweb cookie files.

See L<HTTP::Cookies>.

=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

	https://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 AUTHOR

derived from Gisle Aas's HTTP::Cookies::Netscape package with very
few material changes.

maintained by brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 1997-1999 Gisle Aas

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut

use base qw( HTTP::Cookies );
use vars qw( $VERSION );

use constant TRUE  => 'TRUE';
use constant FALSE => 'FALSE';

$VERSION = sprintf "%2.%02d", q$Revision$ =~ m/ (\d+) \. (\d+) /xg;

my $EPOCH_OFFSET = $^O eq "MacOS" ? 21600 : 0;  # difference from Unix epoch

sub load
	{
    my( $self, $file ) = @_;
 
    $file ||= $self->{'file'} || return;
 
    local $_;
    local $/ = "\n";  # make sure we got standard record separator

    open my $fh, $file or return;

    my $magic = <$fh>;

    unless( $magic =~ /^\# HTTP Cookie File/ ) 
    	{
		warn "$file does not look like a Mozilla cookies file" if $^W;
		close $fh;
		return;
    	}
 
    my $now = time() - $EPOCH_OFFSET;
 
    while( <$fh> ) 
    	{
		next if /^\s*\#/;
		next if /^\s*$/;
		tr/\n\r//d;
		
		my( $domain, $bool1, $path, $secure, $expires, $key, $val ) 
			= split /\t/;
			
		$secure = ( $secure eq TRUE );

		$self->set_cookie(undef, $key, $val, $path, $domain, undef,
			0, $secure, $expires - $now, 0);
    	}
    	
    close $fh;
    
    1;
	}

sub save
	{
    my( $self, $file ) = @_;

    $file ||= $self->{'file'} || return;
 
    local $_;
    open my $fh, "> $file" or return;

    print $fh <<'EOT';
# HTTP Cookie File
# http://www.netscape.com/newsref/std/cookie_spec.html
# This is a generated file!  Do not edit.

EOT

    my $now = time - $EPOCH_OFFSET;
    $self->scan(
    	sub {
			my( $version, $key, $val, $path, $domain, $port,
				$path_spec, $secure, $expires, $discard, $rest ) = @_;

			return if $discard && not $self->{ignore_discard};

			$expires = $expires ? $expires - $EPOCH_OFFSET : 0;

 			return if $now > $expires;

			$secure = $secure ? TRUE : FALSE;

			my $bool = $domain =~ /^\./ ? TRUE : FALSE;

			print $fh join( "\t", $domain, $bool, $path, $secure, 
				$expires, $key, $val ), "\n";
    		}
    	);
    	
    close $fh;
    
    1;
	}

1;
