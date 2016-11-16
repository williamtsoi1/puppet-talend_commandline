# == Class talend_commandline::service
#
# This class is meant to be called from talend_commandline.
# It ensure the service is running.
#
class talend_commandline::service (
  $cmdline_home,
  $cmdline_subfolder,
  $cmdline_user,
  $cmdline_port,
  $jmxremote_port,
){
  # setup cmdline service using supervisord
  class { '::supervisord':
    install_init => true,
    install_pip  => true,
  }
  supervisord::program { 'cmdline':
    command   => "/usr/bin/java -Xms512m -Xmx8192m -Dfile.encoding=UTF-8 -Dcom.sun.management.jmxremote \
    -Dcom.sun.management.jmxremote.port=${jmxremote_port} \
    -Dcom.sun.management.jmxremote.ssl=false \
    -Dcom.sun.management.jmxremote.authenticate=false \
    -jar /${cmdline_home}/${cmdline_subfolder}/plugins/org.eclipse.equinox.launcher_1.3.0.v20140415-2008.jar \
    -os linux -ws gtk -arch x86_64 \
    -launcher /${cmdline_home}/${cmdline_subfolder}/Talend-Studio-linux-gtk-x86_64 \
    -name Talend-Studio-linux-gtk-x86_64 \
    --launcher.library /${cmdline_home}/${cmdline_subfolder}/plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.200.v20140603-1326/eclipse_1605.so \
    -startup /${cmdline_home}/${cmdline_subfolder}/plugins/org.eclipse.equinox.launcher_1.3.0.v20140415-2008.jar \
    --launcher.overrideVmargs -exitdata 40005 -application org.talend.commandline.CommandLine \
    -consoleLog -data commandline-workspace startServer -p ${cmdline_port} \
    -vm /usr/bin/java -vmargs -Xms512m -Xmx8192m -Dfile.encoding=UTF-8 \
    -jar /${cmdline_home}/${cmdline_subfolder}/plugins/org.eclipse.equinox.launcher_1.3.0.v20140415-2008.jar",
    priority  => '100',
    directory => "/${cmdline_home}/${cmdline_subfolder}",
    user      => $cmdline_user,
  }
}
