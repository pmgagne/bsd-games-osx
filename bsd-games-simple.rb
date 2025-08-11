class BsdGamesSimple < Formula
  desc "Classic BSD command-line games collection"
  homepage "https://www.openbsd.org/games.html"
  url "https://github.com/openbsd/src/archive/refs/heads/master.tar.gz"
  version "6.9"
  sha256 "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
  license "BSD-3-Clause"

  depends_on "bsdmake" => :build
  depends_on "ncurses"

  def install
    # Extract game sources using sparse checkout approach
    system "git", "init"
    system "git", "remote", "add", "origin", "https://github.com/openbsd/src.git"
    system "git", "config", "core.sparseCheckout", "true"
    
    # Configure sparse checkout for games only
    File.write(".git/info/sparse-checkout", <<~EOF)
      games/*
      !games/phantasia/
      games/phantasia/*
      !games/phantasia/monsters.asc
      !games/phantasia/void.asc
    EOF
    
    system "git", "pull", "origin", "master", "--depth=1"
    
    # Create universal compatibility header
    File.write("pledge_stub.h", <<~EOF)
      #ifndef PLEDGE_STUB_H
      #define PLEDGE_STUB_H
      
      #include <stdlib.h>
      #include <errno.h>
      #include <stdint.h>
      #include <poll.h>
      #include <time.h>
      #include <signal.h>
      #include <sys/time.h>
      
      static inline int pledge(const char *promises, const char *execpromises) { return 0; }
      static inline int unveil(const char *path, const char *permissions) { return 0; }
      static inline void *reallocarray(void *ptr, size_t nmemb, size_t size) {
          if (nmemb != 0 && size > SIZE_MAX / nmemb) { errno = ENOMEM; return NULL; }
          return realloc(ptr, nmemb * size);
      }
      static inline int ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask) {
          int timeout_ms = timeout ? (timeout->tv_sec * 1000 + timeout->tv_nsec / 1000000) : -1;
          return poll(fds, nfds, timeout_ms);
      }
      
      #ifndef TIMESPEC_TO_TIMEVAL
      #define TIMESPEC_TO_TIMEVAL(tv, ts) do { (tv)->tv_sec = (ts)->tv_sec; (tv)->tv_usec = (ts)->tv_nsec / 1000; } while (0)
      #endif
      
      #ifndef __predict_false
      #define __predict_false(x) (x)
      #endif
      #ifndef __predict_true  
      #define __predict_true(x) (x)
      #endif
      
      typedef unsigned int u_int;
      typedef unsigned short u_short;
      typedef unsigned long u_long;
      typedef unsigned char u_char;
      
      #ifdef getdate
      #undef getdate
      #endif
      #define getdate bsd_getdate
      
      #endif /* PLEDGE_STUB_H */
    EOF
    
    # Set up build environment
    ENV["PREFIX"] = prefix
    ENV["BINDIR"] = bin
    ENV["MANDIR"] = man  
    ENV["SHAREDIR"] = share/"bsd-games"
    
    # Make install script executable and run it
    system "chmod", "+x", "install.sh"
    system "./install.sh"
  end

  test do
    # Test a few representative games
    assert_match "usage:", shell_output("#{bin}/fortune --help 2>&1", 1)
    system "#{bin}/number", "42"
    system "#{bin}/caesar", "13", "hello"
    system "#{bin}/random", "100"
  end
end
