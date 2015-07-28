# Python functools wraps and partial

Official documenation is [here](https://docs.python.org/2/library/functools.html)

## partial

partial is just like the C++ bind mechanism, it is used to degrade the order of function.

> In mathematics and computer science, currying is the technique of translating the evaluation of a function 
> that takes multiple arguments (or a tuple of arguments) into evaluating a sequence of functions, 
> each with a single argument (partial application). 
> It was introduced by Moses Schönfinkel and later developed by Haskell Curry.

from [Wikipedia: Currying](https://en.wikipedia.org/wiki/Currying)

also notice the great figure behind the currying:

> Haskell Brooks Curry (/ˈhæskəl ˈkɜri/; September 12, 1900 – September 1, 1982) was an American mathematician and logician. 
> ...
> There are three programming languages named after him, Haskell, Brooks and Curry, as well as the concept of currying, 
> a technique used for transforming functions in mathematics and computer science.

from [Wikipedia: Haskell Curry](https://en.wikipedia.org/wiki/Haskell_Curry)

In my own words, currying is just turns a function with multiple paramters 
into a series of functions with just one parameter (maybe combined with an function parameter).

## wraps

wrapper provide a mechanism for decorating functions with modifying their prototypes.
It is very useful for documentation.

Let's see an example:

            from functools import wraps

            def my_decorator(func):
	            @wraps(func)
	            def wrapper(*args, **kwds):
		            print "invoking ", func.__name__, "(", args, ", ", kwds, " )"
		            print func.__doc__
		            return func(*args, **kwds)
	            return wrapper

            @my_decorator
            def example(name, **properties):
	            '''This is used for documentation.'''
	            print "This is the demo function"

            example("Daniel King", gender="Male", company="Keen")

and result is:

            invoking  example ( ('Daniel King',) ,  {'gender': 'Male', 'company': 'Keen'}  )
            This is used for documentation.
            This is the demo function
