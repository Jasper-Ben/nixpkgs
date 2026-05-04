{ lib, buildGoModule, fetchFromGitHub, versionCheckHook, mockgen, }:
buildGoModule (finalAttrs: {
  pname = "terragrunt";
  version = "test";

  src = fetchFromGitHub {
    owner = "martin31821";
    repo = "terragrunt";
    rev = "c6b1ee3163189e241eb0d2607592049a17a90da1";
    hash = "sha256-RyPsuFcVj35kJN29Rbna5kPdOAGxMiKRuguWw39inq8=";
  };

  nativeBuildInputs = [ mockgen ];

  proxyVendor = true;

  preBuild = ''
    make generate-mocks
  '';

  vendorHash = "sha256-LqkHHkX1kMuF4XtpxFPc6Xwas4B+jSMfMxSyv1nzerc=";

  excludedPackages = [ "test/flake" ];

  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/gruntwork-io/go-commons/version.Version=v${finalAttrs.version}"
    "-extldflags '-static'"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    homepage = "https://terragrunt.gruntwork.io";
    changelog =
      "https://github.com/gruntwork-io/terragrunt/releases/tag/v${finalAttrs.version}";
    description =
      "Thin wrapper for Terraform that supports locking for Terraform state and enforces best practices";
    mainProgram = "terragrunt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jk qjoly kashw2 ];
  };
})
