     h nomain PGMINFO(*PCML:*MODULE:*DCLCASE)

     D rpgarray        Pr
     D  requestCount...
     D                               10i 0
     D  array_LENGTH                 10i 0
     D  array                        20    DIM(10)

     P rpgarray        B                   EXPORT
     D                 Pi
     D  requestCount...
     D                               10i 0
     D  array_LENGTH                 10i 0
     D  array                        20    DIM(10)

     D i               S             10i 0

      /Free
        if (requestCount < 0 or requestCount > 10);
          requestCount = 0;
        endif;

        array_LENGTH = requestCount;
        clear array;

        for i = 1 to requestCount;
         array(i)          = 'element-' + %CHAR(i);
        endfor;

       return;
      /End-Free
     p rpgarray        e
