package Module::Build::Platform::Unix;

use strict;
use Module::Build::Base;

use vars qw(@ISA);
@ISA = qw(Module::Build::Base);

sub link_c {
  my $self = shift;
  my $cf = $self->{config};
  
  # Some platforms (notably Mac OS X 10.3, but some others too) expect
  # the syntax "FOO=BAR /bin/command arg arg" to work in %Config
  # (notably $Config{ld}).  It usually works in system(SCALAR), but we
  # use system(LIST). We fix it up here with 'env'.
  
  local $cf->{ld} = $cf->{ld};
  if (ref $cf->{ld}) {
    unshift @{$cf->{ld}}, 'env' if $cf->{ld}[0] =~ /^\s*\w+=/;
  } else {
    $cf->{ld} =~ s/^(\s*\w+=)/env $1/;
  }
  
  return $self->SUPER::link_c(@_);
}

sub make_tarball {
  my $self = shift;
  $self->{args}{tar}  ||= 'tar';
  $self->{args}{gzip} ||= 'gzip';
  $self->SUPER::make_tarball(@_);
}

sub _startperl { "#! " . shift()->perl }

1;
__END__


=head1 NAME

Module::Build::Platform::Unix - Builder class for Unix platforms

=head1 DESCRIPTION

The sole purpose of this module is to inherit from
C<Module::Build::Base>.  Please see the L<Module::Build> for the docs.

=head1 AUTHOR

Ken Williams, ken@mathforum.org

=head1 SEE ALSO

perl(1), Module::Build(3), ExtUtils::MakeMaker(3)

=cut
