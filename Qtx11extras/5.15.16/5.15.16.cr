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

        makeSource( arguments:  "INSTALL_ROOT=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

    def install
        super

        runLdconfigCommand
    end

end
