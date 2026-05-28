class Cruftkill < Formula
  desc "Polyglot dev-cache reaper — find and delete node_modules, .venv, target, DerivedData and the rest of your build cruft from a fast terminal UI"
  homepage "https://github.com/xuanphamdev/cruftkill"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.1/cruftkill-aarch64-apple-darwin.tar.xz"
      sha256 "960aa86a54f8147b3a255c62b2a390284572827944993696863160a880676d66"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.1/cruftkill-x86_64-apple-darwin.tar.xz"
      sha256 "4d50b4f8db20092d5f2144a97c7d259a293909f80c451ac7637ac4e8c3f76e65"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.1/cruftkill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d08f6ecaa90b7214275011d89bbfe17a699fefc9974dbcf72d9d1b07cb8e23b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.1/cruftkill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5954e7e0981a90dd1c0836604f4a9d5185d2e16603edcd3b5db5b85600fee826"
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
