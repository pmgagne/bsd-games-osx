class BsdGames < Formula
  desc "Collection of 43 classic BSD games ported to macOS"
  homepage "https://github.com/username/bsd-games"
  url "https://github.com/username/bsd-games/archive/v1.0.0.tar.gz"
  sha256 "INSERT_SHA256_HERE"
  license "BSD-3-Clause"

  depends_on "bsdmake"
  depends_on "ncurses"

  def install
    # Set up environment for building
    ENV["CFLAGS"] = "-Os -pipe -Werror-implicit-function-declaration -include #{buildpath}/pledge_stub.h"
    ENV["HOSTCC"] = "cc -include #{buildpath}/pledge_stub.h"

    cd "openbsd-games" do
      # Build simple games
      %w[
        tetris robots gomoku snake worms arithmetic primes bcd ppt banner
        number random grdc caesar fish bs cribbage adventure battlestar
        mille morse pig pom rain quiz monop phantasia atc wump worm trek sail
      ].each do |game|
        cd game do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]}", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install game
        end
      end

      # Build factor (needs primes headers)
      cd "factor" do
        system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../primes", "HOSTCC=#{ENV["HOSTCC"]}"
        bin.install "factor"
      end

      # Build Boggle system
      cd "boggle" do
        %w[mkdict mkindex].each do |util|
          cd util do
            system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../boggle", "HOSTCC=#{ENV["HOSTCC"]}"
            bin.install util
          end
        end
        cd "boggle" do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]}", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "boggle"
        end
      end

      # Build Canfield system
      cd "canfield" do
        %w[canfield cfscores].each do |game|
          cd game do
            system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]}", "HOSTCC=#{ENV["HOSTCC"]}"
            bin.install game
          end
        end
      end

      # Build Fortune system
      cd "fortune" do
        cd "strfile" do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]}", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "strfile"
        end
        cd "unstr" do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../strfile", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "unstr"
        end
        cd "fortune" do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../strfile", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "fortune"
        end
      end

      # Build Backgammon system
      cd "backgammon" do
        cd "backgammon" do
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../common_source", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "backgammon"
        end
        cd "teachgammon" do
          # Create minimal data.c if it doesn't exist
          unless File.exist?("data.c")
            File.write("data.c", <<~EOS)
              /* Minimal data.c for teachgammon */
              /* Global variables needed by teachgammon */

              int maxmoves = 0;
              int test[2] = {0, 0};
            EOS
          end
          system "bsdmake", "CFLAGS=#{ENV["CFLAGS"]} -I../common_source", "HOSTCC=#{ENV["HOSTCC"]}"
          bin.install "teachgammon"
        end
      end
    end

    # Install man pages
    cd "openbsd-games" do
      Dir.glob("*/*.6").each do |manpage|
        man6.install manpage
      end
    end

    # Install game data files where needed
    share_dir = share/"bsd-games"
    share_dir.mkpath

    # Install fortune data files
    cd "openbsd-games/fortune" do
      %w[fortunes fortunes.dat].each do |file|
        share_dir.install file if File.exist?(file)
      end
    end

    # Install any other game data
    cd "openbsd-games" do
      %w[atc/games phantasia].each do |data_dir|
        if Dir.exist?(data_dir)
          (share_dir/File.basename(data_dir)).mkpath
          Dir.glob("#{data_dir}/*").each do |file|
            (share_dir/File.basename(data_dir)).install file
          end
        end
      end
    end
  end

  test do
    # Test a few representative games
    assert_match "usage:", shell_output("#{bin}/tetris -h", 1)
    assert_match /robots|usage/, shell_output("#{bin}/robots -h", 1)
    assert_match /fortune|usage/, shell_output("#{bin}/fortune -h", 1)
    
    # Test that binaries are executable
    assert_predicate bin/"tetris", :executable?
    assert_predicate bin/"backgammon", :executable?
    assert_predicate bin/"adventure", :executable?
  end
end
