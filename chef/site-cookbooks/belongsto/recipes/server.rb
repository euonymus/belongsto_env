# Memory Swap settings
execute "build_swapfile" do
  command "dd if=/dev/zero of=/swapfile bs=32M count=32"
  not_if { File.exists?("/swapfile") }
end

if File.readlines("/etc/fstab").grep(/swapfile/).size == 0
  execute "init_swapfile" do
    command "mkswap /swapfile"
  end

  execute "activate_swapfile" do
    command "swapon /swapfile"
  end

  execute "swap_setting_to_fstab" do
    command "echo '/swapfile swap swap defaults 0 0' >> /etc/fstab"
  end
end
