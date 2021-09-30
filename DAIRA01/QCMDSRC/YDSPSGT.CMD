/*T: Display description for a Synon/2 surrogate */
/*Z: CRTCMD PGM(YDSPSGTR1C) PRDLIB(DAIRA01)                         */

             CMD        PROMPT('Display description for SGT')

             PARM       KWD(SGT) TYPE(*DEC) LEN(7) MIN(1) +
                          PROMPT('Surrogate number')

             PARM       KWD(MDLLIB) TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL) (*PROTOTYPE) (*CURLIB)) +
                          PROMPT('Model library to search')
