     D invalidChars1   c                   const('-~$!@%*:/\#;?,.-
     D                                            =^<>|+"(){}[] ')
     D invalidChars2   c                   const('''')
     D i               s             10i 0 inz
     D size            s             10i 0 inz
     D char            s              1    inz
     D input           s             52    inz

      /free

         input = ' 1 Hello_-~$!@%*:/\#;?,.=^<>|+"(){}[] _    World''''';
         input = %trim(input);
         dsply input;

         size = %size(%trim(input));

         i = 1;
         dow (i <= size);
            char = %subst(input:i:1);
            if %scan(%subst(input:i:1):invalidChars1) > 0;
               %subst(input:i:1) = '_';
            elseif %scan(%subst(input:i:1):invalidChars2) > 0;
               %subst(input:i:1) = '_';
            endif;
            i += 1;
         enddo;

         dsply input;

         *inlr = *on;
      /end-free
