# First Published Buffer Overflow Exploit for Windows

## Summary

**DilDog (Christien Rioux)** of the **Cult of the Dead Cow (cDc)** published the
first comprehensive buffer overflow exploit targeting Windows in **April 1998**.

The paper, titled **"The Tao of Windows Buffer Overflow"** (cDc t-file #351), was
posted to the Bugtraq security mailing list. It demonstrated a practical buffer
overflow exploit against **Microsoft NetMeeting 2.1** and provided the tools and
concepts needed to exploit buffer overflow vulnerabilities on Windows 95, 98, and NT.

## Historical Context

Prior to DilDog's work, buffer overflow exploitation was primarily documented for
Unix/Linux systems. Aleph One's seminal 1996 paper "Smashing the Stack for Fun and
Profit" (Phrack #49) laid the theoretical groundwork, but it was DilDog who adapted
and demonstrated these techniques for the Windows platform.

## Timeline

| Date | Event |
|------|-------|
| 1988 | Morris Worm uses buffer overflow to propagate (Unix) |
| Nov 1996 | Aleph One publishes "Smashing the Stack for Fun and Profit" (Phrack #49, Unix-focused) |
| Apr 1998 | DilDog publishes "The Tao of Windows Buffer Overflow" (cDc #351) |
| Aug 1998 | Cult of the Dead Cow releases Back Orifice at DEF CON 6 |
| Sep 1999 | Dark Spyrit (Barnaby Jack) publishes "Win32 Buffer Overflows" (Phrack #55) |
| Jun 1999 | eEye discovers IIS 4.0 .HTR buffer overflow (CVE-1999-0874) |
| 2001 | Code Red worm exploits IIS 5.0 buffer overflow |
| 2003 | SQL Slammer and Blaster worm — large-scale Windows buffer overflow worms |
| 2017 | WannaCry leverages EternalBlue (SMB buffer overflow) |

## Key Figures

- **DilDog (Christien Rioux)** — Author of "The Tao of Windows Buffer Overflow" and
  Back Orifice 2000. Member of Cult of the Dead Cow and L0pht Heavy Industries.
- **Aleph One (Elias Levy)** — Author of "Smashing the Stack for Fun and Profit,"
  the foundational buffer overflow exploitation paper (Unix-focused).
- **Dark Spyrit (Barnaby Jack)** — Author of "Win32 Buffer Overflows" in Phrack #55,
  advancing Windows exploitation. Later known for ATM and medical device hacking
  research at eEye Digital Security and IOActive.

## Sources

- [The Tao of Windows Buffer Overflow — Bugtraq (Apr 1998)](https://seclists.org/bugtraq/1998/Apr/100)
- [cDc #351: The Tao of Windows Buffer Overflow](https://www.morehouse.org/hin/cdc/cDc-351.html)
- [Win32 Buffer Overflows — Phrack #55](https://phrack.org/issues/55/15)
- [Cult of the Dead Cow — Wikipedia](https://en.wikipedia.org/wiki/Cult_of_the_Dead_Cow)
- [Buffer Overflow — Wikipedia](https://en.wikipedia.org/wiki/Buffer_overflow)
- [Hacking Like it's 1996 — History of the Stack Buffer Overflow](https://www.bekk.christmas/post/2020/15/hacking-like-it's-1996-a-short-history-of-the-stack-buffer-overflow.)
