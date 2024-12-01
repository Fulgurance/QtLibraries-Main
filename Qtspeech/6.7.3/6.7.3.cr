class Target < ISM::Software
    
    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runCmakeCommand(arguments:      "-B #{buildDirectoryPath}   \
                                        -G Ninja                    \
                                        -DCMAKE_MESSAGE_LOG_LEVEL=STATUS",
                        path:           mainWorkDirectoryPath,
                        environment:    {"PATH" => "/usr/bin/qt#{majorVersion}:$PATH"})
    end

    def build
        super

        runCmakeCommand(arguments:      "--build #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)
    end

    def prepareInstallation
        super

        runCmakeCommand(arguments:      "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}  \
                                        --install #{buildDirectoryPath}",
                        path:           mainWorkDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin")

        if isGreatestVersion
            directoryContent("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}", matchHidden: true).each do |filePath|
                fileName = filePath.lchop(filePath[0..filePath.rindex("/")])
                makeLink(   target: "/usr/bin/qt#{majorVersion}/#{fileName}",
                            path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/#{fileName}",
                            type:   :symbolicLinkByOverwrite)
            end
        end
    end

    def install
        super

        runLdconfigCommand
    end

end
