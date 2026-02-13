#!/bin/sh
# Logan installer — downloads the latest release binary for your platform.
# Usage: curl -fsSL https://wagneripjr.github.io/logan-pub/install.sh | sh

set -eu

REPO="wagneripjr/logan-pub"
INSTALL_DIR="${LOGAN_INSTALL_DIR:-/usr/local/bin}"

main() {
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"

  case "$os" in
    linux)  platform="linux" ;;
    darwin) platform="darwin" ;;
    *)
      echo "Error: unsupported OS: $os" >&2
      echo "Download manually from https://github.com/$REPO/releases/latest" >&2
      exit 1
      ;;
  esac

  case "$arch" in
    x86_64|amd64)  arch="amd64" ;;
    aarch64|arm64) arch="arm64" ;;
    *)
      echo "Error: unsupported architecture: $arch" >&2
      echo "Download manually from https://github.com/$REPO/releases/latest" >&2
      exit 1
      ;;
  esac

  binary="logan-${platform}-${arch}"

  # Only darwin-arm64 and linux-{amd64,arm64} are published
  if [ "$platform" = "darwin" ] && [ "$arch" = "amd64" ]; then
    echo "Error: macOS x86_64 builds are not available. Use darwin-arm64 (Apple Silicon)." >&2
    exit 1
  fi

  echo "Detected: ${platform}/${arch}"
  echo "Binary:   ${binary}"

  # Resolve latest release tag
  tag="$(curl -fsSL -o /dev/null -w '%{redirect_url}' "https://github.com/$REPO/releases/latest" | grep -oE '[^/]+$')"
  if [ -z "$tag" ]; then
    echo "Error: could not determine latest release tag" >&2
    exit 1
  fi
  echo "Version:  ${tag}"

  url="https://github.com/$REPO/releases/download/${tag}/${binary}"

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  echo "Downloading ${url}..."
  if ! curl -fSL -o "$tmpdir/logan" "$url"; then
    echo "Error: download failed" >&2
    echo "Check available binaries at https://github.com/$REPO/releases/latest" >&2
    exit 1
  fi

  chmod +x "$tmpdir/logan"

  # Install — use sudo if needed
  if [ -w "$INSTALL_DIR" ]; then
    mv "$tmpdir/logan" "$INSTALL_DIR/logan"
  else
    echo "Installing to ${INSTALL_DIR} (requires sudo)..."
    sudo mv "$tmpdir/logan" "$INSTALL_DIR/logan"
  fi

  echo ""
  echo "Installed logan ${tag} to ${INSTALL_DIR}/logan"
  echo "Run 'logan --help' to get started."
}

main
