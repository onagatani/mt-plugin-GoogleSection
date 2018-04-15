package MT::Plugin::GoogleSection;
use strict;
use warnings;
use base qw( MT::Plugin );
use Data::Dumper;

our $PLUGIN_NAME = 'GoogleSection';
our $VERSION = '0.1';

my $plugin = __PACKAGE__->new({
    name           => $PLUGIN_NAME,
    version        => $VERSION,
    key            => $PLUGIN_NAME,
    id             => $PLUGIN_NAME,
    author_name    => 'COLSIS Inc.',
    author_link    => 'https://colsis.jp/',
    description    => '<__trans phrase="GoogleSection.">',
    plugin_link    => 'https://colsis.jp',
    registry       => {
        l10n_lexicon => {
            ja => {
                'GoogleSection.' => 'Googleでの検索結果アンカーに対応するためにh1-h6に対してIDを自動で割り振ります',
            },
        },
        callbacks => {
            'build_page' => \&_build_page,
        },
    },
});

MT->add_plugin( $plugin );

sub _build_page {
    my ($eh, %args) = @_;

    my $content = $args{Content} or return;

    for my $h (qw/h1 h2 h3 h4 h5 h6/) {
        my @tags = $$content =~ m{(<\s*?$h.*?>)}igms;
        my $count;
        for my $tag (@tags) {
            unless ($tag =~ m{\s+?id\s*?\=}igms){
                $count++;
                my $section = $h . '_' . 'section' . $count;
                my $new_tag = $tag;
                $new_tag =~ s{>}{ id="$section">}igms;
                $$content =~ s{$tag}{$new_tag}igms;
            }
        }
    }
}

1;
__END__
