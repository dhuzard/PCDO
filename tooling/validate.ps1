param(
    [switch]$Install
)

if ($Install) {
    Write-Host "Installing Python dependencies..."
    pip install -r tooling/requirements.txt
}

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python is required (python not found in PATH)."
    exit 1
}

Write-Host "Parsing ontology and validating examples with SHACL..."
python tooling/validate.py

if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } else { exit 0 }

