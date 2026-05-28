class Cruftkill < Formula
  desc "Polyglot dev-cache reaper — find and delete node_modules, .venv, target, DerivedData and the rest of your build cruft from a fast terminal UI"
  homepage "https://github.com/xuanphamdev/cruftkill"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.0/cruftkill-aarch64-apple-darwin.tar.xz"
      sha256 "ff7612bee77ff3ebfa240cbe377ee8968022deea6d656495d65380da8232d930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.0/cruftkill-x86_64-apple-darwin.tar.xz"
      sha256 "48d491485cb1933c3b46cecab71afb698c793fb226fa8b40ade9c3a10d039de4"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.0/cruftkill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4618292d8a50e22063c2e04fd8a57723260ab09c449fa42570c792e84ea5dd5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.3.0/cruftkill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b34e1d1e88d2c1b4e36a99af6733ddccd3ae9dfae2bae08521ee3b9bd3915ad"
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
