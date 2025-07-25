{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  libnvme,
  json_c,
  zlib,
  python3Packages,
  udevCheckHook,
}:

stdenv.mkDerivation rec {
  pname = "nvme-cli";
  version = "2.11";

  src = fetchFromGitHub {
    owner = "linux-nvme";
    repo = "nvme-cli";
    rev = "v${version}";
    hash = "sha256-LkFYkfHeBKC/0kr33DKu7oXxXrtfu1YcpuwzRRWsHpc=";
  };

  mesonFlags = [
    "-Dversion-tag=${version}"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.nose2
    udevCheckHook
  ];
  buildInputs = [
    libnvme
    json_c
    zlib
  ];

  doInstallCheck = true;

  meta = with lib; {
    inherit (src.meta) homepage; # https://nvmexpress.org/
    description = "NVM-Express user space tooling for Linux";
    longDescription = ''
      NVM-Express is a fast, scalable host controller interface designed to
      address the needs for not only PCI Express based solid state drives, but
      also NVMe-oF(over fabrics).
      This nvme program is a user space utility to provide standards compliant
      tooling for NVM-Express drives. It was made specifically for Linux as it
      relies on the IOCTLs defined by the mainline kernel driver.
    '';
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      mic92
      vifino
    ];
    mainProgram = "nvme";
  };
}
