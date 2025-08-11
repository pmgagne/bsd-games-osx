class BsdGamesSimple < Formula
  desc "Classic BSD command-line games collection"
  homepage "https://github.com/your-username/bsd-games"
  url "https://github.com/your-username/bsd-games/archive/v1.0.tar.gz"
  version "1.0"
  sha256 "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  license "BSD-3-Clause"

  depends_on "bsdmake" => :build
  depends_on "ncurses"

  def install
    # Set up build environment for the install script
    ENV["PREFIX"] = prefix
    ENV["BINDIR"] = bin
    ENV["MANDIR"] = man  
    ENV["SHAREDIR"] = share/"bsd-games"
    
    # The install script expects to find openbsd-games directory
    # In a real release, this would be included in the tarball
    unless Dir.exist?("openbsd-games")
      odie "openbsd-games directory not found. Please ensure the release includes game sources."
    end
    
    # Run the installation script
    system "./install.sh"
  end

  test do
    # Test a few representative games
    system "#{bin}/number", "42"
    system "#{bin}/caesar", "13", "hello"
    system "#{bin}/random", "100"
  end
end
