# idleFix

**idleFix** This is a modular template to call Taskschedular to fix other similar issue of Windows App/EXE having high CPU consumption during idling/display off, just like issue of iCloud, see https://github.com/Zenqlo/iCloudFix. Windows (and Apple for iCloud) do not fix the bug, so I write a temporary fix. idleFix closes the process UI during system idle automatically by Task Scheduler, reducing CPU load while preserving core process functionality. 

## Usage

Edit *Installer.bat*, fill in your own **APP_NAME** as a name you like, **ProcessToFix** as the program name that has issue to idle, **INSTALL_DIR** as anywhere you like to save the Task Schedular folder, and **DESCRIPTION** as description section in Task schedular. 

Task Schduler settings can be found in TaskScheduler_Settings.xml. See https://github.com/Zenqlo/iCloudFix for details about how to edit.

Then run *Installer.bat* with Admin.

## Uninstall
Uninstall by removing the Scheduled Task in Taskschedular and your Task Schedular folder.

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
**Author**: Zenqlo  
**Last Updated**: May 16, 2025