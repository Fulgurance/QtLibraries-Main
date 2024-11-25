class Target < ISM::Software
    
    def configure
        super

        prefix = "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"

        configureSource(arguments:  "--prefix=#{prefix}                                              \
                                    --archdatadir=#{prefix}/lib/qt#{majorVersion}                    \
                                    --bindir=#{prefix}/bin/qt#{majorVersion}                         \
                                    --plugindir=#{prefix}/lib/qt#{majorVersion}/plugins              \
                                    --importdir=#{prefix}/lib/qt#{majorVersion}/imports              \
                                    --headerdir=#{prefix}/include/qt#{majorVersion}                  \
                                    --datadir=#{prefix}/share/qt#{majorVersion}                      \
                                    --docdir=#{prefix}/share/doc/qt#{majorVersion}                   \
                                    --translationdir=#{prefix}/share/qt#{majorVersion}/translations  \
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

        makeSource( arguments:  "install",
                    path:       buildDirectoryPath)

        exit 1
    end

    def install
        super

        runLdconfigCommand
    end

end
