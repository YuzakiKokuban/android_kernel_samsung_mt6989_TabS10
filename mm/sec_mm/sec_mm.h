/* SPDX-License-Identifier: GPL-2.0 */
#ifndef _SEC_MM_DEBUG_H
#define _SEC_MM_DEBUG_H

#define GB_TO_PAGES(x) ((x) << (30 - PAGE_SHIFT))
#define MB_TO_PAGES(x) ((x) << (20 - PAGE_SHIFT))
#define K(x) ((x) << (PAGE_SHIFT - 10))

void mm_debug_dump_tasks(void);

void init_lowfile_detect(void);
void exit_lowfile_detect(void);

void init_panic_handler(void);
void exit_panic_handler(void);

void init_sec_mm_tune(void);
void exit_sec_mm_tune(void);

#endif /* _SEC_MM_DEBUG_H */
