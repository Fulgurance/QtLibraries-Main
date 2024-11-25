class Target < ISM::Software
    
    def configure
        super

        configureSource(arguments:  "--prefix=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}  \
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

        makeSource( arguments:  "install",
                    path:       buildDirectoryPath)

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

        exit 1
    end

    def install
        super

        runLdconfigCommand
    end

end
