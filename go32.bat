set bcc=bcc77
set path=c:\%bcc%\bin
set HB_USER_CFLAGS=-Ic:\%bcc%\INCLUDE\windows\crtl -Ic:\%bcc%\INCLUDE\windows\sdk
set HB_USER_LDFLAGS=-Lc:\%bcc%\LIB;c:\%bcc%\LIB\psdk
c:\harbour\bin\win\bcc\hbmk2.exe test.hbp -comp=bcc