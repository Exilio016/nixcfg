{ config, pkgs, ... }:
{
  hardware.graphics = { # Note: If on newer unstable channels, replace 'opengl' with 'graphics'
    enable = true;
    
    extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
    ];
    extraPackages32 = with pkgs.driversi686Linux; [
        intel-media-driver
    ];
  };

  # Make Vulkan tools and loader available globally
  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-tools # Provides vulkaninfo and other testing utilities
    vulkan-validation-layers
  ];

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Optionally, set the environment variable

  hardware.enableRedistributableFirmware = true;
  boot.kernelParams = [ "i915.enable_guc=3" ];
}
