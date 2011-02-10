#include <stdint.h>

/* From Wikipedia: http://en.wikipedia.org/wiki/Time_Stamp_Counter#Examples_of_using_it */
inline uint64_t rdtsc() {
	uint32_t lo, hi;
	asm volatile (
#ifdef __i386__
	"push %%ebx\n"
#else
	"push %%rbx\n"
#endif
	"xorl %%eax,%%eax\n"
	"cpuid\n"
#ifdef __i386__
	"pop %%ebx\n"
#else
	"pop %%rbx\n"
#endif
	::: "%rax", "%rcx", "%rdx");
	/* We cannot use "=A", since this would use %rax on x86_64 */
	asm volatile ("rdtsc" : "=a" (lo), "=d" (hi));
	return (uint64_t)hi << 32 | lo;
}
