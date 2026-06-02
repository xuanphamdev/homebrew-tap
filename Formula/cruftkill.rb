class Cruftkill < Formula
  desc "Polyglot dev-cache reaper — find and delete node_modules, .venv, target, DerivedData and the rest of your build cruft from a fast terminal UI"
  homepage "https://github.com/xuanphamdev/cruftkill"
  version "0.4.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.2/cruftkill-aarch64-apple-darwin.tar.xz"
      sha256 "a9597a81338a19afa85aa8a4e26fe6fdb7c1c442172b452ffd50960a74cff065"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.2/cruftkill-x86_64-apple-darwin.tar.xz"
      sha256 "972983cbf5b9c851f76f95c6309f809c78925275a77ba94f7a96056879fa4935"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.2/cruftkill-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "64cefd3d0b9de07519a277c72fcab4f5e644de5a42fa3b04bb071c0c01e77ae2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/xuanphamdev/cruftkill/releases/download/v0.4.2/cruftkill-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6e2fe7a866dd0270ace5ad737509d0a3f9a8df5edb50846880e928e3f249e93"
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
