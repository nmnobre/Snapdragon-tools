!
! MEMORY HIERARCHY DETECTION CODE
! THIS VERSION WRITTEN BY MARK BULL   8/9/97
! THIS VERSION REVISED BY NUNO NOBRE 22/3/17
!
      implicit none
      integer i,j,k,n,index,nops,iops,eops,npts,maxlength,stride,length
      parameter (nops=50000000,npts=100,maxlength=10000000)
      real x(maxlength)
      real lower,upper
      real res
      integer(kind=8) start, finish, time
      real(kind=8) time_sec, perf
      common /heap/ x
      character(len=32) myname
      character(len=32) ch
      integer mynamelength, reason
!
! INITIALISE VECTOR DATA
!
        do i=maxlength,1,-1
          x(i) =  3.142
        end do
        res=0.0
!
! USE NON-UNIT STRIDE TO REDUCE REUSE OF CACHE LINES
        call get_command_argument(1, ch)
        read(ch,*,IOSTAT=reason) stride
        if (reason .gt. 0) then
          call get_command_argument(0, myname, mynamelength)
          write(*,"(3A,/,T9,A,/,T9,2A,/,T17,2A,/,T17,2A)") "usage: ",
     $           myname(3:mynamelength),
     $           " [-h] stride",
     $           "-h: prints this message",
     $           "stride: the distance between fetched array elements ",
     $           "(default: 16)",
     $           "as an array of single-precision floating-point ",
     $           "values is ",
     $           "used, the fetched elements are 4*stride ",
     $           "bytes apart in memory"
          stop
        else if (reason .lt. 0) then
          stride=16
        end if
!
        print *, "Length     Time     Mflop/s"
! USE NPTS POINTS EQUALLY SPACED (LOGARITHMICALLY) BETWEEN LOWER
! UPPER BOUNDS
        lower=100.
        upper=real(maxlength)
        do j=1,npts
           n=int(exp(log(lower)+log(upper/lower)*
     $           real(j-1)/real(npts-1))) 
           iops=ceiling(n*1.0/stride)
           eops=nint(nops*1.0/iops)
! START TIMING
           call SYSTEM_CLOCK(start)
! REPEATED VECTOR SUMS
           do i=1,eops
              do k=1,iops
                 index=merge((iops-k/2)*stride+1,(k-1)/2*stride+1,
     $             mod(k,2) .eq. 0)
                 res=res+x(index)
              end do
           end do
! END TIMING 
           call SYSTEM_CLOCK(finish)
           time=finish-start
! PREVENT DEAD CODE ELIMINATION!
           if (res .lt. 0.0) print *,res
! PRINT RESULTS
           length = 4*n
           time_sec = nops*1.0/(iops*eops)*(time*1.0/1000000000)
           perf = nops*1.0/time_sec/1000000
           print *, length, time_sec, perf
        end do
!
      end