# Author: Tom Werner
# Updated by: Scott Boms
# Email: tom@mojombo.com
# URL: http://www.mojombo.com/
# Date: 2008-09-17
# Version 1.4
# Tested on MT 4.2.1
#
# Documentation: http://www.gravatar.com/implement.php#section_2_1
# http://en.gravatar.com/site/implement/url
#
# CHANGES
# 2004-11-14 Fixed URL ampersand XHTML encoding issue by updating to use proper entity
# 2006-07-08 Updated plugin registration to take advantage of latest MT plugin hooks
# 2008-09-17 Fixed gravatar url structure as per updated API

package MT::Plugin::Gravatar;

use strict;
use base qw( MT::Plugin );
use MT 4.0;
our $VERSION = '1.4';

my $plugin = MT::Plugin::Gravatar->new({
  id            => 'gravatar',
  key           => 'gravatar',
  name          => 'Gravatar',
  description   => 'The plugin makes available a tag called MTGravatar that, when used inside the MTComments tag, outputs the correct gravatar URL based on the commenters email address.',
  version       => $VERSION,
  author_name   => 'Tom Werner',
  author_link   => 'http://www.gravatar.com',
  plugin_link => "http://www.gravatar.com/implement.php#section_2_1",
  doc_link    => "http://www.gravatar.com/implement.php#section_2_1",
  registry => {
    tags => {
      function => {
        'Gravatar' => \&get_gravatar_url
      },
    },
  },
});

# initialize plugin
MT->add_plugin($plugin);

sub get_gravatar_url {
  use URI::Escape;
  use Digest::MD5 qw(md5_hex);

  my ($ctx, $args) = @_;
  my $tag = $ctx->stash('tag');
  my $c = $ctx->stash($tag =~ /Preview/ ? 'comment_preview' : 'comment')
  or return $ctx->_no_comment_error('MT' . $tag);
  my $email = $c->email;

  my $url = "http://www.gravatar.com/avatar/".md5_hex($email).'?';
  $url .= exists $args->{size} ? "&amp;s=".$args->{size} : "";
  $url .= exists $args->{rating} ? "&amp;r=".$args->{rating} : "";
  $url .= exists $args->{default} ? "&amp;d=".uri_escape($args->{default}) : "";
  $url .= exists $args->{border} ? "&amp;b=".$args->{border} : "";

  return $url;
}

1;