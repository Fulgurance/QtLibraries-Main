class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                              \
                                    --archdatadir=/usr/lib/qt#{majorVersion}                    \
                                    --bindir=/usr/bin/qt#{majorVersion}                         \
                                    --plugindir=/usr/lib/qt#{majorVersion}/plugins              \
                                    --importdir=/usr/lib/qt#{majorVersion}/imports              \
                                    --headerdir=/usr/include/qt#{majorVersion}                  \
                                    --datadir=/usr/share/qt#{majorVersion}                      \
                                    --docdir=/usr/share/doc/qt#{majorVersion}                   \
                                    --translationdir=/usr/share/qt#{majorVersion}/translations  \
                                    --sysconfdir=/etc/xdg                           \
                                    --confirm-license                               \
                                    --opensource                                    \
                                    #{option("Dbus") ? "--dbus-linked" : ""}        \
                                    #{option("Openssl") ? "--openssl-linked" : ""}  \
                                    #{option("Harfbuzz") ? "-system-harfbuzz" : ""} \
                                    #{option("Sqlite") ? "-system-sqlite" : ""}     \
                                    #{option("Xcb") ? "-xcb" : ""}                  \
                                    #{option("Cups") ? "-cups" : ""}                \
                                    --nomake=examples                               \
                                    --no-rpath                                      \
                                    --syslog",
                        path:       buildDirectoryPath)
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "INSTALL_ROOT=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

    def install
        super

        runLdconfigCommand
    end

end
