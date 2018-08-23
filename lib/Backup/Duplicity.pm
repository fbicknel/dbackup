package Backup::Duplicity;
use Class::Accessor "antlers";
use Getopt::Long qw(GetOptionsFromArray);
use Pod::Usage;

my @opt = qw(help man older-than=s exclude-source=s@ list-sources 
    dry-run verbose include-source=s% snapshot! pool=s version config=s);

has older_than   => (is => "rw", isa => "Str");
has list_sources => (is => "rw", isa => "Str");
has pool         => (is => "rw", isa => "Str");
has config       => (is => "rw", isa => "Str");

sub new {
    my $class = shift;
    my $opt = {};
    GetOptionsFromArray(\@_, $opt, @opt) or pod2usage(
        -verbose   => 2,
    );
    pod2usage(
        -message   => "No config file specified",
        -verbose   => 1,
    ) unless $opt->{config};
    my $self = $class->SUPER::new({
        older_than   => $opt->{'older-than'} || '7D',
        list_sources => $opt->{'list-sources'},
        pool         => $opt->{'pool'},
        config       => $opt->{'config'},
    });
}

1;
