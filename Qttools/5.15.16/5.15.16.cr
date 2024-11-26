class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end
    
    def configure
        super

        runQmakeCommand(arguments:  "..",
                        path:       buildDirectoryPath,
                        environment:    {"PATH" => "/usr/bin/qt#{majorVersion}:/usr/lib/llvm/#{softwareMajorVersion("@ProgrammingLanguages-Main:Llvm")}/bin:$PATH"})
    end
    
    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps")
        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications")

        if option("Assistant")
            copyFile(   "#{buildDirectoryPath}/src/assistant/assistant/images/assistant-128.png",
                        "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/assistant-qt#{majorVersion}.png")
            assistantData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Assistant
            Comment=Shows Qt5 documentation and examples
            Exec=/usr/qt#{majorVersion}/bin/assistant
            Icon=assistant-qt#{majorVersion}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Documentation;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/assistant-qt#{majorVersion}.desktop",assistantData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}/assistant")
        end
        if option("Designer")
            copyFile("#{buildDirectoryPath}/src/designer/src/designer/images/designer.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/designer-qt#{majorVersion}.png")
            designerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Designer
            GenericName=Interface Designer
            Comment=Design GUIs for Qt5 applications
            Exec=/usr/qt#{majorVersion}/bin/designer
            Icon=designer-qt#{majorVersion}.png
            MimeType=application/x-designer;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/designer-qt#{majorVersion}.desktop",designerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}/designer")
        end
        if option("Linguist")
            copyFile("#{buildDirectoryPath}/src/linguist/linguist/images/icons/linguist-128-32.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/linguist-qt#{majorVersion}.png")
            linguistData = <<-CODE
            [Desktop Entry]
            Name=Qt5 Linguist
            Comment=Add translations to Qt5 applications
            Exec=/usr/qt#{majorVersion}/bin/linguist
            Icon=linguist-qt#{majorVersion}.png
            MimeType=text/vnd.trolltech.linguist;application/x-linguist;
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/linguist-qt#{majorVersion}.desktop",linguistData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}/linguist")
        end
        if option("Qdbusviewer")
            copyFile("#{buildDirectoryPath}/src/qdbus/qdbusviewer/images/qdbusviewer-128.png","#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/pixmaps/qdbusviewer-qt#{majorVersion}.png")
            qdbusviewerData = <<-CODE
            [Desktop Entry]
            Name=Qt5 QDbusViewer
            GenericName=D-Bus Debugger
            Comment=Debug D-Bus applications
            Exec=/usr/qt#{majorVersion}/bin/qdbusviewer
            Icon=qdbusviewer-qt#{majorVersion}.png
            Terminal=false
            Encoding=UTF-8
            Type=Application
            Categories=Qt;Development;Debugger;
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/share/applications/qdbusviewer-qt#{majorVersion}.desktop",qdbusviewerData)
        else
            deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/usr/bin/qt#{majorVersion}/qdbusviewer")
        end

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
