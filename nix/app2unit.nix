{
  pkgs, # To ensure the nixpkgs version of app2unit
  fetchFromGitHub,
  ...
}:
pkgs.app2unit.overrideAttrs (final: prev: rec {
  version = "1.3.0";
  src = fetchFromGitHub {
    owner = "Vladimir-csp";
    repo = "app2unit";
    tag = "v${version}";
    hash = "sha256-HkwcYYGNReDtPxZumnz3ZDb1sr1JcngAOqs/inO/350=";
  };
})
