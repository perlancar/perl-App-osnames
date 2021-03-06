package App::osnames;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);
use Perl::osnames;

my $res = gen_read_table_func(
    name       => 'list_osnames',
    summary    => 'List possible $^O ($OSNAME) values, with description',
    description => <<'_',

This list might be useful when coding, e.g. when you want to exclude or include
certain OS (families) in your application/test.

_
    table_data => $Perl::osnames::data,
    table_spec => {
        summary => 'List of possible $^O ($OSNAME) values',
        fields  => {
            value => {
                schema   => 'str*',
                index    => 0,
                sortable => 1,
            },
            tags => {
                schema   => [array => of => 'str*'],
                index    => 1,
            },
            description => {
                schema   => 'str*',
                index    => 2,
            },
        },
        pk => 'value',
    },
    enable_paging => 0, # there are only a handful of rows
    enable_random_ordering => 0,
    hooks => {
        after_fetch_data => sub {
            my %args = @_;

            # if run under pericmd-lite, convert tags array to comma-separated
            # string so the result can be displayed as a text table
            if ($args{_func_args}{-cmdline} &&
                    $args{_func_args}{-cmdline}->isa("Perinci::CmdLine::Lite") &&
                    ($args{_func_args}{-cmdline_r}{format} // '') !~ /json/) {
                my $data = $args{_data};
                for (@$data) {
                    $_->[1] = join(",", @{$_->[1]});
                }
            }
            return;
        },
    },
);
die "Can't generate list_osnames function: $res->[0] - $res->[1]"
    unless $res->[0] == 200;

$SPEC{list_osnames}{args}{query}{pos} = 0;
$SPEC{list_osnames}{examples} = [
    {
        argv    => [qw/ux/],
        summary => 'String search',
    },
    {
        argv    => [qw/--tags-has unix --detail/],
        summary => 'List Unices',
    },
    {
        argv    => [qw/--tags-lacks unix --detail/],
        summary => 'List non-Unices',
    },
];

1;
# ABSTRACT:

=head1 SEE ALSO

L<Perl::osnames>

=cut
