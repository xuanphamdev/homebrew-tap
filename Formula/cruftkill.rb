class Cruftkill < Formula
  desc "Polyglot dev-cache reaper — find and delete node_modules, .venv, target, DerivedData and the rest of your build cruft from a fast terminal UI"
  homepage "https://github.com/xuanphamdev/cruftkill"
  version "0.4.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.1/cruftkill-aarch64-apple-darwin.tar.xz"
      sha256 "afa7b8ff82c9daf6535fd04950b4e87719cdd4aeeb45ffff0e233597866e0008"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.1/cruftkill-x86_64-apple-darwin.tar.xz"
      sha256 "aa605d209668c7c9ac260c2036b9a539ecf54f23b84cc421ca8d341adf59b141"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.1/cruftkill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "224d07cbeae4b38f8845e0796c6ae86e2de8f1d42f4e73339c9692d5d95b2892"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.1/cruftkill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9fc92370de54b4265a20d3318be72533fc649df862f8642b50f4ff0803cef610"
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
