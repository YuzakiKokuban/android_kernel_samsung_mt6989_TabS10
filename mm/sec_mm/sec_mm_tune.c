#include <linux/gfp.h>
#include <trace/hooks/iommu.h>
#include "sec_mm.h"

static void sec_mm_adjust_alloc_flags(void *data, unsigned int order,
				      gfp_t *alloc_flags)
{
	if (!order)
		return;
	*alloc_flags &= ~__GFP_RECLAIM;
}

void init_sec_mm_tune(void)
{
	register_trace_android_vh_adjust_alloc_flags(
			sec_mm_adjust_alloc_flags, NULL);
}

void exit_sec_mm_tune(void)
{
	unregister_trace_android_vh_adjust_alloc_flags(
			sec_mm_adjust_alloc_flags, NULL);
}
