# $Id$
use ExtUtils::MakeMaker;

eval "use Test::Manifest 1.14";

WriteMakefile
	(
	'NAME'          => 'HTTP::Cookies::Omniweb',
	'VERSION_FROM'  => 'lib/Omniweb.pm',
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',

	'PREREQ_PM'      => {
		'HTTP::Cookies'         => '1.25',
		'Test::More'            => '0',
		'Text::Diff'            => '0',
		},
	'PM'             => {
		'lib/Omniweb.pm' => '$(INST_LIBDIR)/Omniweb.pm',
		},
	'MAN3PODS'		 => {
		'lib/Omniweb.pm' => '$(INST_MAN3DIR)/HTTP::Cookies::Omniweb.3',
		},
	
	clean => { FILES => 'HTTP-Cookies-Omniweb-*' },
	);

