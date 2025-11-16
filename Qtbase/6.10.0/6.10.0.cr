class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:      "-B #{buildDirectoryPath}                                           \
                                        -G Ninja                                                            \
                                        -DCMAKE_INSTALL_PREFIX=/usr                                         \
                                        -DINSTALL_ARCHDATADIR=/usr/lib/qt#{majorVersion}                    \
                                        -DINSTALL_BINDIR=/usr/bin/qt#{majorVersion}                         \
                                        -DINSTALL_PLUGINSDIR=/usr/lib/qt#{majorVersion}/plugins             \
                                        -DINSTALL_INCLUDEDIR=/usr/include/qt#{majorVersion}                 \
                                        -DINSTALL_DATADIR=/usr/share/qt#{majorVersion}                      \
                                        -DINSTALL_DOCDIR=/usr/share/doc/qt#{majorVersion}                   \
                                        -DINSTALL_TRANSLATIONSDIR=/usr/share/qt#{majorVersion}/translations \
                                        -DINSTALL_SYSCONFDIR=/etc/xdg                                       \
                                        -DQT_UNITY_BUILD=ON                                                 \
                                        -DQT_FEATURE_relocatable=OFF                                        \
                                        -DQT_FEATURE_androiddeployqt=OFF                                    \
                                        -DQT_BUILD_TESTS_BY_DEFAULT=OFF                                     \
                                        -DQT_BUILD_EXAMPLES=OFF                                             \
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
                                        -DFEATURE_system_pcre2=#{option("Pcre2") ? "ON" : "OFF"}",
                        path:           mainWorkDirectoryPath,)
    end

    def build
        super

        runCmakeCommand(arguments:      "--build #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)
    end

    def prepareInstallation
        super

        runCmakeCommand(arguments:      "--install #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/profile.d")

        if File.exists?("#{Ism.settings.rootPath}etc/profile.d/qt.sh")
            copyFile(   "/etc/profile.d/qt.sh",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        else
            generateEmptyFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh")
        end

        qtData = <<-CODE
        QT#{majorVersion}DIR=/usr
        export QT#{majorVersion}DIR
        pathappend $QT#{majorVersion}DIR/bin
        pathappend /usr/lib/qt#{majorVersion}/plugins QT_PLUGIN_PATH
        pathappend $QT#{majorVersion}DIR/lib/plugins QT_PLUGIN_PATH
        pathappend /usr/lib/qt#{majorVersion}/qml QML2_IMPORT_PATH
        pathappend $QT#{majorVersion}DIR/lib/qml QML2_IMPORT_PATH
        CODE
        fileUpdateContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/profile.d/qt.sh",qtData)

        if isGreatestVersion
            directoryContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}", matchHidden: true).each do |filePath|

                fileName = filePath.lchop(filePath[0..filePath.rindex("/")])

                makeLink(   target: "/usr/bin/qt#{majorVersion}/#{fileName}",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/#{fileName}",
                            type:   :symbolicLinkByOverwrite)

            end
        end
    end

end
