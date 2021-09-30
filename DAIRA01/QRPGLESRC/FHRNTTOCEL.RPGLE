     h nomain PGMINFO(*PCML:*MODULE)
     d FhrntToCel      pr
     d tempIn                        10    const
     d tempOut                       10

     p FhrntToCel      b                   export
     d FhrntToCel      pi
     d tempIn                        10    const
     d tempOut                       10

     d tempI           S              8P 2
     d tempO           S              8P 2
     d Value           S             50A

      /free

         value = %str(%addr(tempIn));
         tempI = %dec(value:7:2);
         tempO = (5/9)*(tempI - 32);

         value = %char(tempO);

         tempOut = value;

         %str(%addr(tempOut):10) = tempOut;

       /end-free
     p FhrntToCel      e
