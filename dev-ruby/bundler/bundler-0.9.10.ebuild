# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /chebatron/dev-ruby/bundler/bundler-0.8.1.ebuild,v 1.0 2010/03/02 15:09:48 cheba Exp $

EAPI=2

USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_TEST="spec"

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="http://github.com/carlhuda/bundler"

SRC_URI="http://github.com/carlhuda/bundler/tarball/c9dcc09772dfe17ac4efeb79ad08b564e9d7beaa -> ${P}.tgz"
RESTRICT="mirror"

S="${WORKDIR}/carlhuda-bundler-c9dcc09"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# does not work with the reduced interface provided by Ruby 1.9 and
# JRuby, so it needs the full package
ruby_add_rdepend virtual/rubygems
