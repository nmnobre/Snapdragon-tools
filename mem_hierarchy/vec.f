!
! MEMORY HIERARCHY DETECTION CODE
! THIS VERSION WRITTEN BY MARK BULL 8/9/97
! THIS VERSION REVISED BY NUNO NOBRE 14/3/17
!
      integer i,j,n,m,nops,npts,maxlength,stride,length
      parameter (nops=50000000,npts=100,maxlength=10000000)
      real x(maxlength)
      real lower,upper
      real time,junk(2)
      real res
      integer iops
      common /heap/ x 
      character(len=32) ch
!
! INITIALISE VECTOR DATA
!
        do i=maxlength,1,-1
          x(i) =  3.142
        end do
        res=0.0
!
        print *, "Length     Time     Time (normalized)"
!
! USE NON-UNIT STRIDE TO REDUCE REUSE OF CACHE LINES
        CALL getarg(1, ch)
        read(ch,'(i4)') stride
! USE NPTS POINTS EQUALLY SPACED (LOGARITHMICALLY) BETWEEN LOWER
! UPPER BOUNDS
        lower=100.
        upper=real(maxlength)
        do j=1,npts
           n=int(exp(log(lower)+log(upper/lower)*
     $           real(j-1)/real(npts-1)))
           m=nops/n
           iops=ceiling(n*1.0/stride)
! START TIMING
           time= etime(junk)
! REPEATED VECTOR SUMS
           do i=1,m*stride
              do k=1,iops
                 index=merge((iops-k/2)*stride+1,(k-1)/2*stride+1,
     $             mod(k,2) .eq. 0)
                 res=res+x(index)
              end do
           end do
! END TIMING 
           time=etime(junk)-time
! PREVENT DEAD CODE ELIMINATION!
           if (res .lt. 0.0) print *,res
! PRINT RESULTS
           length = 4*n
           timeNorm = nops*1.0/(iops*m*stride)*time
           print *, length, time, timeNorm
        end do
!
      end