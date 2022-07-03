{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    isgit
  ];

  programs.bash = {
    promptInit = builtins.readFile ../home/bash/make_prompt.sh;
  };
}
