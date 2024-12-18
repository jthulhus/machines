{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    isgit
  ];

  programs.bash = {
    promptInit = builtins.readFile ../../home/shell/make_prompt.sh;
  };
}
