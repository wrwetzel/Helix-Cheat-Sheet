#!/usr/bin/env python3
# --------------------------------------------------------------------------
"""
booklet_impose.py  4-up cut-stack-fold booklet imposition

Input:  PDF with quarter-letter pages (4.25" x 5.5")
Output: PDF imposed 4-up on 8.5x11, ready for long-edge duplex

Workflow after printing:
  1. Cut all sheets horizontally in one pass
  2. Place bottom stack on top of top stack
  3. Fold left-over-right (spine on left)
  4. Saddle stitch

Requires: pip install pymupdf
      or: pacman -S python-pymupdf

Usage: python booklet_impose.py input.pdf output.pdf

With credit to Claude.
"""
# --------------------------------------------------------------------------

import sys
import math
import fitz         # From pymupdf or python-pymupdf library.

# --------------------------------------------------------------------------

def impose_booklet(input_path: str, output_path: str) -> None:
    src = fitz.open(input_path)
    n = len(src)

    # Pad page count up to the next multiple of 8
    k = math.ceil(n / 8)
    total = 8 * k
    if n < total:
        print(f"Note: {n} pages padded to {total} with {total - n} blank page(s)")

    # Points (72 pt/inch). Quarter-letter slots fit 8.5x11 exactly 2x2.
    PAGE_W  = 8.5 * 72   # 612 pt
    PAGE_H  = 11.0 * 72  # 792 pt
    SLOT_W  = PAGE_W / 2  # 306 pt = 4.25"
    SLOT_H  = PAGE_H / 2  # 396 pt = 5.5"

    # -----------------------------------------------

    def slot_rect(col: int, row: int) -> fitz.Rect:
        """col 0=left 1=right, row 0=top 1=bottom"""
        return fitz.Rect(col * SLOT_W, row * SLOT_H,
                         col * SLOT_W + SLOT_W, row * SLOT_H + SLOT_H)

    # -----------------------------------------------

    def place(out_page, page_num: int, col: int, row: int) -> None:
        """Place 1-indexed source page into slot; 0 or out-of-range → blank."""
        if page_num < 1 or page_num > n:
            return
        out_page.show_pdf_page(slot_rect(col, row), src, page_num - 1)

    # -----------------------------------------------

    out = fitz.open()

    for s in range(1, k + 1):
        # ── Front face ──────────────────────────────────────────────────────
        # TL=top-left, TR=top-right, BL=bottom-left, BR=bottom-right
        # Top half of sheet s  → leaf (s+k) in the folded booklet
        # Bottom half of sheet s → leaf s  (outermost leaves first)

        front = out.new_page(width=PAGE_W, height=PAGE_H)
        place(front, 6*k - 2*s + 2,  0, 0)   # TL  (top half, left slot)
        place(front, 2*(k+s) - 1,    1, 0)   # TR  (top half, right slot)
        place(front, 8*k - 2*s + 2,  0, 1)   # BL  (bottom half, left slot)
        place(front, 2*s - 1,        1, 1)   # BR  (bottom half, right slot)

        # ── Back face ───────────────────────────────────────────────────────
        # Long-edge duplex flips L↔R.  Pre-mirror so physical positions land
        # correctly after the flip:  pdf_TL↔physical_TR, pdf_TR↔physical_TL
        #                            pdf_BL↔physical_BR, pdf_BR↔physical_BL
        #
        # Desired physical back:
        #   phys_TL = 6k-2s+1   phys_TR = 2(k+s)
        #   phys_BL = 8k-2s+1   phys_BR = 2s

        back = out.new_page(width=PAGE_W, height=PAGE_H)
        place(back, 2*(k+s),        0, 0)   # pdf_TL → phys_TR
        place(back, 6*k - 2*s + 1, 1, 0)   # pdf_TR → phys_TL
        place(back, 2*s,            0, 1)   # pdf_BL → phys_BR
        place(back, 8*k - 2*s + 1, 1, 1)   # pdf_BR → phys_BL

    out.save(output_path, garbage=4, deflate=True)
    src.close()
    print(f"Done: {k} sheet(s), {total} page slots → {output_path}")

# --------------------------------------------------------------------------

if __name__ == "__main__":
    if len(sys.argv) != 3:
        sys.exit(f"Usage: {sys.argv[0]} input.pdf output.pdf")

    impose_booklet(sys.argv[1], sys.argv[2])

# --------------------------------------------------------------------------
