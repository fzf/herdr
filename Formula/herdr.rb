# Homebrew formula for fzf's herdr fork (https://github.com/fzf/herdr).
# The fork's master tracks upstream herdrdev/herdr (synced daily by a workflow)
# plus configurable copy-mode movement keys (keys.copy_mode_left/down/up/right).
# Tap:     brew tap fzf/herdr https://github.com/fzf/herdr.git
# Install: brew install --HEAD fzf/herdr/herdr
# Update:  brew upgrade --fetch-HEAD fzf/herdr/herdr
class Herdr < Formula
  desc "Agent multiplexer that lives in your terminal (fzf fork)"
  homepage "https://github.com/fzf/herdr"
  license "Apache-2.0"
  head "https://github.com/fzf/herdr.git", branch: "master"

  depends_on "rust" => :build
  depends_on "zig@0.16" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
    cd "vendor/libghostty-vt" do
      system "zig", "build", "--fetch=all"
    end
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"herdr", "completion")
  end

  test do
    assert_match "herdr", shell_output("#{bin}/herdr --version")
  end
end
