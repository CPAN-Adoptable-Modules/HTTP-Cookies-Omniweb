use ExtUtils::MakeMaker;

require 5.006;

eval "use Test::Manifest 1.21";

WriteMakefile
	(
	'NAME'          => 'HTTP::Cookies::Omniweb',
	'ABSTRACT'      => 'Cookie storage and management for Omniweb',
	'VERSION_FROM'  => 'lib/Omniweb.pm',
	'LICENSE'       => 'perl',
	'AUTHOR'        => 'brian d foy <bdfoy@cpan.org>',

	'PREREQ_PM'      => {
		'HTTP::Cookies'         => '1.25',
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

