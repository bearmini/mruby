MRuby::Build.new do |conf|
  # load specific toolchain settings
  toolchain :gcc

  # Use mrbgems
  # conf.gem 'examples/mrbgems/ruby_extension_example'
  # conf.gem 'examples/mrbgems/c_extension_example' do |g|
  #   g.cc.flags << '-g' # append cflags in this gem
  # end
  # conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
  # conf.gem :github => 'masuidrive/mrbgems-example', :branch => 'master'
  # conf.gem :git => 'git@github.com:masuidrive/mrbgems-example.git', :branch => 'master', :options => '-v'

  # include the default GEMs
  conf.gembox 'default'

  # C compiler settings
  # conf.cc do |cc|
  #   cc.command = ENV['CC'] || 'gcc'
  #   cc.flags = [ENV['CFLAGS'] || %w()]
  #   cc.include_paths = ["#{root}/include"]
  #   cc.defines = %w(DISABLE_GEMS)
  #   cc.option_include_path = '-I%s'
  #   cc.option_define = '-D%s'
  #   cc.compile_options = "%{flags} -MMD -o %{outfile} -c %{infile}"
  # end

  # mrbc settings
  # conf.mrbc do |mrbc|
  #   mrbc.compile_options = "-g -B%{funcname} -o-" # The -g option is required for line numbers
  # end

  # Linker settings
  # conf.linker do |linker|
  #   linker.command = ENV['LD'] || 'gcc'
  #   linker.flags = [ENV['LDFLAGS'] || []]
  #   linker.flags_before_libraries = []
  #   linker.libraries = %w()
  #   linker.flags_after_libraries = []
  #   linker.library_paths = []
  #   linker.option_library = '-l%s'
  #   linker.option_library_path = '-L%s'
  #   linker.link_options = "%{flags} -o %{outfile} %{objs} %{libs}"
  # end
 
  # Archiver settings
  # conf.archiver do |archiver|
  #   archiver.command = ENV['AR'] || 'ar'
  #   archiver.archive_options = 'rs %{outfile} %{objs}'
  # end
 
  # Parser generator settings
  # conf.yacc do |yacc|
  #   yacc.command = ENV['YACC'] || 'bison'
  #   yacc.compile_options = '-o %{outfile} %{infile}'
  # end
 
  # gperf settings
  # conf.gperf do |gperf|
  #   gperf.command = 'gperf'
  #   gperf.compile_options = '-L ANSI-C -C -p -j1 -i 1 -g -o -t -N mrb_reserved_word -k"1,3,$" %{infile} > %{outfile}'
  # end
  
  # file extensions
  # conf.exts do |exts|
  #   exts.object = '.o'
  #   exts.executable = '' # '.exe' if Windows
  #   exts.library = '.a'
  # end

  # file separetor
  # conf.file_separator = '/'
end

# Define cross build settings
# MRuby::CrossBuild.new('32bit') do |conf|
#   toolchain :gcc
#   
#   conf.cc.flags << "-m32"
#   conf.linker.flags << "-m32"
#
#   conf.build_mrbtest_lib_only
#   
#   conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
#
#   conf.test_runner.command = 'env'
#
# end

TIZEN_SDK = "#{ENV['HOME']}/tizen-sdk"
TIZEN_GCC_I386_TOOLCHAIN_BASE = "#{TIZEN_SDK}/tools/i386-linux-gnueabi-gcc-4.5"
TIZEN_GCC_I386_BIN = "#{TIZEN_GCC_I386_TOOLCHAIN_BASE}/bin"
TIZEN_GCC_I386_EMULATOR_BASE = "#{TIZEN_SDK}/platforms/tizen2.2/rootstraps/tizen-emulator-2.2.native"
 
MRuby::CrossBuild.new('tizen-x86') do |conf|
  toolchain :gcc
 
  # Use standard print/puts/p
  conf.gem "#{root}/mrbgems/mruby-print"
 
  # Use Process class and Kernel $$, ::exit, ::fork, ::sleep, ::system
  conf.gem :git => 'https://github.com/iij/mruby-process.git'
 
  # Generate mirb command
  conf.gem "#{root}/mrbgems/mruby-bin-mirb"
 
  # Generate mruby command
  conf.gem "#{root}/mrbgems/mruby-bin-mruby"
 
  conf.cc.command = "#{TIZEN_GCC_I386_BIN}/i386-linux-gnueabi-gcc"
  conf.cc.flags << "-O0 -g3 -Wall -c -fmessage-length=0 -fPIE " +
    "--sysroot=\"#{TIZEN_GCC_I386_EMULATOR_BASE}\" " +
    "-I\"#{TIZEN_GCC_I386_EMULATOR_BASE}/usr/include\" " +
    "-I\"#{TIZEN_GCC_I386_EMULATOR_BASE}/usr/include/libxml2\" " +
    "-I\"#{TIZEN_GCC_I386_EMULATOR_BASE}/usr/include/osp\" " +
    "-I\"#{TIZEN_SDK}/library\" " +
    "-D_DEBUG"
 
  conf.linker.command = "#{TIZEN_GCC_I386_BIN}/i386-linux-gnueabi-g++"
  conf.linker.flags << "-Xlinker --as-needed -pie -lpthread -Xlinker -rpath=\$$ORIGIN/.. " +
    "-Xlinker -rpath=\$$ORIGIN/../lib -Xlinker -rpath=/home/developer/sdk_tools/lib " +
    "--sysroot=\"#{TIZEN_GCC_I386_EMULATOR_BASE}\" " +
    "-L\"#{TIZEN_GCC_I386_EMULATOR_BASE}/usr/lib\" " +
    "-L\"#{TIZEN_GCC_I386_EMULATOR_BASE}/usr/lib/osp\" " +
    "-losp-appfw -losp-uifw -losp-image -losp-json -losp-ime -losp-net -lpthread " +
    "-losp-content -losp-locations -losp-telephony -losp-uix -losp-media -losp-messaging " +
    "-losp-web -losp-social -losp-wifi -losp-bluetooth -losp-nfc -losp-face -losp-speech-tts " +
    "-losp-speech-stt -losp-shell -losp-shell-core -lxml2"
 
  conf.archiver.command = "#{TIZEN_GCC_I386_BIN}/i386-linux-gnueabi-ar"
 
  conf.build_mrbtest_lib_only
 
  conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
end
 
 
TIZEN_GCC_ARM_TOOLCHAIN_BASE = "#{TIZEN_SDK}/tools/arm-linux-gnueabi-gcc-4.5"
TIZEN_GCC_ARM_BIN = "#{TIZEN_GCC_ARM_TOOLCHAIN_BASE}/bin"
TIZEN_GCC_ARM_DEVICE_BASE = "#{TIZEN_SDK}/platforms/tizen2.2/rootstraps/tizen-device-2.2.native"
 
MRuby::CrossBuild.new('tizen-arm') do |conf|
  toolchain :gcc
 
  # Use standard print/puts/p
  conf.gem "#{root}/mrbgems/mruby-print"
 
  # Use Process class and Kernel $$, ::exit, ::fork, ::sleep, ::system
  conf.gem :git => 'https://github.com/iij/mruby-process.git'
 
  # Generate mirb command
  conf.gem "#{root}/mrbgems/mruby-bin-mirb"
 
  # Generate mruby command
  conf.gem "#{root}/mrbgems/mruby-bin-mruby"
 
  conf.cc.command = "#{TIZEN_GCC_ARM_BIN}/arm-linux-gnueabi-gcc"
  conf.cc.flags << "-O0 -g3 -Wall -c -fmessage-length=0 -fPIE " +
    "--sysroot=\"#{TIZEN_GCC_ARM_DEVICE_BASE}\" " +
    "-I\"#{TIZEN_GCC_ARM_DEVICE_BASE}/usr/include\" " +
    "-I\"#{TIZEN_GCC_ARM_DEVICE_BASE}/usr/include/libxml2\" " +
    "-I\"#{TIZEN_GCC_ARM_DEVICE_BASE}/usr/include/osp\" " +
    "-I\"#{TIZEN_SDK}/library\" " +
    "-D_DEBUG"
 
  conf.linker.command = "#{TIZEN_GCC_ARM_BIN}/arm-linux-gnueabi-g++"
  conf.linker.flags << "-Xlinker --as-needed -pie -lpthread -Xlinker -rpath=\$$ORIGIN/.. " +
    "-Xlinker -rpath=\$$ORIGIN/../lib -Xlinker -rpath=/home/developer/sdk_tools/lib " +
    "--sysroot=\"#{TIZEN_GCC_ARM_DEVICE_BASE}\" " +
    "-L\"#{TIZEN_GCC_ARM_DEVICE_BASE}/usr/lib\" " +
    "-L\"#{TIZEN_GCC_ARM_DEVICE_BASE}/usr/lib/osp\" " +
    "-losp-appfw -losp-uifw -losp-image -losp-json -losp-ime -losp-net -lpthread " +
    "-losp-content -losp-locations -losp-telephony -losp-uix -losp-media -losp-messaging " +
    "-losp-web -losp-social -losp-wifi -losp-bluetooth -losp-nfc -losp-face -losp-speech-tts " +
    "-losp-speech-stt -losp-shell -losp-shell-core -lxml2"
 
  conf.archiver.command = "#{TIZEN_GCC_ARM_BIN}/arm-linux-gnueabi-ar"
 
  conf.build_mrbtest_lib_only
 
  conf.gem 'examples/mrbgems/c_and_ruby_extension_example'
end
