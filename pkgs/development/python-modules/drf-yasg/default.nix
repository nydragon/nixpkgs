{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  django,
  djangorestframework,
  inflection,
  packaging,
  pytz,
  pyyaml,
  uritemplate,
  datadiff,
  dj-database-url,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "drf-yasg";
  version = "1.21.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-U9Qxl2m6wSHFa+GAlTQjkrZtdV6f3TCUFOGoa1w91eo=";
  };

  postPatch = ''
    # https://github.com/axnsan12/drf-yasg/pull/710
    sed -i "/packaging/d" requirements/base.txt
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    django
    djangorestframework
    inflection
    packaging
    pytz
    pyyaml
    uritemplate
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    datadiff
    dj-database-url
  ];

  env.DJANGO_SETTINGS_MODULE = "testproj.settings.local";

  preCheck = ''
    cd testproj
  '';

  # a lot of libraries are missing
  doCheck = false;

  pythonImportsCheck = [ "drf_yasg" ];

  meta = with lib; {
    description = "Generation of Swagger/OpenAPI schemas for Django REST Framework";
    homepage = "https://github.com/axnsan12/drf-yasg";
    maintainers = [ ];
    license = licenses.bsd3;
  };
}
