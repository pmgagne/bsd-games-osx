#ifndef PLEDGE_STUB_H
#define PLEDGE_STUB_H

#include <stdlib.h>
#include <errno.h>
#include <stdint.h>
#include <poll.h>
#include <time.h>
#include <signal.h>
#include <sys/time.h>

/* BSD type definitions not available on macOS */
typedef unsigned short u_short;
typedef unsigned int u_int;
typedef unsigned long u_long;
typedef unsigned char u_char;

/* BSD constants not available on macOS */
#ifndef LOGIN_NAME_MAX
#define LOGIN_NAME_MAX 32
#endif

/* Branch prediction hints not available on macOS */
#ifndef __predict_true
#define __predict_true(exp) (exp)
#endif

#ifndef __predict_false
#define __predict_false(exp) (exp)
#endif

/* Stub for OpenBSD pledge() function - not available on macOS */
static inline int pledge(const char *promises, const char *execpromises) {
    (void)promises;
    (void)execpromises;
    return 0;
}

/* Stub for OpenBSD unveil() function - not available on macOS */
static inline int unveil(const char *path, const char *permissions) {
    (void)path;
    (void)permissions;
    return 0;
}

/* Stub for OpenBSD srandom_deterministic() function - use regular srandom on macOS */
static inline void srandom_deterministic(unsigned int seed) {
    srandom(seed);
}

/* Stub for OpenBSD reallocarray() function - use calloc + memcpy on macOS */
static inline void *reallocarray(void *ptr, size_t nmemb, size_t size) {
    if (nmemb == 0 || size == 0) {
        free(ptr);
        return NULL;
    }
    
    // Check for overflow
    if (nmemb > SIZE_MAX / size) {
        errno = ENOMEM;
        return NULL;
    }
    
    return realloc(ptr, nmemb * size);
}

/* Stub for OpenBSD ppoll() function - use regular poll on macOS */
static inline int ppoll(struct pollfd *fds, nfds_t nfds, const struct timespec *timeout, const sigset_t *sigmask) {
    (void)sigmask;  // Ignore signal mask on macOS
    
    int timeout_ms = -1;
    if (timeout) {
        timeout_ms = timeout->tv_sec * 1000 + timeout->tv_nsec / 1000000;
    }
    
    return poll(fds, nfds, timeout_ms);
}

/* BSD timespec manipulation macros not available on macOS */
#ifndef timespecclear
#define timespecclear(tvp) ((tvp)->tv_sec = (tvp)->tv_nsec = 0)
#endif

#ifndef timespecsub
#define timespecsub(vvp, uvp, wvp)                                      \
    do {                                                                \
        (wvp)->tv_sec = (vvp)->tv_sec - (uvp)->tv_sec;                  \
        (wvp)->tv_nsec = (vvp)->tv_nsec - (uvp)->tv_nsec;               \
        if ((wvp)->tv_nsec < 0) {                                       \
            (wvp)->tv_sec--;                                            \
            (wvp)->tv_nsec += 1000000000L;                              \
        }                                                               \
    } while (0)
#endif

#ifndef timespecadd
#define timespecadd(vvp, uvp, wvp)                                      \
    do {                                                                \
        (wvp)->tv_sec = (vvp)->tv_sec + (uvp)->tv_sec;                  \
        (wvp)->tv_nsec = (vvp)->tv_nsec + (uvp)->tv_nsec;               \
        if ((wvp)->tv_nsec >= 1000000000L) {                            \
            (wvp)->tv_sec++;                                            \
            (wvp)->tv_nsec -= 1000000000L;                              \
        }                                                               \
    } while (0)
#endif

#ifndef timespeccmp
#define timespeccmp(tvp, uvp, cmp)                                      \
    (((tvp)->tv_sec == (uvp)->tv_sec) ?                                 \
        ((tvp)->tv_nsec cmp (uvp)->tv_nsec) :                           \
        ((tvp)->tv_sec cmp (uvp)->tv_sec))
#endif

#endif /* PLEDGE_STUB_H */
