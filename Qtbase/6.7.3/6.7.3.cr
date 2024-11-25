class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:      "-DCMAKE_INSTALL_PREFIX=/usr                                        \
                                        -DINSTALL_ARCHDATADIR=/usr/lib/qt#{majorVersion}                    \
                                        -DINSTALL_BINDIR=/usr/bin/qt#{majorVersion}                         \
                                        -DINSTALL_PLUGINSDIR=/usr/lib/qt#{majorVersion}/plugin              \
                                        -DINSTALL_INCLUDEDIR=/usr/include/qt#{majorVersion}                 \
                                        -DINSTALL_DATADIR=/usr/share/qt#{majorVersion}                      \
                                        -DINSTALL_DOCDIR=/usr/share/doc/qt#{majorVersion}                   \
                                        -DINSTALL_TRANSLATIONSDIR=/usr/share/qt#{majorVersion}/translations \
                                        -DINSTALL_SYSCONFDIR=/etc/xdg                                       \
                                        -DQT_UNITY_BUILD=ON                                                 \
                                        -DQT_FEATURE_relocatable=OFF                                        \
                                        -DQT_FEATURE_androiddeployqt=OFF                                    \
                                        -DQT_BUILD_EXAMPLES=OFF                                             \
                                        -DQT_BUILD_DOCS=OFF                                                 \
                                        -DFEATURE_rpath=OFF                                                 \
                                        -DFEATURE_dbus=#{option("Dbus") ? "ON" : "OFF"}                     \
                                        -DFEATURE_dbus_linked=#{option("Dbus") ? "ON" : "OFF"}              \
                                        -DFEATURE_openssl=#{option("Openssl") ? "ON" : "OFF"}               \
                                        -DFEATURE_openssl_linked=#{option("Openssl") ? "ON" : "OFF"}        \
                                        -DFEATURE_system_freetype=ON                                        \
                                        -DFEATURE_harfbuzz=#{option("Harfbuzz") ? "ON" : "OFF"}             \
                                        -DFEATURE_system_harfbuzz=#{option("Harfbuzz") ? "ON" : "OFF"}      \
                                        -DFEATURE_sql_sqlite=#{option("Sqlite") ? "ON" : "OFF"}             \
                                        -DFEATURE_system_sqlite=#{option("Sqlite") ? "ON" : "OFF"}          \
                                        -DFEATURE_xcb=#{option("Xcb") ? "ON" : "OFF"}                       \
                                        -DFEATURE_cups=#{option("Cups") ? "ON" : "OFF"}                     \
                                        -DFEATURE_system_zlib=ON                                            \
                                        -DFEATURE_system_pcre2=ON                                           \
                                        ..",
                        path:           buildDirectoryPath)
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
