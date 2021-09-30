     H NoMain

     T* YPRCRSTDTA - Process Module and generate -propertiesFile info       send to IFS
     X* QCMPSRC,CRTSQLRPGI
     X* QCMPSRC,YPRCREST@C

      * This is called from YRTVRSTLR. For each module being processed, thiss invoked. Upon
      * object looks up what the various REST interface parameters are and  entify specific
      * generates them in the -propertiesFile.

      *COPY QRPGLECPY,YSTRPRC_P                  ‚String processing prototypes
      /IF NOT DEFINED(YSTRPRC_P)
      /DEFINE YSTRPRC_P
      *
     D*COPY QRPGLECPY,QUSEC                      ‚Common Structure for Error Code Parameter
      *
     M*=====================================================================
     M* 05Apr07 HEWRO01 M10977 *NONE    File created.
     M* 21Jun07 HEWRO01 M10983 *NONE    Add strList() and strUpper().
     M* 06Sep07 HEWRO01 M10994 *NONE    Add strCvtqName().
     M* 15Nov07 HEWRO01 M10998 *NONE    Add strFmtScrMsg().
     M* 27Dec07 HEWRO01 M11002 *NONE    Add strOverlay().
     M* 31Oct08 HEWRO01 M11029 *NONE    Add strIsVNM().
     M*=====================================================================
      *
      *‚String processing procedures
      *
     D strParse        pr         32767a   varying extproc('strParse')
     D  string@                        *   const options(*string)
     D  parm1@                         *   const options(*string:*nopass)
     D  parm2@                         *   const options(*string:*nopass)
     D  parm3@                         *   const options(*string:*nopass)
     D  parm4@                         *   const options(*string:*nopass)
     D  parm5@                         *   const options(*string:*nopass)
     D  parm6@                         *   const options(*string:*nopass)
     D  parm7@                         *   const options(*string:*nopass)
     D  parm8@                         *   const options(*string:*nopass)
     D  parm9@                         *   const options(*string:*nopass)
      *
     D strEdit         PR         32767A   Extproc('strEdit')
     D  String@                        *   Const Options(*String)
     D  EdtWrd@                        *   Const Options(*String)
      *
     D strDblQte       PR         32767A   Varying Extproc('strDblQte')
     D   String                   32767A   Const Varying
      *
     D strCenter       PR         32767A   Extproc('strCenter')
     D   String@                       *   Const Options(*String)
     D   FieldLen                    10I 0 Const
      *
     D strRepeat       PR         32767A   Varying Extproc('strRepeat')
     D   Char                        10A   Const Varying
     D   Repeat                      10I 0 Const
      *
     D strScan         PR            10I 0 Extproc('strScan')
     D   Base                      1024A   Const
     D   Scan                      1024A   Const
     D   IgnCase                      1A   Const Options(*Nopass)
      *
     D strGetWord      PR          1024A   Varying Extproc('strGetWord')
     D   String                   65535A   Const Varying Options(*Varsize)
     D   Pos                         10I 0
     D   Delim                       10A   Const Options(*Nopass)
      *
     D strGeneric      PR              N   Extproc('strGeneric')
     D   String1                   1024A   Const
     D   String2                   1024A   Const
     D   AllowBlanks                   N   Value Options(*Nopass)
      *
     D strList         PR          1024A   Varying Extproc('strList')
     D   String@                       *   Const Options(*String)
     D   ElmLen                      10I 0 Const
     D   Delim                       10A   Const Options(*Nopass) Varying
      *
     D strUpper        PR          1024A   Varying Extproc('strUpper')
     D   String                    1024A   Const Varying
     D   CCSID                       10I 0 Const
     D   ApiError                                Like(QUSEC) Options(*Nopass)
      *
     D strCvtqName     PR            20A   Extproc('strCvtqName')
     D   String                      21A   Const
      *
     D strFmtScrMsg    PR            78A   Extproc('strFmtScrMsg')
     D   MsgID                        7A   Const
     D   OutLen                      10I 0 Const
     D   qMsgf                       20A   Const Options(*Nopass)
      *
     D strOverlay      PR          1024A   Extproc('strOverlay')
     D   Base@                         *   Const Options(*String)
     D   Over@                         *   Const Options(*String)
     D   Blank                        1A   Const Options(*Nopass)
      *
     D strIsVNM        PR            10I 0 Extproc('strIsVNM')
     D   Name                        10A   Const
     D   AllowGeneric                  N   Const Options(*Nopass)
      *
     D ALLOW_GENERIC_NAME...
     D                 C                   '1'
      *
      *‚String constants file procedures
      *
     D strGetStrCon    PR          1024A   Extproc('strGetStrCon')
     D  StringID                      7P 0 Const
      *
     D strOpnStrConFile...
     D                 PR            10I 0 Extproc('strOpnStrConFile')
     D   Library                     10A   Const Options(*Nopass)
     D   Member                      10A   Const Options(*Nopass)
      *
     D strCloseStrConFile...
     D                 PR            10I 0 Extproc('strCloseStrConFile')
      *
      /ENDIF
      *COPY QRPGLECPY,IFS_P                      ‚IFS definitions
      /IF NOT DEFINED(IFS_P)
      /DEFINE IFS_P
      *
     D*COPY QRPGLECPY,##TYPES
     D*COPY QRPGLECPY,RC
     D*COPY QRPGLECPY,ERRNO
      *
     D access          PR            10I 0 extproc('access')
     D   path                          *   value options(*string)
     D   access_mode                 10I 0 value
      *
     D open            PR            10I 0 extproc('open')
     D   path                          *   value options(*string)
     D   oflag                       10I 0 value
     D   mode                        10U 0 value options(*nopass)
     D   code_page                   10U 0 value options(*nopass)
      *
     D read            PR            10I 0 extproc('read')
     D   file_handle                 10I 0 value
     D   inp_buf                       *   value
     D   bytes_read                  10U 0 value
      *
     D write           PR            10I 0 extproc('write')
     D   file_handle                 10I 0 value
     D   out_buf                       *   value
     D   bytes_write                 10U 0 value
      *
     D close           PR            10I 0 extproc('close')
     D   file_handle                 10I 0 value
      *
     D remove          PR            10I 0 extproc('_C_IFS_remove')
     D   path                          *   value options(*string)
      *
     D stat            PR            10I 0 extproc('stat')
     D   path                          *   value options(*string)
     D   p_stat_str                        like(stat_str)
      *
     D*stat64          PR            10I 0 extproc('stat64')
     D*  path                          *   value options(*string)
     D*  p_stat64_str                      like(stat64_str)
      *
     D mkdir           PR            10I 0 extproc('mkdir')
     D   path                          *   value options(*string)
     D   mode                              value like(unsigned_int_t)
      *
     D opendir         PR              *   extproc('opendir')
     D  dirname                        *   value options(*string)
      *
     D closedir        PR            10I 0 extproc('closedir')
     D  dirhandle                      *   value
      *
     D readdir         PR              *   extproc('readdir')
     D  dirp                           *   value
      *
     D chmod           PR            10I 0 extproc('chmod')
     D   file_name                     *   value options(*string)
     D   mode                              value like(unsigned_int_t)
      *
     D chown           PR            10I 0 extproc('chown')
     D   file_name                     *   value options(*string)
     D   uid                               value like(unsigned_int_t)
     D   gid                               value like(unsigned_int_t)
      *
     D link            PR            10I 0 extproc('link')
     D   exist_name                    *   value options(*string)
     D   new_name                      *   value options(*string)
      *
     D unlink          PR            10I 0 extproc('unlink')
     D   link_name                     *   value options(*string)
      *
     D symlink         PR            10I 0 extproc('symlink')
     D   exist_name                    *   value options(*string)
     D   new_name                      *   value options(*string)
      *
     D readlink        PR            10I 0 extproc('readlink')
     D   link_name                     *   value options(*string)
     D   buf@                          *   value
     D   buf_size                    10I 0 value
      *
     D tmpnam          PR              *   extproc('_C_IFS_tmpnam')
     D   string                      39A   options(*omit)
      *
     D lseek           PR            10I 0 extproc('lseek')
     D   file_handle                 10I 0 value
     D   offset                      10I 0 value
     D   whence                      10I 0 value
      *
      *=====================================================================
      *
     D fd              S             10I 0
     D oflag           S             10I 0
     D mode            S             10U 0
     D crlf            C                   x'0D25'
     D cr              C                   x'0D'
     D lf              C                   x'25'
      *
      * 'access_mode' values for access()
     D F_OK            S             10I 0 INZ(0)
     D R_OK            S             10I 0 INZ(4)
     D W_OK            S             10I 0 INZ(2)
     D X_OK            S             10I 0 INZ(1)
      *
      * 'mode' values for open()
     D O_RDONLY        S             10I 0 INZ(1)
     D O_WRONLY        S             10I 0 INZ(2)
     D O_RDWR          S             10I 0 INZ(4)

      * 'oflag' values for open()
     D O_CREAT         S             10I 0 INZ(8)
     D O_EXCL          S             10I 0 INZ(16)
     D O_TRUNC         S             10I 0 INZ(64)

      * File Status Flags for open() and fcntl()
     D O_NONBLOCK      S             10I 0 INZ(128)
     D O_APPEND        S             10I 0 INZ(256)

      * oflag Share Mode Values for open()
     D O_SHARE_NONE    S             10I 0 INZ(2000000)
     D O_SHARE_RDONLY  S             10I 0 INZ(0200000)
     D O_SHARE_RDWR    S             10I 0 INZ(1000000)
     D O_SHARE_WRONLY  S             10I 0 INZ(0400000)

      * file permissions
     D S_IRUSR         S             10I 0 INZ(256)
     D S_IWUSR         S             10I 0 INZ(128)
     D S_IXUSR         S             10I 0 INZ(64)
     D S_IRWXU         S             10I 0 INZ(448)
     D S_IRGRP         S             10I 0 INZ(32)
     D S_IWGRP         S             10I 0 INZ(16)
     D S_IXGRP         S             10I 0 INZ(8)
     D S_IRWXG         S             10I 0 INZ(56)
     D S_IROTH         S             10I 0 INZ(4)
     D S_IWOTH         S             10I 0 INZ(2)
     D S_IXOTH         S             10I 0 INZ(1)
     D S_IRWXO         S             10I 0 INZ(7)

      * misc
     D O_TEXTDATA      S             10I 0 INZ(16777216)
     D O_CCSID         S             10I 0 INZ(32)
     D O_CODEPAGE      S             10I 0 INZ(8388608)
     D ASCII_CODEPAGE  S             10U 0 INZ(819)
      *
     D stat_str        DS                  qualified align
     D  mode                               like(unsigned_int_t)
     D  ino                                like(unsigned_int_t)
     D  nlink                              like(unsigned_short_t)
     D  uid                                like(unsigned_int_t)
     D  gid                                like(unsigned_int_t)
     D  size                               like(unsigned_int_t)
     D  atime                              like(int_t)
     D  mtime                              like(int_t)
     D  ctime                              like(int_t)
     D  dev                                like(unsigned_int_t)
     D  blksize                            like(unsigned_int_t)
     D  allocsize                          like(unsigned_int_t)
     D  objtype                            like(qp01_objtype_t)
     D   objtype10                   10A   overlay(objtype)
     D  codepage                           like(unsigned_short_t)
     D                               62A
     D  ino_gen_id                         like(unsigned_int_t)
      *
     D  stat_str_len   S             10I 0 inz(%len(stat_str))

     D dirent_t        ds                  qualified based(TEMPLATE)
     D   reserved1                   16A
     D   fileno_gen_id...
     D                               10U 0
     D   fileno                      10U 0
     D   reclen                      10U 0
     D   reserved3                   10I 0
     D   reserved4                    8A
     D   nlsinfo                     12A
     D     nls_ccsid                 10I 0 OVERLAY(nlsinfo:1)
     D     nls_cntry                  2A   OVERLAY(nlsinfo:5)
     D     nls_lang                   3A   OVERLAY(nlsinfo:7)
     D     nls_reserv                 3A   OVERLAY(nlsinfo:10)
     D   namelen                     10U 0
     D   name                       640A
      *
     D STDIN           C                   0
     D STDOUT          C                   1
     D STDERR          C                   2
      *
      * 'whence' values for lseek()
     D SEEK_SET        S             10I 0 INZ(0)
     D SEEK_CUR        S             10I 0 INZ(1)
     D SEEK_END        S             10I 0 INZ(2)
      *
      /ENDIF
      *COPY QRPGLECPY,BSEARCH_P                  ‚bsearch() and qsort() definitions
      /IF NOT DEFINED(BSEARCH_P)
      /DEFINE BSEARCH_P
      *
     D bsearch         PR              *   ExtProc('bsearch')
     D   LookFor@                      *   Value
     D   DataStart@                    *   Value
     D   ElementNum                  10U 0 Value
     D   ElementSize                 10U 0 Value
     D   CompareFunc                   *   Value ProcPtr
      *
     D qsort           PR                  Extproc('qsort')
     D   DataStart@                    *   Value
     D   ElementNum                  10U 0 Value
     D   ElementSize                 10U 0 Value
     D   CompareFunc                   *   Value Procptr
      *
      /ENDIF
      *COPY QRPGLECPY,SNDPGMMSG                  ‚SndPgmMsg()
      /IF NOT DEFINED(SNDPGMMSG)
      /DEFINE SNDPGMMSG

      *COPY QRPGLECPY,QUSEC_T

      *‚SndPgmMsg() procedure prototype

     D SndPgmMsg       PR            10I 0
     D   MsgID                        7A   Const
     D   MsgDta                     512A   Const Varying
     D   MsgType                     10A   Const
     D   qMsgf                       20A   Const Options(*Nopass)

       /SET CCSID(*CHAR:*JOBRUNMIX)
       // SQL COMMUNICATION AREA                                                //SQL
       DCL-DS SQLCA;                                                            //SQL
         SQLCAID CHAR(8) INZ(X'0000000000000000');                              //SQL
          SQLAID CHAR(8) OVERLAY(SQLCAID);                                      //SQL
         SQLCABC INT(10);                                                       //SQL
          SQLABC BINDEC(9) OVERLAY(SQLCABC);                                    //SQL
         SQLCODE INT(10);                                                       //SQL
          SQLCOD BINDEC(9) OVERLAY(SQLCODE);                                    //SQL
         SQLERRML INT(5);                                                       //SQL
          SQLERL BINDEC(4) OVERLAY(SQLERRML);                                   //SQL
         SQLERRMC CHAR(70);                                                     //SQL
          SQLERM CHAR(70) OVERLAY(SQLERRMC);                                    //SQL
         SQLERRP CHAR(8);                                                       //SQL
          SQLERP CHAR(8) OVERLAY(SQLERRP);                                      //SQL
         SQLERR CHAR(24);                                                       //SQL
          SQLER1 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLER2 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLER3 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLER4 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLER5 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLER6 BINDEC(9) OVERLAY(SQLERR:*NEXT);                               //SQL
          SQLERRD INT(10) DIM(6) OVERLAY(SQLERR);                               //SQL
         SQLWRN CHAR(11);                                                       //SQL
          SQLWN0 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN1 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN2 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN3 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN4 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN5 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN6 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN7 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN8 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWN9 CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWNA CHAR(1) OVERLAY(SQLWRN:*NEXT);                                 //SQL
          SQLWARN CHAR(1) DIM(11) OVERLAY(SQLWRN);                              //SQL
         SQLSTATE CHAR(5);                                                      //SQL
          SQLSTT CHAR(5) OVERLAY(SQLSTATE);                                     //SQL
       END-DS SQLCA;                                                            //SQL
       DCL-PR SQLROUTE_CALL EXTPGM(SQLROUTE);                                   //SQL
         CA LIKEDS(SQLCA);                                                      //SQL
         *N BINDEC(4) OPTIONS(*NOPASS);                                         //SQL
         *N CHAR(1) OPTIONS(*NOPASS);                                           //SQL
       END-PR SQLROUTE_CALL;                                                    //SQL
       DCL-PR SQLOPEN_CALL EXTPGM(SQLOPEN);                                     //SQL
         CA LIKEDS(SQLCA);                                                      //SQL
         *N BINDEC(4);                                                          //SQL
       END-PR SQLOPEN_CALL;                                                     //SQL
       DCL-PR SQLCLSE_CALL EXTPGM(SQLCLSE);                                     //SQL
         CA LIKEDS(SQLCA);                                                      //SQL
         *N BINDEC(4);                                                          //SQL
       END-PR SQLCLSE_CALL;                                                     //SQL
       DCL-PR SQLCMIT_CALL EXTPGM(SQLCMIT);                                     //SQL
         CA LIKEDS(SQLCA);                                                      //SQL
         *N BINDEC(4);                                                          //SQL
       END-PR SQLCMIT_CALL;                                                     //SQL
       /RESTORE CCSID(*CHAR)
       DCL-C SQLROUTE CONST('QSYS/QSQROUTE');                                   //SQL
       DCL-C SQLOPEN CONST('QSYS/QSQROUTE');                                    //SQL
       DCL-C SQLCLSE CONST('QSYS/QSQLCLSE');                                    //SQL
       DCL-C SQLCMIT CONST('QSYS/QSQLCMIT');                                    //SQL
       DCL-C SQFRD CONST(2);                                                    //SQL
       DCL-C SQFCRT CONST(8);                                                   //SQL
       DCL-C SQFOVR CONST(16);                                                  //SQL
       DCL-C SQFAPP CONST(32);                                                  //SQL
      /ELSE

      *=====================================================================
      *‚SndPgmMsg(): Send a message
      *=====================================================================
     P SndPgmMsg       B
     D                 PI            10I 0
     D   P_MsgID                      7A   Const
     D   P_MsgDta                   512A   Const Varying
     D   MsgType                     10A   Const
     D   P_qMsgf                     20A   Const Options(*Nopass)
      *---------------------------------------------------------------------
      *
     D qusec           DS                  likeds(qusec_t) Inz(*Likeds)
      *
     D qmhsndpm        PR                  Extpgm('QMHSNDPM')
     D   Msgid                        7A   Const
     D   qMsgf                       20A   Const
     D   MsgDta                   32767A   Const Options(*Varsize)
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStackEntry...
     D                             4096A   Const
     D   CallStackCount...
     D                               10I 0 Const
     D   MsgKey                       4A
     D   ApiError                          Like(QUSEC)
     D   CallStackEntryLen...
     D                               10I 0 Const Options(*Nopass)
     D   CallStackEntryQualification...
     D                               20A   Const Options(*Nopass)
     D   DspPgmMsgScreenWaitTime...
     D                               10I 0 Const Options(*Nopass)
     D   CallStackEntryDataType...
     D                               10A   Const Options(*Nopass)
     D   CCSID                       10I 0 Const Options(*Nopass)
      *
     D qMsgf           DS
     D   Msgf                        10A   Inz('QCPFMSG')
     D   MsgfLib                     10A   Inz('*LIBL')
     D CSE             S             10A   Inz
     D CSC             S             10I 0 Inz
     D MsgID           S              7A   Inz
     D MsgKey          S              4A   Inz
     D MsgDta          S            512A   Inz
      *
      *---------------------------------------------------------------------
      /free

        MsgID = P_MsgID;
        MsgDta = P_MsgDta;
        if %parms > 3;
          qMsgf = P_qMsgf;
          if MsgfLib = *blanks;
            MsgfLib = '*LIBL';
          endif;
        endif;

        select;
          when MsgType = '*DIAG';
            CSE = '*';
            CSC = 2;
          when MsgType = '*RQS';
            CSE = '*EXT';
            CSC = 0;
          when MsgType = '*STS';
            if MsgID = *blanks;
              MsgID = 'CPF9897';
            endif;
            CSE = '*EXT';
            CSC = 0;
          other;
            CSE = '*';
            CSC = 3;
        endsl;

        reset QUSEC;
        qmhsndpm( MsgID : qMsgf : MsgDta : %len( MsgDta ) :
                  MsgType : CSE : CSC : MsgKey : QUSEC );

        return 0;

        begsr *pssr;
          return -1;
        endsr;

      /end-free
     P                 E
      *=====================================================================

      /ENDIF
      /DEFINE PARDTLS_IMPORT
      *COPY QRPGLECPY,YRESTCPYBK                 ‚PCML processing related Arrays
      /IF NOT DEFINED(YRESTCPYBK)
      /DEFINE YRESTCPYBK

     M*=====================================================================
     M* 18Sep17 DAIRA01 M28509  Copybook created.
     M*=====================================================================

     D RcdData_t       s           1024A   based(Template@)
     D Idx_t           s             10I 0 based(Template@)

     D CmtData         s                   inz like(RcdData_t)
     D GblName         s            100A   inz varying
     D RESTStmf_t      s            150A   inz

     D Template@       s               *

      *‚SQL constants
     D SqlSttNoRow     s              5A   inz( '02000' )
     D SqlSttMoreFlds  s              5A   inz( '01557' )

      *‚Structure for retrieving the YMSGPARRFP record
     D MsgParExtDs_t e ds                  extname(YMSGPARRFP) qualified
     D                                     based(Template@)

      *‚Structure for retrieving the YMSGPDTRFP record
     D MsgPdtExtDs_t e ds                  extname(YMSGPDTRFP) qualified
     D                                     based(Template@)

      *‚Structure for retrieving the YMDLOBJRFP record
     D MdlObjExtDs_t e ds                  extname(YMDLOBJRFP) qualified
     D                                     based(Template@)

      *‚One instance of WrkParDs takes up 59 bytes.
     D WrkParDs_t      ds                  qualified
     D                                     based(Template@)
     D  FunImpNme                          like(MdlObjExtDs_t.IMPNME)
     D  ParSgt                             like(MsgParExtDs_t.@@PAR)
     D  AcpSgt                             like(MsgParExtDs_t.@@ACP)
     D  ParFmt                             like(MsgParExtDs_t.PARFMT)
     D  PListName                     6A

      *‚One instance of WrkPdtDs takes up 48 bytes.
     D WrkPdtDs_t      ds                  qualified
     D                                     based(Template@)
     D  ParSgt                             like(MsgPdtExtDs_t.@@PAR)
     D  FldSgt                             like(MsgPdtExtDs_t.@@FLD)
     D  FldUsg                             like(MsgPdtExtDs_t.PARUSG)
     D  ImpNme                             like(MdlObjExtDs_t.IMPNME)

      *‚Single instance to capture MSGPAR related usage details              DS field
     D WrkParUsgDs_t   ds                  qualified
     D                                     based(Template@)
     D  ParSgt                             like(MsgPdtExtDs_t.@@PAR)
     D  ParUsg                             like(MsgPdtExtDs_t.PARUSG)

      *‚One instance of WrkParDs takes up 59 bytes. By this, in a 65535 size DS field
      *‚1110 instances. However, in CA 2E the maximum number of parameters that a module
      *‚can contain are 9. Therefore the number of MsgParDs instances is set to 9.
     D MaxParElems     c                   const(9)

      *‚One instance of WrkPdtDs takes up 48 bytes. By this, in a 65535 size DS field
      *‚1365 instances. For convenience sake, the number of MsgPdtDs instances is set to 1000.
      *‚Upon verification in Crispin's model, there were no modules having more than 550 rcds
      *‚in the YMSGPDTRFP file.
     D MaxPdtElems     c                   const(1000)

      *‚Global Variables for processing within the program
      /IF DEFINED(PARDTLS_EXPORT)
     D rtn             s             10I 0 inz             export('RTN')
     D MsgParElems     s                   inz like(Idx_t) export('MSGPARELEMS')
     D MsgPdtElems     s                   inz like(Idx_t) export('MSGPDTELEMS')
     D MsgParDs        ds                  dim(MaxParElems) likeds(WrkParDs_t)
     D                                                      export('MSGPARDS')
     D MsgPdtDs        ds                  dim(MaxPdtElems) likeds(WrkPdtDs_t)
     D                                                      export('MSGPDTDS')
     D MsgParUsgDs     ds                  dim(MaxParElems)
     D                                                   likeds(WrkParUsgDs_t)
     D                                                   export('MSGPARUSGDS')
      /ELSEIF DEFINED(PARDTLS_IMPORT)
     D rtn             s             10I 0                import('RTN')
     D MsgParElems     s                   like(Idx_t)    import('MSGPARELEMS')
     D MsgPdtElems     s                   like(Idx_t)    import('MSGPDTELEMS')
     D MsgParDs        ds                  dim(MaxParElems) likeds(WrkParDs_t)
     D                                                      import('MSGPARDS')
     D MsgPdtDs        ds                  dim(MaxPdtElems) likeds(WrkPdtDs_t)
     D                                                      import('MSGPDTDS')
     D MsgParUsgDs     ds                  dim(MaxParElems)
     D                                                   likeds(WrkParUsgDs_t)
     D                                                   import('MSGPARUSGDS')
      /ENDIF

      /ENDIF
    2 *COPY QRPGLECPY,#CONSTANTS
      /IF NOT DEFINED(#CONSTANTS)
      /DEFINE #CONSTANTS
     M*=============================================================================================
     M* 22Nov10 HEWRO01 Y1SRC  *NONE    Add definitions.
     M*=============================================================================================
      *
      *‚Digits (1 - 9) only
     D DIGITS          C                   '0123456789'
      *‚Digits plus blank
     D DIGITS_B        C                   '0123456789 '
      *‚Integers plus sign-characters
     D INTEGERS        C                   '0123456789+-'
      *‚Numeric characters
     D NUMERICS        C                   '0123456789.,+-'
      *‚Numeric characters plus blank
     D NUMERICS_B      C                   '0123456789.,+- '
      *‚All characters valid in an expression
     D EXPRESSION      C                   '0123456789.,+-/*()%= '
      *‚All characters valid in an expression including the ampersand
     D EXPRESSION_AMP  C                   '0123456789.,+-/*()%=& '
      *‚All characters valid in a hexadecimal value
     D HEXCHARS        C                   '0123456789ABCDEF'
      *‚Invariant characters
     D INVARCHARS      C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678-
     D                                     9+<=>%&*"''(),_-./:;?'
      *‚Miscellaneous constants
     D LOWER           C                   'abcdefghijklmnopqrstuvwxyz'
     D UPPER           C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D QUOTE           C                   ''''
     D SGLQTE          C                   ''''
     D DBLQTE          C                   '"'
     D AMP             C                   '&'
     D AMPERSAND       C                   '&'
     D AMP2            C                   '&&'
     D AMPERSAND2      C                   '&&'
     D AST             C                   '*'
     D ASTERISK        C                   '*'
     D AST2            C                   '**'
     D ASTERISK2       C                   '**'
     D UND             C                   '_'
     D UNDERLINE       C                   '_'
     D UND2            C                   '__'
     D UNDERLINE2      C                   '__'
     D COLON           C                   ':'
     D SEMICOLON       C                   ';'
     D EQUAL           C                   '='
     D PLUS            C                   '+'
     D MINUS           C                   '-'
     D PERCENT         C                   '%'
     D NULL            C                   x'00'
     D BLANK           C                   ' '
     D SLASH           C                   '/'
     D SI              C                   x'0F'
     D SO              C                   x'0E'
     D SHIFTIN         C                   x'0F'
     D SHIFTOUT        C                   x'0E'
     D QMARK           C                   '?'
     D LPAR            C                   '('
     D RPAR            C                   ')'
     D PERIOD          C                   '.'
     D COMMA           C                   ','
     D YES             C                   '*YES'
     D NO              C                   '*NO'
     D ALL             C                   '*ALL'
     D LIBL            C                   '*LIBL'
     D CURLIB          C                   '*CURLIB'
     D FIRST           C                   '*FIRST'
     D LAST            C                   '*LAST'
     D NONE            C                   '*NONE'
     D NEXT            C                   '*NEXT'
     D PREVIOUS        C                   '*PREVIOUS'
     D PRV             C                   '*PRV'
     D ETC             C                   '...'
     D GT              C                   '>'
     D LT              C                   '<'
     D EQL             C                   '='
     D GTE             C                   '>='
     D LTE             C                   '<='
     D NEQ             C                   '<>'
     D NOTEQUAL        C                   '<>'
     D BLANKVAL        C                   '*BLANK'
     D BLANKSVAL       C                   '*BLANKS'
     D COMMABLANK      C                   ', '
     D SAME            C                   '*SAME'
     D QQCPFMSG        C                   'QCPFMSG   *LIBL     '
     D QCPFMSG         C                   'QCPFMSG   *LIBL     '
     D NULLPOINTER@    S               *   INZ
     D NULLSTRING      C                   ''
     D qObj_t          DS                  Qualified Based(TEMPLATE)
     D   Obj                         10A
     D   Lib                         10A
     D qJob_t          DS                  Qualified Based(TEMPLATE)
     D   Name                        10A
     D   User                        10A
     D   Number                       6A
     D     Number_S                   6S 0 Overlay(Number)
     D qObjString_t    S             21A   Based(TEMPLATE)
     D qJobString_t    S             28A   Based(TEMPLATE)
      *
      /ENDIF
      *COPY QRPGLECPY,YGNRPRC2_P                                            rays
      /IF NOT DEFINED(YGNRPRC2_P)
      /DEFINE YGNRPRC2_P
      *
     D*COPY QRPGLECPY,QUSEC
     D*COPY QRPGLECPY,RC
     D*COPY QRPGLECPY,YALLOC_P
     D*COPY QRPGLECPY,YOBJPRC_P
     D*COPY QRPGLECPY,YDTAARA_P
     D*COPY QRPGLECPY,YPRCRTN_P
     D*COPY QRPGLECPY,YJOBPRC_P
      *
      /ENDIF

     D prcRESTData     pr            10I 0 extproc('prcRESTData')
     D  p_ModName                          like(MdlObjExtDs_t.IMPNME)
     D                                     const
     D  p_@@WEBSRV                    7P 0 const
     D  p_@@SRVPGM                    7P 0 const
     D  p_ServiceTyp                  8A   const

     D fmtRESTData     pr            10I 0 extproc('fmtRESTData')
     D   pRcdDataTyp                 11A   const
     D   pRcdData                          like(RcdData_t)
     D                                     const options(*nopass)

     D rtvDesiredNameUsg...
     D                 pr            10I 0 extproc('rtvDesiredNameUsg')
     D  P_AttrValue                  15A   const varying options(*nopass)
     D  P_ParSgt                      7P 0               options(*nopass)
     D  P_2EName                     40A         varying options(*nopass)
     D  P_2EUsage                    11A         varying options(*nopass)

     D rtvParName      pr            10I 0 extproc('rtvParName')
     D  P_ParDtl                      4    const
     D  P_ParFmt                           const like(MsgParExtDs_t.ParFmt)
     D  P_ObjSgt                           const like(MsgParExtDs_t.@@MSG)
     D  P_DesiredName                            like(GblName)

     D rtvFldName      pr            10I 0 extproc('rtvFldName')
     D  P_ObjSgt                           const like(MsgParExtDs_t.@@MSG)
     D  P_ImpNme                                 like(MdlObjExtDs_t.IMPNME)
     D  P_DesiredName                            like(GblName)

     D CmpbyParName    pr            10I 0 extproc('CmpbyParName')
     D   element_1                         likeds(WrkParDs_t)
     D   element_2                         likeds(WrkParDs_t)

     D ParKey          ds                  likeds(WrkParDs_t)
     D StrLen          s              5I 0 inz

      *‚--------------------------------------------------------------------------------------------
     P prcRESTData     B                   export
     D prcRESTData     pi            10I 0
     D  p_ModName                          like(MdlObjExtDs_t.IMPNME)
     D                                     const
     D  p_@@WEBSRV                    7P 0 const
     D  p_@@SRVPGM                    7P 0 const
     D  p_ServiceTyp                  8A   const

     D WrkObjDtlDs     ds                  qualified
     D WrkSgt                              like(MdlObjExtDs_t.@@OBJ)
     D WrkMdlNme                           like(MdlObjExtDs_t.OBJNME)

     D WrkPrcRMIDtls E ds                  qualified ExtName(YPRCRMIRFP)

     D index           s              5i 0 inz
     D parindex        s              5i 0 inz
     D httpVerb        s              6a   inz varying
     D WrkParName      s                   inz like(GblName)
     D method_uri      s             25a   inz varying
     D httpVerbPos     s              5i 0 inz

     D WrkData         s                   inz like(RcdData_t)
     D MaxRtnElms      s              5i 0 inz(9)

     D QDtaAra         ds                  inz likeds(qObj_t)
     D PListParDs      ds                  dim(MaxParElems) qualified
     D  w_@@Par                            like(MsgParExtDs_t.@@Par)
     D  w_@@Acp                            like(MsgParExtDs_t.@@Acp)
     D  w_ParFmt                           like(MsgParExtDs_t.ParFmt)

     D CharsFrom       s             28A   inz(' ')
     D CharsTo         s             28A   inz('                            ')
     D SingleQuote     s              1A   inz('''')
     D DoubleQuote     s              1A   inz('"')
     D lowerCase       c                   'abcdefghijklmnopqrstuvwxyz'
     D upperCase       c                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

     D YPARDTL         s              4A   inz
     D YRSTINP         s             13A   inz
     D YRSTOUT         s             13A   inz
     D YWRPINP         s              5A   inz
     D YWRPOUT         s              5A   inz

     D content_out     s             32a   inz
     D content_type    s             32a   inz

     D WrkURIPATH      s                   inz like(WrkPrcRMIDTLS.URIPATH)
     D WrkWRPINP       s                   inz like(WrkPrcRMIDTLS.WRPINP)
     D WrkWRPOUT       s                   inz like(WrkPrcRMIDTLS.WRPOUT)
     D WrkREQMETHOD    s                   inz like(WrkPrcRMIDTLS.REQMETHOD)
     D WrkCONSUMES     s                   inz like(WrkPrcRMIDTLS.CONSUMES)
     D WrkPRODUCES     s                   inz like(WrkPrcRMIDTLS.PRODUCES)
      /free

     D                 DS                  STATIC                               OPEN
     D  SQL_00000              1      2B 0 INZ(128)                             length of header
     D  SQL_00001              3      4B 0 INZ(2)                               statement number
     D  SQL_00002              5      8U 0 INZ(0)                               invocation mark
     D  SQL_00003              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay
     D  SQL_00004             10    128A   CCSID(*JOBRUNMIX)                    end of header
     D  SQL_00005            129    128A   CCSID(*HEX)                          WRKSGT
     D                 DS                  STATIC                               CLOSE
     D  SQL_00006              1      2B 0 INZ(128)                             length of header
     D  SQL_00007              3      4B 0 INZ(4)                               statement number
     D  SQL_00008              5      8U 0 INZ(0)                               invocation mark
     D  SQL_00009              9      9A   INZ('0') CCSID(*JOBRUNMIX)           data is okay
     D  SQL_00010             10    127A   CCSID(*JOBRUNMIX)                    end of header
     D  SQL_00011            128    128A   CCSID(*JOBRUNMIX)                    end of header
        exsr  zzinit;

        //‚Open cursor
       //* exec sql
       //*    open PLISTPARCSR;
          SQL_00005 = WRKSGT;                                                   //SQL
          SQLER6 = -4;                                                          //SQL
          IF SQL_00002 = 0                                                      //SQL
          OR SQL_00003 <> *LOVAL;                                               //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
             : SQL_00000                                                        //SQL
          );                                                                    //SQL
          ELSE;                                                                 //SQL
          SQLOPEN_CALL(                                                         //SQL
               SQLCA                                                            //SQL
             : SQL_00000                                                        //SQL
          );                                                                    //SQL
          ENDIF;                                                                //SQL

        clear PListParDs;
        //‚Processing for the PListParCsr data sturcture
        dou SQLSTT >= SqlSttNoRow;

           //‚Fetch data
       //*    exec sql
       //*       fetch next from PListParCsr
       //*             for :MaxRtnElms  rows
       //*             into :PListParDs;
          SQLER6 = 3;                                                           //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
              if SQLSTT = SqlSttNoRow;
                 iter;
              endif;

        enddo;

        //‚Close cursor
       //* exec sql
       //*    close  PLISTPARCSR;
          SQLER6 = 4;                                                           //SQL
          IF SQL_00008 = 0;                                                     //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
             : SQL_00006                                                        //SQL
          );                                                                    //SQL
          ELSE;                                                                 //SQL
          SQLCLSE_CALL(                                                         //SQL
               SQLCA                                                            //SQL
             : SQL_00006                                                        //SQL
          );                                                                    //SQL
          ENDIF;                                                                //SQL

        clear WrkData;

        //‚For each module write out the REST service parameters to propFile

        //‚'uri.path.template= '
        WrkData = 'uri.path.template=';
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;

        //‚'<module>.uri.path.template=' (when wrap input parm is false)
        if (p_ServiceTyp = '*RESTDFT');
        if YWRPINP = 'false';
           WrkData = %trim(p_ModName) + '.uri.path.template=';
           WrkData = %trim(WrkData)   + '/' + %trim(method_uri);
           for index = 1 to MaxRtnElms;
              parindex = PListParDs(index).w_@@Par;
              if ( parindex <> 0 ); // Valid record exists
                 if ( MsgParUsgDs(parindex).ParUsg = 'I' );
                    if PListParDs(parindex).w_ParFmt = 'FLD';
                       WrkData = %trim(WrkData) + '/{var_' + %char(index) + '}';
                    endif;
                 endif;
              endif;
           endfor;

           rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
           if rc <> 0;
              exsr *pssr;
           endif;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        if (p_ServiceTyp = '*RESTCFG');
        WrkWRPINP  = %xlate(uppercase : lowercase :
                           WrkPrcRMIDtls.WRPINP  );
        WrkURIPATH = %xlate(uppercase : lowercase :
                           WrkPrcRMIDtls.URIPATH );
        if WrkWRPINP = 'false';
           WrkData = %trim(p_ModName) + '.uri.path.template=';
           WrkData = %trim(WrkData)   + '/' + %trim(WrkURIPATH);
           for index = 1 to MaxRtnElms;
              parindex = PListParDs(index).w_@@Par;
              if ( parindex <> 0 ); // Valid record exists
                 if ( MsgParUsgDs(parindex).ParUsg = 'I' );
                    if PListParDs(parindex).w_ParFmt = 'FLD';
                       WrkData = %trim(WrkData) + '/{var_' + %char(index) + '}';
                    endif;
                 endif;
              endif;
           endfor;

           rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
           if rc <> 0;
              exsr *pssr;
           endif;
        endif;
        endif;

        //‚'<module>.wrap.input.parameters='
        if p_ServiceTyp = '*RESTDFT';
        WrkData = %trim(p_ModName) + '.wrap.input.parameters=' +
                                                  %trim(YWRPINP);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        if p_ServiceTyp = '*RESTCFG';
        WrkWRPINP  = %xlate(uppercase : lowercase :
                           WrkPrcRMIDtls.WRPINP  );
        WrkData = %trim(p_ModName) + '.wrap.input.parameters=' +
                                                  %trim(WrkWRPINP);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚'<module>.wrap.output.parameters='
        if p_ServiceTyp = '*RESTDFT';
        WrkData = %trim(p_ModName) + '.wrap.output.parameter=' +
                                                  %trim(YWRPOUT);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        if p_ServiceTyp = '*RESTCFG';
        WrkWRPOUT  = %xlate(uppercase : lowercase :
                           WrkPrcRMIDtls.WRPOUT  );
        WrkData = %trim(p_ModName) + '.wrap.output.parameter=' +
                                                  %trim(WrkWRPOUT);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚'<module>.http.request.method='
        If p_ServiceTyp = '*RESTDFT';
        WrkData = %trim(p_ModName) + '.http.request.method=' +
                                                  %trim(httpVerb);
        If WrkData <> *blanks;
           rc = fmtRESTData( '*RESTDATA' : WrkData );
        endif;
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        If p_ServiceTyp = '*RESTCFG';
        WrkREQMETHOD = %xlate(lowercase : uppercase :
                           WrkPrcRMIDtls.REQMETHOD );
        WrkData = %trim(p_ModName) + '.http.request.method=' +
                                               %trim(WrkREQMETHOD);
        If WrkData <> *blanks;
           rc = fmtRESTData( '*RESTDATA' : WrkData );
        endif;
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚'<module>.consumes='
        If p_ServiceTyp = '*RESTDFT';
        select;
           when YRSTINP = '*XML';
              content_type = 'application/xml';
           when YRSTINP = '*JSON';
              content_type = 'application/json';
           when YRSTINP = '*ALL';
              content_type = '*/*';
           when YRSTINP = '*XML_AND_JSON';
              content_type = 'application/xml,application/json';
        endsl;

        if ( ( %trim(httpVerb) = 'PUT' ) or
             ( %trim(httpVerb) = 'POST') );
             content_type = 'application/json';
        endif;

        WrkData = %trim(p_ModName) + '.consumes=' + %trim(content_type);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        If p_ServiceTyp = '*RESTCFG';
        WrkCONSUMES = %xlate(lowercase:uppercase:WrkPrcRMIDtls.CONSUMES);
        select;
           when WrkCONSUMES = '*XML';
              content_type = 'application/xml';
           when WrkCONSUMES = '*JSON';
              content_type = 'application/json';
           when WrkCONSUMES = '*ALL';
              content_type = '*/*';
           when WrkCONSUMES = '*XML_AND_JSON';
              content_type = 'application/xml,application/json';
        endsl;

        //if ( ( %trim(httpVerb) = 'PUT' ) or
        //    ( %trim(httpVerb) = 'POST') );
        //     content_type = 'application/json';
        //endif;

        WrkData = %trim(p_ModName) + '.consumes=' + %trim(content_type);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚'<module>.produces='
        If p_ServiceTyp = '*RESTDFT';
        select;
           when YRSTOUT = '*XML';
              content_out = 'application/xml';
           when YRSTOUT = '*JSON';
              content_out = 'application/json';
           when YRSTOUT = '*XML_AND_JSON';
              content_out = 'application/xml,application/json';
        endsl;

        WrkData = %trim(p_ModName) + '.produces=' + %trim(content_out);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚If Service Type - '*RESTCFG'
        If p_ServiceTyp = '*RESTCFG';
        WrkPRODUCES = %xlate(lowercase:uppercase:WrkPrcRMIDtls.PRODUCES);
        select;
           when WrkPRODUCES = '*XML';
              content_out = 'application/xml';
           when WrkPRODUCES = '*JSON';
              content_out = 'application/json';
           when WrkPRODUCES = '*XML_AND_JSON';
              content_out = 'application/xml,application/json';
        endsl;

        WrkData = %trim(p_ModName) + '.produces=' + %trim(content_out);
        rc = fmtRESTData( '*RESTDATA' : %trim(WrkData) );
        if rc <> 0;
           exsr *pssr;
        endif;
        endif;

        //‚'<module>.response.code.parameter='
        WrkData = %trim(p_ModName) + '.response.code.parameter=';
        for index = 1 to MaxRtnElms;
           if ( PListParDs(index).w_@@Par <> 0 );
              rc = rtvParName( YPARDTL :
                               PListParDs(index).w_ParFmt :
                               PListParDs(index).w_@@Acp  : WrkParName );
              if rc <> 0;
                 exsr *pssr;
              endif;

              if ( (%trim(WrkParName) = 'httpStatus') OR
                   (%trim(WrkParName) = 'FLD_httpStatus') );
                 WrkData = %trim(WrkData) + %trim(WrkParName);
                 leave;
              endif;
           endif;
        endfor;

        rc = fmtRESTData( '*RESTDATA' : WrkData );
        if rc <> 0;
           exsr *pssr;
        endif;

        //‚'<module>.http.headers.parameter='
        WrkData = %trim(p_ModName) + '.http.headers.parameter=';
        for index = 1 to MaxRtnElms;
           if ( PListParDs(index).w_@@Par <> 0 );
              rc = rtvParName( YPARDTL :
                               PListParDs(index).w_ParFmt :
                               PListParDs(index).w_@@Acp  : WrkParName );
              if rc <> 0;
                 exsr *pssr;
              endif;

              if ( (%trim(WrkParName) = 'httpHeaders') OR
                   (%trim(WrkParName) = 'ARR_httpHeaders') );
                 WrkData = %trim(WrkData) + %trim(WrkParName);
                 leave;
              endif;
           endif;
        endfor;

        rc = fmtRESTData( '*RESTDATA' : WrkData );
        if rc <> 0;
           exsr *pssr;
        endif;

        //‚'<module>.inputfld.pathparam='
        for index = 1 to MaxRtnElms;
           parindex = PListParDs(index).w_@@Par;
           if ( parindex <> 0 ); // Valid record exists
              if ( MsgParUsgDs(parindex).ParUsg = 'I' );
                 if PListParDs(parindex).w_ParFmt = 'FLD';
                    rc = rtvParName( YPARDTL :
                                     PListParDs(index).w_ParFmt :
                                     PListParDs(index).w_@@Acp  : WrkParName);
                    if rc <> 0;
                       exsr *pssr;
                    endif;
                    if WrkParName <> *blanks;
                       //‚Process retrieved name to replace special characters
                      WrkParName = %trim(%xlate(CharsFrom:CharsTo:WrkParName));
                      WrkParName = %trim(%xlate(SingleQuote:' ':WrkParName));
                      WrkParName = %trim(%xlate(DoubleQuote:' ':WrkParName));
                      WrkParName = %trim(%xlate(' ':'_':%trim(WrkParName)));
                    endif;
                    WrkData = %trim(p_ModName) + '.' + %trim(WrkParName) +
                                    '.pathparam=' + 'var_' + %char(index);
                    rc = fmtRESTData( '*RESTDATA' : WrkData );
                    if rc <> 0;
                       exsr *pssr;
                    endif;
                 endif;
              endif;
           endif;
        endfor;

        return 0;

        //‚Subroutines
        begsr  zzinit;

           //‚Retrieve the functions surrogate based on function name
       //*    exec sql
       //*       select @@OBJ, OBJNME into :WrkObjDtlDs
       //*          from YMDLOBJRFP where IMPNME = :p_ModName;
          SQLER6 = 5;                                                           //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
           if SQLCODE <> 0;
              exsr *pssr;
           endif;

           if p_ServiceTyp = '*RESTDFT';
              httpVerbPos = %scan( '_' : WrkObjDtlDs.WrkMdlNme );
              if httpVerbPos > 0;
                 httpVerb = %subst( WrkObjDtlDs.WrkMdlNme : 1 :
                                              ( httpVerbPos - 1 ) );
                 method_uri = %subst( WrkObjDtlDs.WrkMdlNme :
                                              ( httpVerbPos + 1 ) );
              else;
                 httpVerb = 'GET';
                 method_uri = WrkObjDtlDs.WrkMdlNme;
              endif;
              httpVerb = %xlate(lowercase : uppercase : httpVerb);
           endif;

           if p_ServiceTyp = '*RESTCFG';
              //‚Retrieve the resoure method information of related module
              //‚from the YPRCRMIRFP file and store in Data Structure
       //*       exec sql
       //*          select *  into :WrkPrcRMIDtls
       //*             from YPRCRMIRFP where @@WEBSRV = :p_@@WEBSRV and
       //*                                   @@SRVPGM = :p_@@SRVPGM and
       //*                                   MODNAM   = :p_ModName     ;
          SQLER6 = 6;                                                           //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
              if SQLCODE <> 0;
                 exsr *pssr;
              endif;
           endif;

           //‚Declare PLISTPARCSR cursor
       //*    exec sql
       //*         declare PLISTPARCSR cursor for
       //*                 select @@PAR, @@ACP, PARFMT
       //*                 from   YMSGPARRFP  where @@MSG = :WrkObjDtlDs.WrkSgt
       //*                 order by @@MSG, @@PAR;

           //‚Retreive the YPARDTLRFA data area value                       rySorted flags
           QDtaAra.Lib = '*LIBL';
           reset QUSEC;
           QDtaAra.Obj = 'YPARDTLRFA';
           YPARDTL = rtvdtaara( QDtaara : QUSEC );
           if QUSEC.ErrBytesAvail > 0;
              exsr *pssr;
           endif;

           //‚Retreive the YRSTINPRFA data area value                       rySorted flags
           QDtaAra.Lib = '*LIBL';
           reset QUSEC;
           QDtaAra.Obj = 'YRSTINPRFA';
           YRSTINP = rtvdtaara( QDtaara : QUSEC );
           if QUSEC.ErrBytesAvail > 0;
              exsr *pssr;
           endif;
           YRSTINP = %xlate(lowercase : uppercase : YRSTINP);

           //‚Retreive the YRSTOUTRFA data area value                       rySorted flags
           QDtaAra.Lib = '*LIBL';
           reset QUSEC;
           QDtaAra.Obj = 'YRSTOUTRFA';
           YRSTOUT = rtvdtaara( QDtaara : QUSEC );
           if QUSEC.ErrBytesAvail > 0;
              exsr *pssr;
           endif;
           YRSTOUT = %xlate(lowercase : uppercase : YRSTOUT);

           //‚Retreive the YWRPINPRFA data area value                       rySorted flags
           QDtaAra.Lib = '*LIBL';
           reset QUSEC;
           QDtaAra.Obj = 'YWRPINPRFA';
           YWRPINP = rtvdtaara( QDtaara : QUSEC );
           if QUSEC.ErrBytesAvail > 0;
              exsr *pssr;
           endif;
           YWRPINP = %xlate(uppercase : lowercase : YWRPINP);

           //‚Retreive the YWRPOUTRFA data area value                       rySorted flags
           QDtaAra.Lib = '*LIBL';
           reset QUSEC;
           QDtaAra.Obj = 'YWRPOUTRFA';
           YWRPOUT = rtvdtaara( QDtaara : QUSEC );
           if QUSEC.ErrBytesAvail > 0;
              exsr *pssr;
           endif;
           YWRPOUT = %xlate(uppercase : lowercase : YWRPOUT);

           //‚Call rtvDesiredNameUsg to initialize the ParArySorted and PdtArySorted flags
           rc = rtvDesiredNameUsg();
           if rc <> 0;
              exsr *pssr;
           endif;

        endsr;

        begsr  *pssr;

           if fd < 0 or rtn < 0;
              errno@ = geterrno();
              if errno@ <> *null and errno > 0;
                IFS_ERR_MSGID.errno = errno;
                sndPgmMsg( IFS_ERR_MSGID : *blanks : '*ESCAPE' );
              else;
                if EXCP_MSGID <> *blanks;
                  sndPgmMsg( EXCP_MSGID : *blanks : '*ESCAPE' );
                else;
                  sndPgmMsg( 'CPF9898' : 'Error in YPRCRSTDTA' :
                             '*ESCAPE' );
                endif;
              endif;
           endif;

           rtn = close( fd );

           return  -1;

        endsr;

      /end-free
     P prcRESTData     E

      *‚--------------------------------------------------------------------------------------------
      *‚rtvDesiredNameUsg(): Retrieve the desired name and usage of entity from MSGPAR/MSGPDT arrays
      *‚--------------------------------------------------------------------------------------------
     P rtvDesiredNameUsg...
     P                 B                   export
     D rtvDesiredNameUsg...
     D                 pi            10I 0
     D  P_AttrValue                  15A   const varying options(*nopass)
     D  P_ParSgt                      7P 0               options(*nopass)
     D  P_2EName                     40A         varying options(*nopass)
     D  P_2EUsage                    11A         varying options(*nopass)

      *‚--------------------------------------------------------------------------------------------
     D resultPar@      s               *
     D resultPdt@      s               *
     D resultParDs     ds                  likeds(WrkParDs_t) based(resultPar@)
     D resultPdtDs     ds                  likeds(WrkPdtDs_t) based(resultPdt@)

     D Idx             s                   inz like(Idx_t)
     D StrPos          s              5I 0 inz
     D EndPos          s              5I 0 inz
     D Lcl2EName       s                   inz like(GblName)
     D WrkImpNme       s                   inz like(MdlObjExtDs_t.IMPNME)
     D WrkModName      s                   inz like(GblName)
     D WrkParName      s                   inz like(GblName)
     D WrkFldName      s                   inz like(GblName)

     D SavParSgt       s                   like(WrkPdtDs_t.ParSgt) static
     D WrkParNbr       s              3S 0 inz                     static
     D ParArySorted    s               n   static
     D PdtArySorted    s               n   static

     D*CharsFrom       s             28A   inz('-~ $!@%*:/\#;?,.=^<>|+(){}[]')
     D CharsFrom       s             28A   inz(' ')
     D CharsTo         s             28A   inz('                            ')
     D SingleQuote     s              1A   inz('''')
     D DoubleQuote     s              1A   inz('"')

     D ParDtl          s              4A   inz
     D ParUsage        s              1A   inz
     D QDtaAra         ds                  inz likeds(qObj_t)
      *‚--------------------------------------------------------------------------------------------
      /free

        // Retreive the YPARDTLRFA data area value
        // If the value is *YES, include additional info on parameter
        QDtaAra.Lib = '*LIBL';
        reset QUSEC;
        QDtaAra.Obj = 'YPARDTLRFA';
        ParDtl = rtvdtaara( QDtaara : QUSEC );
         if QUSEC.ErrBytesAvail > 0;
            exsr *pssr;
         endif;

        if %parms = 0;
           SavParSgt    = *zeros;
           WrkParNbr    = *zeros;
           ParArySorted = *off;
           PdtArySorted = *off;
           return 0;
        endif;

        //‚Sort MsgParDs by PListName
        if ParArySorted = *off;
           qsort( %addr( MsgParDs ) : MsgParElems : %size( WrkPards_t ) :
                                                    %paddr( CmpbyParName ) );
           if %error;
              exsr *pssr;
             endif;
           ParArySorted = *on;
        endif;

        //‚Search for matching element in MsgParDs
        clear ParKey;
        ParKey.PListName = %trim(P_AttrValue);
        resultPar@  = bsearch( %addr( ParKey )    :
                               %addr( MsgParDs )  :
                               MsgParElems        :
                               %size( WrkParDs_t) :
                               %paddr( CmpbyParName ) );
        if %error;
           exsr *pssr;
        endif;

        //‚The element in an interface parameter
        if resultPar@ <> *NULL;
           clear P_2EName;

           rc = rtvParName( ParDtl : resultParDs.ParFmt :
                            resultParDs.AcpSgt : WrkParName );
           if rc <> 0;
              exsr *pssr;
                 endif;

           LcL2EName = %trim(WrkParName);

           //‚Obtain the 2E Usage Name of interface parameter
           parUsage = MsgParUsgDs(resultParDs.ParSgt).ParUsg;

           select;
              when parUsage = 'I';
                   P_2EUsage = 'input';
              when parUsage = 'O';
                   P_2EUsage = 'output';
              when parUsage = 'B';
                   P_2EUsage = 'inputoutput';
              other;
                   P_2EUsage = *blanks;
           endsl;
        endif;

        //‚We are only interested in MSGPAR details - interface parms
        //‚Hence removed the MSGPDT related details from this module!

        P_2EName = Lcl2EName;

        return 0;

        begsr *pssr;
          return -1;
        endsr;

      /end-free
     P rtvDesiredNameUsg...
     P                 E

      *‚--------------------------------------------------------------------------------------------
      *‚rtvParName() - Retrieve the desired name of the parameter
      *‚--------------------------------------------------------------------------------------------
     P rtvParName      B                   export
     D rtvParName      pi            10I 0
     D  P_ParDtl                      4    const
     D  P_ParFmt                           const like(MsgParExtDs_t.ParFmt)
     D  P_ObjSgt                           const like(MsgParExtDs_t.@@MSG)
     D  P_DesiredName                      like(GblName)

     D WrkDtlDs        ds                  qualified inz
     D    ObjNme                           like(MdlObjExtDs_t.OBJNME)
     D    ObjAtr                           like(MdlObjExtDs_t.OBJATR)
     D    ObjOwn                           like(MdlObjExtDs_t.OBJOWN)

      *‚Work Variables
     D WrkParFmt       s                   inz  like(MsgParExtDs_t.ParFmt)

      /free

       //* exec sql
       //*    select OBJNME, OBJATR, OBJOWN into :WrkDtlDs from YMDLOBJRFP
       //*           where @@OBJ = :P_ObjSgt;
          SQLER6 = 7;                                                           //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
        if SQLSTT = SqlSttNoRow;
           exsr *pssr;
        endif;

        //‚Obtain the desired name of the parameter
        select;
           when P_ParFmt = 'FLD';
              if P_ParDtl = '*NO';
                 P_DesiredName = %trim(WrkDtlDs.OBJNME);
              else;
                 P_DesiredName = 'FLD_' + %trim(WrkDtlDs.OBJNME);
              endif;

           when ( (P_ParFmt = 'RCD') or (P_ParFmt = 'KEY') );
              if P_ParDtl = '*NO';
                 P_DesiredName = %trim(WrkDtlDs.OBJOWN);

              else;
                 P_DesiredName = 'FIL_' +  %trim(WrkDtlDs.OBJOWN) + '_' +
                           %trim(WrkDtlDs.OBJATR) + '_' + P_ParFmt;
              endif;

           when ( (P_ParFmt = 'RAR') or (P_ParFmt = 'KAR') );
              if P_ParFmt  = 'RAR';
                 WrkParFmt = 'RCD';
              else;
                 WrkParFmt = 'KEY';
              endif;
              if P_ParDtl = '*NO';
                 P_DesiredName = %trim(WrkDtlDs.OBJNME);
              else;
                 P_DesiredName = 'ARR_' + %trim(WrkDtlDs.OBJNME) +
                                                  '_' + WrkParFmt;
              endif;

           other;
              exsr *pssr;
        endsl;

        return  0;

        //‚Subroutines
        begsr  *pssr;
          P_DesiredName = *blanks;
          return  -1;
        endsr;

      /end-free
     P rtvParName      E

      *‚--------------------------------------------------------------------------------------------
      *‚rtvFldName() - Retrieve the desired name of the field
      *‚--------------------------------------------------------------------------------------------
     P rtvFldName      B                   export
     D rtvFldName      pi            10I 0
     D  P_ObjSgt                           const like(MsgParExtDs_t.@@MSG)
     D  P_ImpNme                           like(MdlObjExtDs_t.IMPNME)
     D  P_DesiredName                      like(GblName)

      *‚Work Variables
     D WrkDtlDs        ds                  qualified inz
     D    ImpNme                           like(MdlObjExtDs_t.IMPNME)
     D    ObjNme                           like(MdlObjExtDs_t.OBJNME)

      /free

       //* exec sql
       //*    select IMPNME, OBJNME into :WrkDtlDs from YMDLOBJRFP
       //*           where @@OBJ = :P_ObjSgt;
          SQLER6 = 8;                                                           //SQL
          SQLROUTE_CALL(                                                        //SQL
               SQLCA                                                            //SQL
          );                                                                    //SQL
        if SQLSTT = SqlSttNoRow;
           exsr *pssr;
        endif;

        P_ImpNme      = WrkDtlDs.ImpNme;
        P_DesiredName = WrkDtlDs.ObjNme;

        return  0;

        //‚Subroutines
        begsr  *pssr;
           P_ImpNme      = WrkDtlDs.ImpNme;
           P_DesiredName = WrkDtlDs.ObjNme;
           return  -1;
        endsr;

      /end-free
     P rtvFldName      E

      *‚--------------------------------------------------------------------------------------------
      *‚CmpbyParName() - Sequencing routine for sorting MsgParDs on PListName
      *‚--------------------------------------------------------------------------------------------
     P CmpbyParName    B
     D CmpbyParName    pi            10I 0
     D   P_element_1                       likeds(WrkParDs_t)
     D   P_element_2                       likeds(WrkParDs_t)

      /free

        select;
           when ( P_element_1.PListName < P_element_2.PListName );
              return -1;
           when ( P_element_1.PListName > P_element_2.PListName );
              return 1;
           other;
              return 0;
        endsl;

        return 0;

      /end-free
     P CmpbyParName    E
