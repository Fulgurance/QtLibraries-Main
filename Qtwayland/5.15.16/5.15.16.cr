class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runQmakeCommand(arguments:  "..",
                        path:       buildDirectoryPath,
                        environment:    {"PATH" => "/usr/bin/qt#{majorVersion}:$PATH"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

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
