{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  mock,
  requests,
  six,
  urllib3,
  protobuf,
  pycryptodomex,
  vdf,
  vcrpy,
  gevent,
  pyee,
}:
buildPythonPackage rec {
  pname = "steam";
  version = "1.4.5";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "FailSpy";
    repo = "steam-py-lib";
    rev = "master";
    hash = "sha256-vbATzSi+107vCLb5CUAXwg9LoZ7RmgZRfzZNj5ADlOU=";
  };

  env.PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";

  doCheck = false;
  pytestCheckHook = false;
  propagatedBuildInputs = [
    six
    urllib3
    protobuf
    pycryptodomex
    vdf
  ];

  nativeCheckInputs = [
    mock
    gevent
    requests
    vcrpy
    pyee
    pytestCheckHook
  ];

  pythonImportsCheck = ["steam"];

  meta = with lib; {
    description = "Python package for interacting with Steam ";
    mainProgram = "steam";
    homepage = "https://github.com/ValvePython/steam";
    license = licenses.mit;
    maintainers = with maintainers; [Multipixelone];
  };
}
