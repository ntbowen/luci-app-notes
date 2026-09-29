include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-notes
PKG_VERSION:=0.1.0
PKG_RELEASE:=2

PKG_SKIP_DOWNLOAD:=1

PKG_MAINTAINER:=Viktors Zilinskis
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-notes
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:= 3. Applications
  TITLE:=LuCI Notes
  DEPENDS:=+luci-base +rpcd +rpcd-mod-ucode
  PKGARCH:=all
endef

define Package/luci-app-notes/description
  Simple Markdown notes application for LuCI.
endef

define Package/luci-app-notes/conffiles
/etc/notes.md
endef

define Package/luci-app-notes/postinst
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache*
	rm -rf /tmp/luci-modulecache
	/etc/init.d/rpcd restart 2>/dev/null
}
exit 0
endef

define Package/luci-app-notes/postrm
#!/bin/sh
[ -n "$${IPKG_INSTROOT}" ] || {
	rm -f /tmp/luci-indexcache*
	rm -rf /tmp/luci-modulecache
	/etc/init.d/rpcd restart 2>/dev/null
}
exit 0
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
endef

define Package/luci-app-notes/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) ./root/etc/notes.md \
		$(1)/etc/notes.md

	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/luci-app-notes.json \
		$(1)/usr/share/luci/menu.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/luci-app-notes.json \
		$(1)/usr/share/rpcd/acl.d/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/ucode
	$(INSTALL_DATA) ./root/usr/share/rpcd/ucode/notes \
		$(1)/usr/share/rpcd/ucode/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/view
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/notes.js \
		$(1)/www/luci-static/resources/view/

	$(INSTALL_DIR) $(1)/www/luci-static/resources/notes
	$(INSTALL_DATA) ./htdocs/luci-static/resources/notes/markdown.js \
		$(1)/www/luci-static/resources/notes/
	$(INSTALL_DATA) ./htdocs/luci-static/resources/notes/notes.css \
		$(1)/www/luci-static/resources/notes/
endef

$(eval $(call BuildPackage,luci-app-notes))
