# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /chebatron/dev-ruby/passenger/passenger-2.2.10.ebuild,v 1.0 2010/03/02 15:14:42 cheba Exp $

# WARNING
#   This ebuild doesn't support Apache. Only Nginx

EAPI="2"

USE_RUBY="ruby18 ruby19"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="NEWS README"
RUBY_FAKEGEM_TASK_DOC="doc"
RUBY_PATCHES=( "${FILESDIR}"/2.2.4-gentoo.patch )
RUBY_FAKEGEM_BINWRAP="passenger-config passenger-make-enterprisey passenger-memory-stats passenger-spawn-server passenger-status passenger-stress-test"

inherit flag-o-matic ruby-fakegem

DESCRIPTION="Passenger (a.k.a. mod_rails) makes deployment of Ruby on Rails applications a breeze"
HOMEPAGE="http://modrails.com/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="apache2 nginx"
IUSE="nginx"

ruby_add_rdepend ">=dev-ruby/rubygems-0.9.0 dev-ruby/rack"

RDEPEND="${REPEND}
	ruby_targets_ruby18? ( >=dev-ruby/fastthread-1.0.1[ruby_targets_ruby18] )"

#if use apache2; then
#	inherit apache-module

#	APACHE2_MOD_FILE="${S}/ext/apache2/mod_${PN}.so"
#	APACHE2_MOD_CONF="30_mod_${PN}-2.0.1 30_mod_${PN}"
#	APACHE2_MOD_DEFINE="PASSENGER"

#	need_apache2_2
#fi

all_ruby_configure() {
	ruby-ng_pkg_setup
	use debug && append-flags -DPASSENGER_DEBUG
}

each_ruby_compile() {
#	if use apache2; then
#		APXS2="${APXS}" \
#		HTTPD="${APACHE_BIN}" \
#		${RUBY} -S rake apache2 native_support || die "rake apache2 failed"
#	fi

	if use nginx; then
		${RUBY} -S rake nginx || die "rake nginx failed"
	fi
}

#src_install() {
#	DISTDIR="${D}" \
#	rake fakeroot || die "rake fakeroot failed"
#
#	apache-module_src_install
#}

each_ruby_install() {
	each_fakegem_install

	if use nginx; then
		ruby_fakegem_newins ext/nginx/config ext/nginx/config
		exeinto $(ruby_fakegem_gemsdir)/gems/${RUBY_FAKEGEM_NAME}-${RUBY_FAKEGEM_VERSION}${newdirname}/ext/nginx
		doexe ext/nginx/HelperServer
		ruby_fakegem_newins ext/nginx/libpassenger_common.a ext/nginx/libpassenger_common.a
		ruby_fakegem_newins ext/nginx/libboost_oxt.a ext/nginx/libboost_oxt.a
		ruby_fakegem_newins ext/nginx/Configuration.h ext/nginx/Configuration.h
		ruby_fakegem_newins ext/nginx/Configuration.c ext/nginx/Configuration.c
		ruby_fakegem_newins ext/nginx/ContentHandler.h ext/nginx/ContentHandler.h
		ruby_fakegem_newins ext/nginx/ContentHandler.c ext/nginx/ContentHandler.c
		ruby_fakegem_newins ext/nginx/StaticContentHandler.h ext/nginx/StaticContentHandler.h
		ruby_fakegem_newins ext/nginx/StaticContentHandler.c ext/nginx/StaticContentHandler.c
		ruby_fakegem_newins ext/nginx/ngx_http_passenger_module.h ext/nginx/ngx_http_passenger_module.h
		ruby_fakegem_newins ext/nginx/ngx_http_passenger_module.c ext/nginx/ngx_http_passenger_module.c
		ruby_fakegem_newins ext/common/CachedFileStat.h ext/common/CachedFileStat.h
		ruby_fakegem_newins ext/common/Version.h ext/common/Version.h
		ruby_fakegem_newins ext/phusion_passenger/native_support.so ext/phusion_passenger/native_support.so
	fi
}
