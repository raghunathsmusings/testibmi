     h nomain PGMINFO(*PCML:*MODULE)
     d CelToFhrnt      pr
     d tempIn                        10    const
     d tempOut                       10

     p CelToFhrnt      b                   export
     d CelToFhrnt      pi
     d tempIn                        10    const
     d tempOut                       10

     d tempI           S              8P 2
     d tempO           S              8P 2
     d Value           S             50A

      /free

         value = %str(%addr(tempIn));
         tempI = %dec(value:7:2);
         tempO = ((tempI*9)/5) + 32;

         value = %char(tempO);

         tempOut = value;

         %str(%addr(tempOut):10) = tempOut;

      /end-free
     p CelToFhrnt      e
