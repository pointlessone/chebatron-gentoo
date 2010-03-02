# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

EAPI=2
inherit eutils ssl-cert toolchain-funcs perl-module

DESCRIPTION="Robust, small and high performance http and reverse proxy server"

HOMEPAGE="http://nginx.net/"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# nginx third-party modules. Keep them here so
# that maybe one day they might be included in
# USE_EXPAND. You never know :)
NGINX_3TP_HTTP_MODULES="accesskey accept_language bytes_filter cache_purge
	chunkin echo gunzip h264 headers_more ip_tos_filter passenger push redis
	udplog upload upload_progress"
NGINX_3TP_OTHER_MODULES="eval events modzip mogilefs pam slowfs_cache supervisord
	upstream_fair upstream_jvm_route upstream_keepalive"
IUSE="addition aio debug fastcgi http flv image-filter imap ipv6 logrotate pcre
	perl pop random-index realip securelink smtp ssl static-gzip status sub
	webdav xslt zlib ${NGINX_3TP_HTTP_MODULES} ${NGINX_3TP_OTHER_MODULES}"

SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz
	accesskey? ( http://wiki.nginx.org/images/5/51/Nginx-accesskey-2.0.3.tar.gz )
	accept_language? ( http://github.com/giom/nginx_accept_language_module/tarball/master/giom-nginx_accept_language_module-02262ce.tar.gz )
	bytes_filter? ( http://mdounin.ru/hg/ngx_http_bytes_filter_module/archive/tip.tar.gz/ngx_http_bytes_filter_module-57365655ee44.tar.gz )
	cache_purge? ( http://labs.frickle.com/files/ngx_cache_purge-1.0.tar.gz )
	chunkin? ( http://github.com/agentzh/chunkin-nginx-module/tarball/v0.07/agentzh-chunkin-nginx-module-fad343d.tar.gz )
	echo? ( http://github.com/agentzh/echo-nginx-module/tarball/v0.23/agentzh-echo-nginx-module-346eadb.tar.gz )
	eval? ( http://github.com/vkholodkov/nginx-eval-module/tarball/1.0.1/vkholodkov-nginx-eval-module-9a8e8ab.tar.gz )
	events? ( http://hg.dutov.org/nginx-module-events/archive/tip.tar.bz2/nginx-module-events-49ab119a468c.tar.bz2 )
	gunzip? ( http://mdounin.ru/files/ngx_http_gunzip_filter_module-0.1.tar.gz )
	h264? ( http://h264.code-shop.com/download/nginx_mod_h264_streaming-2.2.5.tar.gz )
	ip_tos_filter? ( http://mdounin.ru/hg/ngx_http_ip_tos_filter_module/archive/tip.tar.gz/ngx_http_ip_tos_filter_module-a23404790f33.tar.gz )
	headers_more? ( http://github.com/agentzh/headers-more-nginx-module/tarball/v0.05/agentzh-headers-more-nginx-module-8288003.tar.gz )
	modzip? ( http://mod-zip.googlecode.com/files/mod_zip-1.1.5.tar.gz )
	mogilefs? ( http://github.com/vkholodkov/nginx-mogilefs-module/tarball/1.0.2/vkholodkov-nginx-mogilefs-module-249f2b0.tar.gz )
	pam? ( http://web.iti.upv.es/~sto/nginx/ngx_http_auth_pam_module-1.1.tar.gz )
	push? ( http://pushmodule.slact.net/downloads/nginx_http_push_module-0.69.tar.gz )
	redis? ( http://people.freebsd.org/~osa/ngx_http_redis-0.3.1.tar.gz )
	slowfs_cache? ( http://labs.frickle.com/files/ngx_slowfs_cache-1.2.tar.gz )
	supervisord? ( http://labs.frickle.com/files/ngx_supervisord-1.3.tar.gz )
	udplog? ( http://www.grid.net.ru/nginx/download/nginx_udplog_module-1.0.0.tar.gz )
	upload? ( http://www.grid.net.ru/nginx/download/nginx_upload_module-2.0.11.tar.gz )
	upload_progress? ( http://github.com/masterzen/nginx-upload-progress-module/tarball/v0.7/masterzen-nginx-upload-progress-module-ac62a29.tar.gz )
	upstream_fair? ( http://github.com/gnosek/nginx-upstream-fair/tarball/master/gnosek-nginx-upstream-fair-2131c73.tar.gz )
	upstream_jvm_route? ( http://nginx-upstream-jvm-route.googlecode.com/files/nginx-upstream-jvm-route-0.1.tar.gz )
	upstream_keepalive? ( http://mdounin.ru/hg/ngx_http_upstream_keepalive/archive/tip.tar.gz/ngx_http_upstream_keepalive-2ce9d8a1ca93.tar.gz )"

S="${WORKDIR}"

# Note regarding ARM arch and dependency to dev-libs/libatomic_ops:
# http://nginx.org/pipermail/nginx/2009-September/015726.html
RDEPEND="sys-apps/coreutils
	sys-apps/sed
	aio? ( dev-libs/libaio )
	arm? ( dev-libs/libatomic_ops )
	passenger? ( dev-ruby/passenger[nginx] )
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( >=dev-libs/openssl-0.9.7 )
	logrotate? ( app-admin/logrotate )
	http? (
		pam? ( sys-libs/pam )
		perl? ( >=dev-lang/perl-5.8 )
		zlib? ( sys-libs/zlib )
		xslt? (
			dev-libs/libxml2
			dev-libs/libxslt
		)
		image-filter? ( media-libs/gd )
	)
"
DEPEND="${RDEPEND}"

pkg_setup() {
	if ! use http; then
		if use accesskey || use accept_language || use bytes_filter || \
			use cache_purge || use chunkin || use echo || use gunzip || \
			use h264 || use headers_more || use ip_tos_filter || use pam || \
			use passenger || use push || use redis || use udplog || \
			use upload || use upload_progress || use addition || use flv || \
			use sub || use perl || use status || use webdav || use fastcgi || \
			use xslt || use zlib; then
			ewarn
			ewarn "You enabled HTTP specific USE flags but have not enabled the \"http\""
			ewarn "USE flag. Not enabling \"http\" USE flag will disable following"
			ewarn "modules:"
			for mod in $NGINX_3TP_HTTP_MODULES; do
				ewarn "  - ${mod}"
			done
			ewarn "  - addition"
			ewarn "  - flv"
			ewarn "  - image-filter"
			ewarn "  - random-index"
			ewarn "  - realip"
			ewarn "  - status"
			ewarn "  - sub"
			ewarn "  - webdav"
			ewarn "  - fastcgi"
			ewarn "  - xslt"
			ewarn "  - zlib"
			ewarn
			einfo "Please stop this build, and activate \"http\" USE flag if you"
			einfo "need HTTP functionality."
			ebeep 5
			epause 20
		fi
	fi
	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}
	if use ipv6; then
		ewarn "Note that ipv6 support in nginx is still experimental."
		ewarn "Be sure to read comments on gentoo bug #274614"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=274614"
	fi
}

src_unpack() {
	cd "${S}"
	unpack ${A}
	if use http; then
		if use accesskey; then
			mv "${WORKDIR}"/*nginx-accesskey-* "${WORKDIR}"/accesskey-module/ || die
		fi
		if use accept_language; then
			mv "${WORKDIR}"/*-nginx_accept_language_module-* "${WORKDIR}"/accept-language-module/ || die
		fi
		if use bytes_filter; then
			mv "${WORKDIR}"/*ngx_http_bytes_filter_module-* "${WORKDIR}"/bytes-filter-module/ || die
		fi
		if use cache_purge; then
			mv "${WORKDIR}"/ngx_cache_purge-* "${WORKDIR}"/cache-purge-module/ || die
		fi
		if use chunkin; then
			mv "${WORKDIR}"/*-chunkin-nginx-module-* "${WORKDIR}"/chunkin-module/ || die
		fi
		if use echo; then
			mv "${WORKDIR}"/*-echo-nginx-module-* "${WORKDIR}"/echo-module/ || die
		fi
		if use gunzip; then
			mv "${WORKDIR}"/ngx_http_gunzip_filter_module-* "${WORKDIR}"/gunzip-module/ || die
		fi
		if use h264; then
			mv "${WORKDIR}"/*_mod_h264_streaming-* "${WORKDIR}"/h264-streaming-module/ || die
		fi
		if use headers_more; then
			mv "${WORKDIR}"/*-headers-more-nginx-module-* "${WORKDIR}"/headers-more-module/ || die
		fi
		if use ip_tos_filter; then
			mv "${WORKDIR}"/*ngx_http_ip_tos_filter_module-* "${WORKDIR}"/ip-tos-filter-module/ || die
		fi
		if use pam; then
			mv "${WORKDIR}"/*_auth_pam_* "${WORKDIR}"/auth-pam-module/ || die
		fi
		if use push; then
			mv "${WORKDIR}"/nginx_http_push_module-* "${WORKDIR}"/push-module/ || die
		fi
		if use redis; then
			mv "${WORKDIR}"/ngx_http_redis-* "${WORKDIR}"/redis-module/ || die
		fi
		if use udplog; then
			mv "${WORKDIR}"/nginx_udplog_module-* "${WORKDIR}"/udplog-module/ || die
			cd "${WORKDIR}"/udplog-module || die
			# This patch is only for udplog-1.0.0
			epatch "${FILESDIR}"/udplog_0_8_32.patch || die
		fi
		if use upload; then
			mv "${WORKDIR}"/nginx_upload_module-* "${WORKDIR}"/upload-module/ || die
		fi
		if use upload_progress; then
			mv "${WORKDIR}"/*-nginx-upload-progress-module-* "${WORKDIR}"/upload-progress-module/ || die
		fi
	fi
	if use eval; then
		mv "${WORKDIR}"/*-nginx-eval-module-* "${WORKDIR}"/eval-module/ || die
	fi
	if use events; then
		mv "${WORKDIR}"/NGINX-Module-events-* "${WORKDIR}"/events-module/ || die
	fi
	if use modzip; then
		mv "${WORKDIR}"/*mod_zip-* "${WORKDIR}"/mod-zip-module/ || die
		if [ "${PV:0:1}" -eq "0" -a "${PV:2:1}" -eq "8" -a "${PV:4:2}" -le "9" ]; then
			cd "${WORKDIR}"/"${P}" || die
			epatch "${WORKDIR}"/mod-zip-module/nginx-0.8.9-etag.patch || die
		fi
	fi
	if use mogilefs; then
		mv "${WORKDIR}"/*-nginx-mogilefs-module-* "${WORKDIR}"/mogilefs-module/ || die
	fi
	if use slowfs_cache; then
		mv "${WORKDIR}"/ngx_slowfs_cache-* "${WORKDIR}"/slowfs-cache-module/ || die
	fi
	if use upstream_fair; then
		mv "${WORKDIR}"/*upstream-fair-* "${WORKDIR}"/upstream-fair-module/ || die
	fi
	if use upstream_jvm_route; then
		mv "${WORKDIR}"/nginx_upstream_jvm_route "${WORKDIR}"/upstream-jvm-route-module/ || die
		cd "${WORKDIR}"/"${P}" || die
		epatch "${WORKDIR}"/upstream-jvm-route-module/jvm_route.patch || die
	fi
	if use upstream_keepalive; then
		mv "${WORKDIR}"/ngx_http_upstream_keepalive-* "${WORKDIR}"/upstream-keepalive-module/ || die
	fi
	if use supervisord; then
		mv "${WORKDIR}"/ngx_supervisord-* "${WORKDIR}"/supervisord-module/ || die
		if [ "${PV:0:1}" -ge "0" -a "${PV:2:1}" -ge "8" -a "${PV:4:2}" -ge "0" -a "${PV:4:2}" -le "16" ]; then
			cd "${WORKDIR}"/"${P}" || die
			epatch "${WORKDIR}"/supervisord-module/patches/ngx_http_upstream_init_busy-0.8.0.patch || die
		elif [ "${PV:0:1}" -ge "0" -a "${PV:2:1}" -ge "8" -a "${PV:4:2}" -ge "17" ]; then
			cd "${WORKDIR}"/"${P}" || die
			epatch "${WORKDIR}"/supervisord-module/patches/ngx_http_upstream_init_busy-0.8.17.patch || die
		fi
		if use upstream_fair; then
			cd "${WORKDIR}"/upstream-fair-module || die
			epatch "${WORKDIR}"/supervisord-module/patches/ngx_http_upstream_fair_module.patch || die
		fi
	fi
	sed -i 's/ make/ \\$(MAKE)/' "${WORKDIR}"/${P}/auto/lib/perl/make || die
}

src_compile() {
	cd "${WORKDIR}"/"${P}"
	local myconf

	myconf="${myconf} --with-poll_module"
	myconf="${myconf} --with-select_module"
	#myconf="${myconf} --with-google_perftools_module"

	local without_http_modules="http http-cache http_access_module http_auth_basic_module http_autoindex_module http_browser_module http_charset_module http_empty_gif_module http_fastcgi_module http_geo_module http_gzip_module http_limit_req_module http_limit_zone_module http_map_module http_memcached_module http_proxy_module http_referer_module http_rewrite_module http_ssi_module http_upstream_ip_hash_module http_userid_module"

	if ! use http; then
		for foo in ${http_modules}; do
			myconf="${myconf} --without-${foo}"
		done
	else
		use addition		&& myconf="${myconf} --with-http_addition_module"
		use flv			&& myconf="${myconf} --with-http_flv_module"
		use zlib		|| myconf="${myconf} --without-http_gzip_module"
		use sub			&& myconf="${myconf} --with-http_sub_module"
		use realip		&& myconf="${myconf} --with-http_realip_module"
		use static-gzip		&& myconf="${myconf} --with-http_gzip_static_module"
		use perl		&& myconf="${myconf} --with-http_perl_module"
		use status		&& myconf="${myconf} --with-http_stub_status_module"
		use webdav		&& myconf="${myconf} --with-http_dav_module"
		use fastcgi		|| myconf="${myconf} --without-http_fastcgi_module"
		# HTTP RealIP is not really needed for FastCGI but the chance that one
		# runs the FastCGI process on a remote/proxied system is pretty high so
		# we enable that module when the user is using "fastcgi" USE flag.
		use fastcgi		&& myconf="${myconf} --with-http_realip_module"
		use xslt		&& myconf="${myconf} --with-http_xslt_module"
		use pcre		|| myconf="${myconf} --without-http_rewrite_module"
		use ssl			&& myconf="${myconf} --with-http_ssl_module"
		use random-index	&& myconf="${myconf} --with-http_random_index_module"
		use securelink		&& myconf="${myconf} --with-http_secure_link_module"
		use image-filter	&& myconf="${myconf} --with-http_image_filter_module"
		use accesskey		&& myconf="${myconf} --add-module=${WORKDIR}/accesskey-module"
		use accept_language	&& myconf="${myconf} --add-module=${WORKDIR}/accept-language-module"
		use bytes_filter	&& myconf="${myconf} --add-module=${WORKDIR}/bytes-filter-module"
		use cache_purge		&& myconf="${myconf} --add-module=${WORKDIR}/cache-purge-module"
		use chunkin		&& myconf="${myconf} --add-module=${WORKDIR}/chunkin-module"
		use echo		&& myconf="${myconf} --add-module=${WORKDIR}/echo-module"
		use gunzip		&& myconf="${myconf} --add-module=${WORKDIR}/gunzip-module"
		use h264		&& myconf="${myconf} --add-module=${WORKDIR}/h264-streaming-module"
		use headers_more	&& myconf="${myconf} --add-module=${WORKDIR}/headers-more-module"
		use ip_tos_filter	&& myconf="${myconf} --add-module=${WORKDIR}/ip-tos-filter-module"
		use pam			&& myconf="${myconf} --add-module=${WORKDIR}/auth-pam-module"
		use passenger   && myconf="${myconf} --add-module=`passenger-config --root`/ext/nginx"
		use push		&& myconf="${myconf} --add-module=${WORKDIR}/push-module"
		use redis		&& myconf="${myconf} --add-module=${WORKDIR}/redis-module"
		use udplog		&& myconf="${myconf} --add-module=${WORKDIR}/udplog-module"
		use upload		&& myconf="${myconf} --add-module=${WORKDIR}/upload-module"
		use upload_progress	&& myconf="${myconf} --add-module=${WORKDIR}/upload-progress-module"
	fi
	if use ssl; then
		( use imap || use pop || use smtp )	&& myconf="${myconf} --with-mail_ssl_module"
		myconf="${myconf} --with-sha1-asm --with-sha1=/usr/include/openssl"
	fi
	myconf="${myconf} $(use_with pcre pcre)"
	use aio			&& myconf="${myconf} --with-file-aio"
	use aio			&& myconf="${myconf} --with-aio_module" # This is very experimental but usable on Gentoo
	use ipv6		&& myconf="${myconf} --with-ipv6"
	use arm			&& myconf="${myconf} --with-libatomic"
	use debug		&& myconf="${myconf} --with-debug"
	( use imap || use pop || use smtp )	&& myconf="${myconf} --with-mail" # IMAP4/POP3/SMTP proxy support
	use pop			|| myconf="${myconf} --without-mail_pop3_module"
	use imap		|| myconf="${myconf} --without-mail_imap_module"
	use smtp		|| myconf="${myconf} --without-mail_smtp_module"
	use eval		&& myconf="${myconf} --add-module=${WORKDIR}/eval-module"
	use events		&& myconf="${myconf} --add-module=${WORKDIR}/events-module"
	use modzip		&& myconf="${myconf} --add-module=${WORKDIR}/mod-zip-module"
	use mogilefs		&& myconf="${myconf} --add-module=${WORKDIR}/mogilefs-module"
	use slowfs_cache	&& myconf="${myconf} --add-module=${WORKDIR}/slowfs-cache-module"
	use supervisord		&& myconf="${myconf} --add-module=${WORKDIR}/supervisord-module"
	use upstream_fair	&& myconf="${myconf} --add-module=${WORKDIR}/upstream-fair-module"
	use upstream_jvm_route	&& myconf="${myconf} --add-module=${WORKDIR}/upstream-jvm-route-module"
	use upstream_keepalive	&& myconf="${myconf} --add-module=${WORKDIR}/upstream-keepalive-module"

	# remove double entries
	myconf="$(echo ${myconf}|tr ' ' '\n'|sort -u|tr '\n' ' ')"

	tc-export CC
	./configure \
		--prefix=/usr \
		--with-cc-opt="-I${ROOT}/usr/include" \
		--with-ld-opt="-L${ROOT}/usr/lib" \
		--conf-path=/etc/${PN}/${PN}.conf \
		--http-log-path=/var/log/${PN}/access_log \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--http-client-body-temp-path=/var/tmp/${PN}/client \
		--http-proxy-temp-path=/var/tmp/${PN}/proxy \
		--http-fastcgi-temp-path=/var/tmp/${PN}/fastcgi \
		--with-md5-asm --with-md5=/usr/include \
		${myconf} || die "configure failed"

	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "failed to compile"
}

# Install module documentation or other module related files
install_module_files() {
	local mod_name=""
	local module_name=""
	if [ -n "${1}" ]; then
		mod_name="${1}"
		if use ${mod_name}; then
			case "${mod_name}" in
				accept_language)	module_name="accept-language-module";;
				bytes_filter)		module_name="bytes-filter-module";;
				cache_purge)		module_name="cache-purge-module";;
				chunkin)		module_name="chunkin-module";;
				echo)			module_name="echo-module";;
				eval)			module_name="eval-module";;
				gunzip)			module_name="gunzip-module";;
				h264)			module_name="h264-streaming-module";;
				headers_more)		module_name="headers-more-module";;
				ip_tos_filter)		module_name="ip-tos-filter-module";;
				pam)			module_name="auth-pam-module";;
				push)			module_name="push-module";;
				redis)			module_name="redis-module";;
				udplog)			module_name="udplog-module";;
				upload)			module_name="upload-module";;
				modzip)			module_name="mod-zip-module";;
				mogilefs)		module_name="mogilefs-module";;
				slowfs_cache)		module_name="slowfs-cache-module";;
				supervisord)		module_name="supervisord-module";;
				upstream_fair)		module_name="upstream-fair-module";;
				upstream_jvm_route)	module_name="upstream-jvm-route-module";;
				upstream_keepalive)	module_name="upstream-keepalive-module";;
			esac
			if [ -n "${module_name}" -a -d "${WORKDIR}"/${module_name} ]; then
				cd "${WORKDIR}"/${module_name} || die
				[ -f "LICENSE" ] && newdoc LICENSE LICENSE.${module_name}
				[ -f "README" ] && newdoc README README.${module_name}
				[ -f "CHANGES" ] && newdoc CHANGES CHANGES.${module_name}
				[ -f "Changelog" ] && newdoc Changelog Changelog.${module_name}
				[ -f "nginx.conf" ] && newdoc nginx.conf EXAMPLE.nginx.conf.${module_name}
				if [ "${mod_name}" = "accept_language" ]; then
					newdoc README.textile README.${module_name}
				elif [ "${mod_name}" = "push" ]; then
					newdoc changelog.txt changelog.txt.${module_name}
					newdoc protocol.txt protocol.txt.${module_name}
				elif [ "${mod_name}" = "udplog" ]; then
					newdoc LICENSE.ru LICENSE.ru.${module_name}
				elif [ "${mod_name}" = "uplod" ]; then
					newdoc example.php example.php.${module_name}
					newdoc upload.html upload.html.${module_name}
				elif [ "${mod_name}" = "upload_progress" ]; then
					newdoc test/client.sh test-client.sh.${module_name}
					newdoc test/stress.sh test-stress.sh.${module_name}
				elif [ "${mod_name}" = "upload_progress" ]; then
					dohtml doc/*.html
				fi
			fi
		fi
	fi
}

src_install() {
	cd "${WORKDIR}/${P}"
	local module_name=""

	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi}

	dosbin objs/nginx
	newinitd "${FILESDIR}"/nginx.init-r2 nginx || die

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	dodoc CHANGES{,.ru} README

	# logrotate
	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}"/nginx.logrotate nginx || die
	fi

	if use http; then
		dodir "${ROOT}"/var/www/localhost/htdocs
		insinto "${ROOT}"/var/www/localhost/htdocs
		doins html/*
		if use perl; then
			cd "${S}/${P}"/objs/src/http/modules/perl/
			einstall DESTDIR="${D}" INSTALLDIRS=vendor || die "failed to install perl stuff"
			fixlocalpod
		fi
		for foo in accept_language bytes_filter cache_purge chunkin echo eval gunzip h264 headers_more ip_tos_filter; do
			install_module_files ${foo}
		done
	fi
	for foo in modzip mogilefs slowfs_cache supervisord upstream_fair upstream_jvm_route upstream_keepalive; do
		install_module_files ${foo}
	done
}

pkg_postinst() {
	cd "${WORKDIR}/${P}"
	use ssl && {
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			dodir "${ROOT}"/etc/ssl/${PN}
			insinto "${ROOT}"/etc/ssl/${PN}/
			insopts -m0644 -o ${PN} -g {PN}
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	}
}
