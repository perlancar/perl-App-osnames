package App::osnames;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

our $data = [

    ['aix', [qw/unix sysv posix/], 'IBM AIX'],
    ['beos', [qw/posix/], 'See also: haiku'],
    ['cygwin', [qw/unix posix/], ''],

    ['darwin', [qw/unix bsd posix/],

     'Mac OS X. Does not currently (2013) include iOS because Perl has not been
     ported to that platform yet (but PerlMotion is being developed)',

 ],

    ['dec_osf', [qw//], 'DEC Alpha'],
    ['dragonfly', [qw/unix bsd posix/], 'DragonFly BSD'],
    ['freebsd', [qw/unix bsd posix/], ''],
    ['gnukfreebsd', [qw/unix bsd posix/], 'Debian GNU/kFreeBSD'],
    ['haiku', [qw/posix/], 'See also: beos'],
    ['hpux', [qw/unix sysv posix/], 'HP-UX'],
    ['interix', [qw/unix posix/], ''],
    ['irix', [qw/unix sysv posix/], ''],
    ['linux', [qw/unix posix/], ''], # unix-like
    ['MacOS', [qw//], 'Mac OS Classic (which predates Mac OS X)'],
    ['midnightbsd', [qw/unix bsd posix/], ''],
    ['minix', [qw/unix posix/], ''], # unix-like
    ['mirbsd', [qw/unix bsd posix/], 'MirOS BSD'],

    ['MSWin32', [qw//],

     'All Windows platforms including 95/98/ME/NT/2000/XP/CE/.NET. But does not
     include Cygwin (see "cygwin") or Interix (see "interix"). To get more
     details on which Windows you are on, use Win32::GetOSName() or
     Win32::GetOSVersion(). Ref: perlvar.',

 ],

    ['netbsd', [qw/unix bsd posix/], ''],
    ['openbsd', [qw/unix bsd posix/], ''],
    ['sco', [qw/unix sysv posix/], 'SCO UNIX'],
    ['solaris', [qw/unix sysv posix/], 'This includes the old SunOS.'],

    # These OS-es are listed on CPAN Testers OS Leaderboards, but I couldn't
    # google any reports on them. So I couldn't peek the $Config{osname} value.

    # - bigtrig
    # - gnu hurd
    # - os/2
    # - os390/zos
    # - qnx neutrino
    # - tru64 (Tru64 UNIX, unix bsd)
    # - vms

];

for (@$data) {
    # unindent & unwrap text first, Text::Wrap doesn't do those
    $_->[2] =~ s/^[ \t]+//mg;
    $_->[2] =~ s/\n(\n?)(\S)/$1 ? "\n\n$2" : " $2"/mge;
}

# dump: display data as table
#use Data::Format::Pretty::Text qw(format_pretty);
#say format_pretty($data, {
#    table_column_formats=>[{description=>[[wrap=>{columns=>40}]]}],
#    table_column_orders=>[[qw/code summary description/]],
#});

# debug: dump data
#use Data::Dump::Color;
#dd $data;

use Perinci::Sub::Gen::AccessTable qw(gen_read_table_func);

my $res = gen_read_table_func(
    name       => 'list_osnames',
    summary    => 'List possible $^O ($OSNAME) values, with description',
    description => <<'_',

This list might be useful when coding, e.g. when you want to exclude or include
certain OS (families) in your application/test.

_
    table_data => $data,
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
);
die "Can't generate list_osnames function: $res->[0] - $res->[1]"
    unless $res->[0] == 200;

$SPEC{list_osnames}{args}{q}{pos} = 0;
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

=head1 TAGS

=over

=item * unix

Unix-like operating systems. This currently excludes beos/haiku.

=item * bsd

BSD-derived Unix operating systems.

=item * sysv

SysV-derived Unix operating systems.

=item * posix

For POSIX-compliant OSes, including fully-, mostly-, and largely-compliant ones
(source: L<http://en.wikipedia.org/wiki/POSIX>).

From what I can gather, dec_osf is not POSIX compliant, although there is a
posix package for it.

=back


=head1 SEE ALSO

L<perlvar>

L<Config>

L<Devel::Platform::Info>

The output of C<perl -V>

=cut
