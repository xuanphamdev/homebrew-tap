class Cruftkill < Formula
  desc "Polyglot dev-cache reaper — find and delete node_modules, .venv, target, DerivedData and the rest of your build cruft from a fast terminal UI"
  homepage "https://github.com/xuanphamdev/cruftkill"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.5/cruftkill-aarch64-apple-darwin.tar.xz"
      sha256 "1c61e47197937107c76970c60c51725ecaef131b8b9b65679dcd51566e84ebb1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.5/cruftkill-x86_64-apple-darwin.tar.xz"
      sha256 "22bc4e425c7f2e354eb683d8fd68179d0d26245003c22d42b9ef09cb39a3b2b2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.5/cruftkill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8571507bf4bd0d2462e52e577ca6b5920cf102dff15c2a18514d57f1118cd033"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.5/cruftkill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a6068bfcc942e60e2aef48ce3035d7132e1a81a3683a3f0becd021dadb76542"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "cft" if OS.mac? && Hardware::CPU.arm?
    bin.install "cft" if OS.mac? && Hardware::CPU.intel?
    bin.install "cft" if OS.linux? && Hardware::CPU.arm?
    bin.install "cft" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
