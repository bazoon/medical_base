def thisRaisesAZeroDivisionError():
    x = 1/0

def thisRaisesAValueError():
    y = int('Five')

def thisDoesNotRaiseAnyErrors():
    z = 'just a string'

def tryExercise():
    print 'A',
    thisRaisesAZeroDivisionError()
    try:
        # Line Of Code Is Inserted Here #
        print 'B',
    except AZeroDivisionError as e:
        print 'C',
    else:
        print 'D',
    finally:
        print 'E',
    print 'F'


tryExercise()