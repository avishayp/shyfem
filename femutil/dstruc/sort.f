!
! sort routines (heap sort)
!
!**************************************************************
!
! call as	call sort(n,array)		for direct sort
! call as	call sort(n,array,index)	for indirect sort
!
!	array can be integer or real
!
!==============================================================
	module sort
!==============================================================

	private

	public :: sort_array

        INTERFACE sort_array
        MODULE PROCEDURE        
     +				 sort_direct_i		!(n,array)
     +                          ,sort_indirect_i	!(n,array,index)
     +				,sort_direct_r		!(n,array)
     +                          ,sort_indirect_r	!(n,array,index)
        END INTERFACE

!==============================================================
	contains
!==============================================================

      SUBROUTINE SORT_direct_i(N,RA)

! heapsort (direct)

      implicit none

      integer n
!      real ra(n)
      integer ra(n)

      integer i,ir,j,l
!      real rra
      integer rra

      if(n.lt.2) return

      L=N/2+1
      IR=N
      do
        IF(L.GT.1)THEN
          L=L-1
          RRA=RA(L)
        ELSE
          RRA=RA(IR)
          RA(IR)=RA(1)
          IR=IR-1
          IF(IR.EQ.1)THEN
            RA(1)=RRA
            RETURN
          ENDIF
        ENDIF
        I=L
        J=L+L
        do while(J.LE.IR)
          IF(J.LT.IR)THEN
            IF(RA(J).LT.RA(J+1))J=J+1
          ENDIF
          IF(RRA.LT.RA(J))THEN
            RA(I)=RA(J)
            I=J
            J=J+J
          ELSE
            J=IR+1
          ENDIF
	end do
        RA(I)=RRA
      end do
      END

!******************************************************************

      SUBROUTINE sort_indirect_i(N,RA,index)

! heapsort (indirect)

      implicit none

      integer n
      integer ra(n)
      integer index(n)

      integer i,ir,j,l,irra
      integer rra

      do i=1,n
        index(i)=i
      end do

      if(n.lt.2) return

      L=N/2+1
      IR=N
      do
        IF(L.GT.1)THEN
          L=L-1
	  irra=index(l)
          RRA=RA(irra)
        ELSE
	  irra=index(ir)
          RRA=RA(irra)
          index(ir)=index(1)
          IR=IR-1
          IF(IR.EQ.1)THEN
            index(1)=irra
            RETURN
          ENDIF
        ENDIF
        I=L
        J=L+L
        do while(J.LE.IR)
          IF(J.LT.IR)THEN
            IF(RA(index(j)).LT.RA(index(J+1)))J=J+1
          ENDIF
          IF(RRA.LT.RA(index(j)))THEN
            index(i)=index(j)
            I=J
            J=J+J
          ELSE
            J=IR+1
          ENDIF
	end do
        index(i)=irra
      end do
      END

!******************************************************************

      SUBROUTINE SORT_direct_r(N,RA)

! heapsort (direct)

      implicit none

      integer n
      real ra(n)
!      integer ra(n)

      integer i,ir,j,l
      real rra
!      integer rra

      if(n.lt.2) return

      L=N/2+1
      IR=N
      do
        IF(L.GT.1)THEN
          L=L-1
          RRA=RA(L)
        ELSE
          RRA=RA(IR)
          RA(IR)=RA(1)
          IR=IR-1
          IF(IR.EQ.1)THEN
            RA(1)=RRA
            RETURN
          ENDIF
        ENDIF
        I=L
        J=L+L
        do while(J.LE.IR)
          IF(J.LT.IR)THEN
            IF(RA(J).LT.RA(J+1))J=J+1
          ENDIF
          IF(RRA.LT.RA(J))THEN
            RA(I)=RA(J)
            I=J
            J=J+J
          ELSE
            J=IR+1
          ENDIF
	end do
        RA(I)=RRA
      end do
      END

!******************************************************************

      SUBROUTINE sort_indirect_r(N,RA,index)

! heapsort (indirect)

      implicit none

      integer n
!      integer ra(n)
      real ra(n)
      integer index(n)

      integer i,ir,j,l,irra
!      integer rra
      real rra

      do i=1,n
        index(i)=i
      end do

      if(n.lt.2) return

      L=N/2+1
      IR=N
      do
        IF(L.GT.1)THEN
          L=L-1
	  irra=index(l)
          RRA=RA(irra)
        ELSE
	  irra=index(ir)
          RRA=RA(irra)
          index(ir)=index(1)
          IR=IR-1
          IF(IR.EQ.1)THEN
            index(1)=irra
            RETURN
          ENDIF
        ENDIF
        I=L
        J=L+L
        do while(J.LE.IR)
          IF(J.LT.IR)THEN
            IF(RA(index(j)).LT.RA(index(J+1)))J=J+1
          ENDIF
          IF(RRA.LT.RA(index(j)))THEN
            index(i)=index(j)
            I=J
            J=J+J
          ELSE
            J=IR+1
          ENDIF
	end do
        index(i)=irra
      end do
      END

!==============================================================
	end module sort
!==============================================================

!******************************************************************
!******************************************************************
!******************************************************************

	subroutine sort_test

	use sort

	implicit none

	integer ndim,nmax
	parameter (ndim=20000)
	parameter (nmax=100000)

	real ra(ndim)
	integer ia(ndim)
	integer ind(ndim)

	integer i,ir,n,iaold,ianew
	real r,raold,ranew

	n = ndim

	do i=1,n
	  call sort_rand_int(1,nmax,ir)
	  ia(i) = ir
	  call random_number(r)
	  ra(i) = r*nmax
	end do

	write(6,*) 'sorting integer indirect: ',n
        call sort_array(n,ia,ind)		!indirect sort

	iaold = -1
	do i=1,n
	  ianew = ia(ind(i))
	  !write(6,*) i,ianew
	  if( ianew < iaold ) stop 'error stop: inconsistency i indirect'
	  iaold = ianew
	end do

	write(6,*) 'sorting integer direct: ',n
        call sort_array(n,ia)			!direct sort

	iaold = -1
	do i=1,n
	  ianew = ia(i)
	  !write(6,*) i,ianew
	  if( ianew < iaold ) stop 'error stop: inconsistency i direct'
	  iaold = ianew
	end do

	ind = 0
	write(6,*) 'sorting real indirect: ',n
        call sort_array(n,ra,ind)		!indirect sort

	raold = -1
	do i=1,n
	  ranew = ra(ind(i))
	  !write(6,*) i,ranew
	  if( ranew < raold ) stop 'error stop: inconsistency r indirect'
	  raold = ranew
	end do

	write(6,*) 'sorting real direct: ',n
        call sort_array(n,ra)			!direct sort

	raold = -1
	do i=1,n
	  ranew = ra(i)
	  !write(6,*) i,ranew
	  if( ranew < raold ) stop 'error stop: inconsistency r direct'
	  raold = ranew
	end do

	write(6,*) 'sort test successfully finished: ',ndim,nmax

	end
	  
!******************************************************************

        subroutine sort_assert(bcheck,text,id)
        !use sort
        implicit none
        logical bcheck
        character*(*) text
        integer id
        if( .not. bcheck ) then
          write(6,*) 'sort_assertion: ',trim(text)
          !call sort_info(id)
          stop 'assertion failed'
        end if
        end

        subroutine sort_rand_int(min,max,irand)
        implicit none
        integer min,max
        integer irand
        real r
        call random_number(r)
        irand = min + (max-min+1)*r
        end

!******************************************************************

!******************************************************************
	program sort_main
	call sort_test
	end
!******************************************************************


