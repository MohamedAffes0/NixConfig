{...}: {
  programs.ghostty = {
    enable = true;

    enableBashIntegration = true;
    enableFishIntegration = true;

    settings = {
      theme = "TokyoNight";
      background = "#1a1b26";

      background-opacity = 0.7;
      background-blur = true;
    };
  };
}
