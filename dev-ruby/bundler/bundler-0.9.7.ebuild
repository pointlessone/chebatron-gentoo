# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/bundler/bundler-0.8.1.ebuild,v 1.1 2010/01/28 00:50:48 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_TEST="spec"

# No documentation task
#RUBY_FAKEGEM_TASK_DOC=""
#RUBY_FAKEGEM_TASK_TEST=""

inherit ruby-fakegem

DESCRIPTION="An easy way to vendor gem dependencies"
HOMEPAGE="http://github.com/carlhuda/bundler"

SRC_URI="http://github.com/carlhuda/bundler/tarball/${PV} -> ${P}.tgz"
RESTRICT="mirror"

S="${WORKDIR}/carlhuda-bundler-81c5ead"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

# does not work with the reduced interface provided by Ruby 1.9 and
# JRuby, so it needs the full package
ruby_add_rdepend virtual/rubygems
